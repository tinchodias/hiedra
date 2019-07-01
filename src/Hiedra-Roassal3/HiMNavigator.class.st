Class {
	#name : #HiMNavigator,
	#superclass : #Object,
	#instVars : [
		'colors',
		'layout',
		'view',
		'random',
		'highlightable'
	],
	#category : #'Hiedra-Roassal3-Examples-MultigranularNavigator'
}

{ #category : #'as yet unclassified' }
HiMNavigator class >> example200 [
	^ self new addModels: 200; openViewScaled: 1.
]

{ #category : #'as yet unclassified' }
HiMNavigator class >> example5 [
	^ self new addModels: 5; openViewScaled: 5.
]

{ #category : #adding }
HiMNavigator >> addChildrenElementsFor: aRSElement [

	| elements |
	elements := RSShapeBuilder composite
		allowRepeatCommands;
		interactionDo: [ :i | i popupText: #object ];
		color: [ :each | Color red ];
		size: [ :each | (5 * (each children size + 1)) sqrt ];
		elementsOn: aRSElement model children.

	RSRectanglePackLayout on: elements. 

	aRSElement addAll: elements.

]

{ #category : #adding }
HiMNavigator >> addEdgesFor: elements [

	| edgeBuilder edges |
	edgeBuilder := RSEdgeBuilder line
		view: view;
		color: (Color blue alpha: 0.2);
		yourself.

	"Dependencies"
	edges := OrderedCollection new.
	elements do: [ :targetElement |
		| sourceNodes |
		sourceNodes := targetElement model allIncomingNodes flatCollect: #withAllParents.
		sourceNodes do: [ :incomingModel |
			| incomingElementOrNil |
			incomingElementOrNil := view elementFromModel: incomingModel.
			incomingElementOrNil ifNotNil: [ 
				edges add: (edgeBuilder edgeFrom: incomingElementOrNil to: targetElement).
		] ] ].

	layout addEdges: edges.
	edges do: #pushBack.

]

{ #category : #adding }
HiMNavigator >> addElementsFor: nodes [

	| elements labelInteraction |
	labelInteraction := RSLabeled new.
	labelInteraction shape text: [:each | each model object ]; fontSize: 3.
	
	elements := RSShapeBuilder composite
		allowRepeatCommands;
		interactionDo: [ :i | i draggable; popupText: #object"; addInteraction: labelInteraction; addInteraction: highlightable" ];
		color: [ :each | self colorFor: each ];
		size: [ :each | self collapsedSizeFor: each ];
		onElement;
		when: TSMouseDragging do: [ :each | [:evt | 
			layout fix: each at: evt position - (each extent / 2) ]];
		when: TSMouseDragEnd do: [:each | [:evt |
			layout removeFix: each ]];
		when: TSMouseDoubleClick do: [ :each | [:evt | self toggleNode: each ] ];
		elementsOn: nodes.

	view addAll: elements.
	layout addNodes: elements.
	
	self addEdgesFor: elements.
	

	
]

{ #category : #animations }
HiMNavigator >> collapse: aRSElement [ 
	| size |
	size := (self collapsedSizeFor: aRSElement model).
	aRSElement animation
		duration: self expandDuration;
		from: 1@1;
		to: size/aRSElement extent;
		onStepDo: [ :t | | position |
			position := aRSElement position.
			aRSElement matrix
				loadIdentity;
				translation: position;
				scaleBy: t.
			aRSElement resetBBox.
			aRSElement connectedEdges do: [ :anEdge |
				| newLength |
				newLength := (anEdge from width max: anEdge from height) + (anEdge to width max: anEdge to height)+5.
				layout set: anEdge length: newLength ].
			];
		when: TSAnimationEndEvent do: [ | position |
			aRSElement shapes copy do: #remove.
			position := aRSElement position.
			aRSElement matrix
				loadIdentity;
				translation: position.
			aRSElement size: size.
			 ].

	aRSElement connectedEdges do: [ :anEdge |
		layout removeLengthAt: anEdge ].
]

{ #category : #adding }
HiMNavigator >> collapsedSizeFor: aModel [

	^ (5 * (aModel children size + 1)) sqrt
]

{ #category : #adding }
HiMNavigator >> colorFor: aNode [
	^ colors scale: aNode topParent
]

{ #category : #animations }
HiMNavigator >> expand: aRSElement [
	| initialPosition |
	initialPosition := aRSElement position.
	self addChildrenElementsFor: aRSElement.
	aRSElement adjustToChildren.
	aRSElement translateTo: initialPosition.
	aRSElement padding: 1.
	aRSElement animation
		duration: self expandDuration;
		from: (self collapsedSizeFor: aRSElement model)/ aRSElement extent ;
		to: 1@1;
		onStepDo: [ :t | | position |
			position := aRSElement position.
			aRSElement matrix
				loadIdentity;
				translation: position;
				scaleBy: t.
			aRSElement resetBBox.
			aRSElement connectedEdges do: [ :anEdge |
				| newLength |
				newLength := (anEdge from width max: anEdge from height) + (anEdge to width max: anEdge to height)+5.
				layout set: anEdge length: newLength ].
			].

	
]

{ #category : #animations }
HiMNavigator >> expandDuration [
	^ 500 milliSeconds
]

{ #category : #initialization }
HiMNavigator >> initialize [
	super initialize.
	
	random := Random seed: 123.
	colors := TSScale category10.
	view := RSView new.
	highlightable := RSHighlightable new.

	layout := RSRectangleForceLayout new
		nodes: view elements;
		edges: view edges;
		start: view elements;
		friction: 0.3;
		enclosingForce: 0.1;
		enclosingThreshold: 20;
		yourself.

	view animation repeat onStepDo: [ :t | layout step ].
	
	"Apply forces from the window borders to the elements."
	view when: TSExtentChangedEvent do: [ :evt |
		| camera origin corner |
		camera := view canvas camera.
		origin := camera fromPixelToSpace: 0@0.
		corner := camera fromPixelToSpace: view canvas extent.
		layout enclosingRectangle: (origin corner: corner).
	].
]

{ #category : #opening }
HiMNavigator >> openViewScaled: aFloat [

	view camera scale: aFloat.
	view open.
]

{ #category : #adding }
HiMNavigator >> toggleNode: aRSElement [
	| isExpanded |
	isExpanded := aRSElement
		attributeAt: #expanded
		ifAbsentPut: [ false ].
	isExpanded
		ifTrue: [ self collapse: aRSElement ]
		ifFalse: [ self expand: aRSElement ].
	aRSElement attributeAt: #expanded put: isExpanded not
]
