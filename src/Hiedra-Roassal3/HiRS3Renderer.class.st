"
I render a Hiedra visualization (HiRuler) using Roassal3.
"
Class {
	#name : #HiRS3Renderer,
	#superclass : #HiAbstractRenderer,
	#instVars : [
		'rowHeight',
		'nodeSize',
		'cellWidth',
		'commitAvatarFactory'
	],
	#category : #'Hiedra-Roassal3'
}

{ #category : #accessing }
HiRS3Renderer >> cellWidth [
	^ cellWidth
]

{ #category : #accessing }
HiRS3Renderer >> commitAvatarFactory [
	^ commitAvatarFactory
]

{ #category : #accessing }
HiRS3Renderer >> commitAvatarFactory: anObject [
	commitAvatarFactory := anObject
]

{ #category : #initialization }
HiRS3Renderer >> initialize [
	super initialize.
	
	cellWidth := 20.
	nodeSize := 20.
	commitAvatarFactory := [ :nodeValue |
		self iconNamed: #user ]
]

{ #category : #API }
HiRS3Renderer >> newView [
	| v rowSize shape color polylineShape |
	v := RSView new.

	rowSize := self cellWidth @ self rowHeight.
	color := TSScale google20.

	shape := RSShapeBuilder circle
		size: nodeSize;
		paint: [ :node | commitAvatarFactory value: node theValue ];
		border: [ TSBorder new ];
		position: [ :node| node rulerPoint * rowSize ].
	v addAll: (shape elementsOn: ruler nodes).
	
	polylineShape := RSSingleEdgeBuilder polyline
		cornerRadii: 10;
		width: 3;
		joinRound;
		color: [ :link | color scale: (ruler branchAtLink: link) ];
		controlPoints: [ :link |
			OrderedCollection new
				add: (v elementFromModel: link origin);
				addAll: (link intermediatePoints)*rowSize;
				add: (v elementFromModel: link target);
				yourself ].
	ruler nodes do:[:node| | edges |
		edges := polylineShape edgesOn: node incomingLinks.
		v addAll: edges ].
	v edges pushBack.

	v color: Color transparent.
	
	^ v
]

{ #category : #accessing }
HiRS3Renderer >> nodeSize: anInteger [
	nodeSize := anInteger
]

{ #category : #accessing }
HiRS3Renderer >> rowHeight [
	^ rowHeight
]

{ #category : #accessing }
HiRS3Renderer >> rowHeight: anInteger [
	rowHeight := anInteger
]
