Class {
	#name : #RS3UMLDiffPresenter,
	#superclass : #ComposablePresenter,
	#instVars : [
		'diffPresenter',
		'viewPresenter',
		'iceDiffModel',
		'packageColorScale'
	],
	#category : #'Hiedra-Roassal3-Examples-Iceberg'
}

{ #category : #specs }
RS3UMLDiffPresenter class >> defaultSpec [
	^ SpecBoxLayout newVertical
		add: #viewPresenter;
		spacing: 5;
		add: #diffPresenter;
		yourself
]

{ #category : #private }
RS3UMLDiffPresenter >> addInteractions: view [
	| elements connectedClasses singleClasses foo hierElements |
	view 
		addInteraction: RSLightShapesView;
		addInteraction: RSControlsView.
	foo := RSTreeLayout new
		edges: view edges.
	elements := view elements.
	connectedClasses := elements select: #hasEdges.
	singleClasses := elements reject: #hasEdges.

	elements := (foo rootNodesFor: connectedClasses) collect: [ :e | 
		| group |
		group :=  TSGroup new.
		self fill: group with: e.
		group ]. 
	
	hierElements := elements, singleClasses.

	view when: TSExtentChangedEvent do: [ 
		RSRectanglePackLayout new
			gap: 0.5;
			preferredAngle: view extent angle;
			on: hierElements.
		view zoomToFit; signalUpdate ].

]

{ #category : #private }
RS3UMLDiffPresenter >> buildUMLDiffOn: view [
	| visitor builder classesByName metaclassesByName |
	visitor := RS3NodesEntityCollector new.
	iceDiffModel tree accept: visitor.
	
	classesByName := Dictionary new.
	metaclassesByName := Dictionary new.
	visitor nodesWithClasses do: [ :node |
		classesByName at: node key put: node ].
	visitor nodesWithMetaclasses do: [ :node |
		metaclassesByName at: (node key allButLast: ' class' size) put: node ].

	builder := RSUMLClassBuilder new.
	builder view: view.

	builder classDescriptor
		classname: [ :node | node key asString ];
		instVars: [ :node | #() ];
		methods: [ :node |
			| metaclassMethods |
			metaclassMethods := metaclassesByName at: node key ifPresent: [:found | found children ] ifAbsent: [ #() ].
			metaclassMethods, node children ];
		superclass: [ :node | 
			| superclassName |
			superclassName := node value definition asMCDefinition superclassName.
			classesByName at: superclassName ifAbsent: [ nil ] ];
		methodSelector: [ :met | met key asString ].
	builder shape: (RSShapeBuilder composite 
		interactionDo: [ :i | i draggable; popupText: #key ];
		shapes: [ :m | builder createShapesFor: m ]).
	builder renderer classBoxShape
		color: [ :node | (self packageColorScale scale: node key) alpha: 0.3 ].
	self setupRendererOn: builder.
	
	builder classes:  classesByName values..
	builder build.
	self addInteractions: view.
]

{ #category : #accessing }
RS3UMLDiffPresenter >> diffPresenter: aPresenter [
	diffPresenter := aPresenter

]

{ #category : #private }
RS3UMLDiffPresenter >> fill: group with: e [
	group add: e.
	e outgoingEdges do: [ :ed | 
		self fill: group with: ed to ].
]

{ #category : #accessing }
RS3UMLDiffPresenter >> iceDiffModel: anIceDiffModel [

	iceDiffModel := anIceDiffModel.
	viewPresenter refresh.
]

{ #category : #initialization }
RS3UMLDiffPresenter >> initializeWidgets [
	viewPresenter := self instantiate: RoassalPresenter.
	viewPresenter script: [ :view | self buildUMLDiffOn: view ].
]

{ #category : #private }
RS3UMLDiffPresenter >> onMouseClickFor: anIceNode [
	| fastTable index |
	fastTable := diffPresenter changeList widget.
	index := fastTable dataSource indexOfElement: anIceNode.
	fastTable selectIndex: index
]

{ #category : #private }
RS3UMLDiffPresenter >> packageColorScale [
	^ packageColorScale ifNil: [ packageColorScale := TSScale category10 ]
]

{ #category : #private }
RS3UMLDiffPresenter >> packageColorScale: aScale [
	packageColorScale := aScale
]

{ #category : #private }
RS3UMLDiffPresenter >> setupRendererOn: builder [
	| renderer |
	renderer := builder renderer.
	renderer methodShape: self shapeForMethod.
	renderer classNameShape: self shapeForClassOrTrait.
	renderer classBoxShape cornerRadius: 3.
	renderer marker offset: 8.
	renderer marker shape size: 16.
	renderer classBoxShape
		color: [ :node | (self packageColorScale scale: node parent key) alpha: 0.2 ].

	self setupSystemThemeOn: builder.

]

{ #category : #private }
RS3UMLDiffPresenter >> setupSystemThemeOn: b [
	
	| theme |
	theme := Smalltalk ui theme.
	b view color: theme backgroundColor.
	b renderer defaultBorder color: theme textColor.
	b renderer marker shape color: theme backgroundColor.

]

{ #category : #private }
RS3UMLDiffPresenter >> shapeForClassOrTrait [

	^ self shapeForNodeEmulatingCondensedFont: false bold: true
]

{ #category : #private }
RS3UMLDiffPresenter >> shapeForMethod [

	^ self shapeForNodeEmulatingCondensedFont: true bold: false
]

{ #category : #private }
RS3UMLDiffPresenter >> shapeForNodeEmulatingCondensedFont: isCondensed bold: isBold [

	| iconShape labelShape composite  |
	iconShape := RSShapeBuilder bitmap form: #icon.
	labelShape := RSShapeBuilder label
		color: Smalltalk ui theme textColor;
		onElement; 
		text: [ :e | HiTextWidthKeeper
			stringFor: e model key
			font: e font
			maxSize: 200 ];
		onModel;
		if: [:node | node value definition isMethodDefinition and: [ node value definition classIsMeta ] ]
		then: [:s | s underline ].
		
	isBold ifTrue: [ labelShape bold ].

	composite:=  RSShapeBuilder composite 
		shapes: [:node | 
			| g icon text |
			g := TSGroup new.
			icon := iconShape elementOn: node value.
			text := labelShape elementOn: node.

			isCondensed ifTrue: [ text scaleBy: (0.8@1) ].

			g add: icon; add: text.
			RSHorizontalLineLayout new alignCenter; gapSize: 2; on: g.
			g ];
		interactionDo: [:i | i popupText: [ :node | node key ] ];
		"addInteraction: (RSPopup text: [ :node | node value ] )"
		when: TSMouseClick do: [ :anIceNode | [ self onMouseClickFor: anIceNode ] ];
		yourself.

	^ composite
]
