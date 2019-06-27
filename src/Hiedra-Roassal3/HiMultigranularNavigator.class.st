Class {
	#name : #HiMultigranularNavigator,
	#superclass : #Object,
	#instVars : [
		'colors',
		'layout',
		'view',
		'random'
	],
	#category : #'Hiedra-Roassal3-Examples-MultigranularNavigator'
}

{ #category : #'as yet unclassified' }
HiMultigranularNavigator class >> example200 [
	^ self new addModels: 200; openViewScaled: 1.
]

{ #category : #'as yet unclassified' }
HiMultigranularNavigator class >> example5 [
	^ self new addModels: 5; openViewScaled: 5.
]

{ #category : #adding }
HiMultigranularNavigator >> addElementsFor: models to: incomingsForModelBlock [

	| elements edges edgeBuilder |
	elements := RSShapeBuilder box
		allowRepeatCommands;
		draggable;
		color: [ :each | colors scale: (self groupFor: each) ];
		size: 10;
		onElement;
		when: TSMouseDragging do: [ :each | [:evt | 
			layout fix: each at: evt position - (each extent / 2) ]];
		when: TSMouseDragEnd do: [:each | [:evt |
			layout removeFix: each ]];
		when: TSMouseDoubleClick do: [ :each | [:evt |
			each remove.
			self
				addElementsFor: (self childrenModelsFor: each model)
				to: [each incomingEdges first from model]
			] ];
		elementsOn: models.
	
	view addAll: elements.

	edgeBuilder := RSEdgeBuilder line
		view: view;
		color: (Color blue alpha: 0.5);
		yourself.

	edges := elements collect: [ :each |
		| model |
		model := incomingsForModelBlock rsValue: each.
		edgeBuilder edgeFrom: (view elementFromModel: model) to: each.
		].
	
	layout addNodes: elements; addEdges: edges.

]

{ #category : #adding }
HiMultigranularNavigator >> addModels: count [

	| models |
	models := self randomIntegers: count.
	self addElementsFor: models to: [ :each | models atRandom: random ].

]

{ #category : #adding }
HiMultigranularNavigator >> childrenModelsFor: aModel [

	^ self randomIntegers: 5.
]

{ #category : #adding }
HiMultigranularNavigator >> groupFor: aModel [

	^ aModel asString last 
]

{ #category : #adding }
HiMultigranularNavigator >> initialize [
	super initialize.
	
	random := Random seed: 123.
	colors := TSScale category10.
	view := RSView new.

	layout := RSRectangleForceLayout new
		nodes: view elements;
		edges: view edges;
		start: view elements;
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

{ #category : #'as yet unclassified' }
HiMultigranularNavigator >> openViewScaled: aFloat [

	view camera scale: aFloat.
	view open.
]

{ #category : #adding }
HiMultigranularNavigator >> randomIntegers: count [
	^ (1 to: count) collect: [ :each | random nextInt: 1e10 ]
]
