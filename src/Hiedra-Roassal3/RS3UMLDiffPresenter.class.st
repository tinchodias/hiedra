Class {
	#name : #RS3UMLDiffPresenter,
	#superclass : #RS3DiffPresenter,
	#category : #'Hiedra-Roassal3-Examples-Iceberg'
}

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
RS3UMLDiffPresenter >> fill: group with: e [
	group add: e.
	e outgoingEdges do: [ :ed | 
		self fill: group with: ed to ].
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
