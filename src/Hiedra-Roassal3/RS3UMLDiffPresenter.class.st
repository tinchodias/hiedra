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
	renderer methodShape:
		(HiMUMLDiffUtils new shapeForMethod
			when: TSMouseClick do: [ :anIceNode | [ self onMouseClickFor: anIceNode ] ];
			yourself).
	renderer classNameShape:
		(HiMUMLDiffUtils new shapeForClassOrTrait
			when: TSMouseClick do: [ :anIceNode | [ self onMouseClickFor: anIceNode ] ];
			yourself).
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
