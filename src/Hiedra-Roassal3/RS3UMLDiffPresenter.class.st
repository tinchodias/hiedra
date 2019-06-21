Class {
	#name : #RS3UMLDiffPresenter,
	#superclass : #ComposablePresenter,
	#instVars : [
		'diffPresenter',
		'viewPresenter',
		'iceDiffModel'
	],
	#category : #'Hiedra-Roassal3-Examples-Iceberg'
}

{ #category : #specs }
RS3UMLDiffPresenter class >> defaultSpec [
	^ SpecBoxLayout newHorizontal
		add: #viewPresenter;
		spacing: 5;
		add: #diffPresenter;
		yourself
]

{ #category : #private }
RS3UMLDiffPresenter >> buildUMLDiffOn: view [
	| classesByName metaclassesByName builder classes metaclasses |
	iceDiffModel tree isEmpty ifTrue: [ ^self ].

	classesByName := Dictionary new.
	metaclassesByName := Dictionary new.

	self flag: #fix. "This method doesn't iterate over the class if only a contained method changed!!!"
	iceDiffModel tree allChildrenDo: [ :node |
		node value definition isClassDefinition ifTrue: [ 
			(node value definition isMeta
				ifFalse: [ classesByName  at: node key put: node ]
				ifTrue: [ metaclassesByName at: (node key allButLast: ' class' size) asSymbol put: node ]) ] ].

	builder := RSUMLClassBuilder new.
	builder view: view.

	builder classDescriptor
		classname: [ :node | node key asString ];
		instVars: [ :node | #() ];
		methods: [ :node |
			| metaclassMethods |
			metaclassMethods := metaclassesByName at: node key ifPresent: [:found | found children ] ifAbsent: [ #() ].
			node children, metaclassMethods ];
		superclass: [ :node | 
			| superclassName |
			superclassName := node value definition asMCDefinition superclassName.
			classesByName at: superclassName ifAbsent: [ nil ] ];
		methodSelector: [ :met | met key asString ].
	builder shape: (RSShapeBuilder composite 
		interactionDo: [ :i | i draggable; popupText: #key ];
		shapes: [ :m | builder createShapesFor: m ]).
	self setupRendererOn: builder.
	
	classes := classesByName values.
	metaclasses := metaclassesByName associations
		reject: [:each | classesByName includesKey: each key ]
		thenCollect: [:each | each value ].
	builder classes: classes, metaclasses.
	builder build.

	view addInteraction: RSControlsView
]

{ #category : #accessing }
RS3UMLDiffPresenter >> diffPresenter: aPresenter [
	diffPresenter := aPresenter

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
RS3UMLDiffPresenter >> setupRendererOn: builder [
	| renderer |
	renderer := builder renderer.
	renderer methodShape: self shapeForMethod.
	renderer classNameShape: self shapeForClassOrTrait.
	renderer classBoxShape cornerRadius: 3.
	renderer marker offset: 8.
	renderer marker shape size: 16.
	self setupSystemThemeOn: builder.

]

{ #category : #private }
RS3UMLDiffPresenter >> setupSystemThemeOn: b [
	
	| theme |
	theme := Smalltalk ui theme.
	b view color: theme backgroundColor.
	b renderer defaultBorder color: theme textColor.
	b renderer classBoxShape color: theme backgroundColor.
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
		if: [:node | node value definition isMethodDefinition and: [
				node value definition classIsMeta ] ] actions: [:s | s underline ].
		
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
