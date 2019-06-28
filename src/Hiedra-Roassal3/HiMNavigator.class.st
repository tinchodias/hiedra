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
HiMNavigator >> addEdgesFor: elements [

	| edgeBuilder edges |
	edgeBuilder := RSEdgeBuilder line
		view: view;
		color: (Color blue alpha: 0.2);
		yourself.

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

]

{ #category : #adding }
HiMNavigator >> addElementsFor: nodes [

	| elements |
	elements := RSShapeBuilder box
		allowRepeatCommands;
		interactionDo: [ :i | i draggable; popupText: #object"; addInteraction: highlightable "];
		color: [ :each | self colorFor: each ];
		size: 10;
		onElement;
		when: TSMouseDragging do: [ :each | [:evt | 
			layout fix: each at: evt position - (each extent / 2) ]];
		when: TSMouseDragEnd do: [:each | [:evt |
			layout removeFix: each ]];
		when: TSMouseDoubleClick do: [ :each | [:evt |
			each model children
				ifEmpty: [ self inform: 'No children' ]
				ifNotEmpty: [:children |
					self inform: ('Adding {1} children' format: { children size }).
					each remove.
					self addElementsFor: each model children ]
			] ];
		elementsOn:nodes.
	
	view addAll: elements.

	layout addNodes: elements.
	
	self addEdgesFor: elements.

]

{ #category : #adding }
HiMNavigator >> colorFor: aNode [
	^ colors scale: aNode topParent
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
		charge: -50;
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
