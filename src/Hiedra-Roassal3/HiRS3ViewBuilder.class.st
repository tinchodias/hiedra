"
I render a Hiedra visualization (HiRuler) using Roassal3.
"
Class {
	#name : #HiRS3ViewBuilder,
	#superclass : #Object,
	#instVars : [
		'rowHeight',
		'nodeSize',
		'cellWidth',
		'commitAvatarFactory',
		'ruler'
	],
	#category : #'Hiedra-Roassal3-UI'
}

{ #category : #accessing }
HiRS3ViewBuilder >> cellWidth [
	^ cellWidth
]

{ #category : #accessing }
HiRS3ViewBuilder >> cellWidth: anObject [
	cellWidth := anObject
]

{ #category : #accessing }
HiRS3ViewBuilder >> commitAvatarFactory [
	^ commitAvatarFactory
]

{ #category : #accessing }
HiRS3ViewBuilder >> commitAvatarFactory: anObject [
	commitAvatarFactory := anObject
]

{ #category : #accessing }
HiRS3ViewBuilder >> formHeight [
	"Answer the height in pixels for the form to be rendered."
	
	^ ruler numberOfRows * self rowHeight
]

{ #category : #accessing }
HiRS3ViewBuilder >> formWidth [
	"Answer the width in pixels for the form to be rendered."

	"Note: The reason of numberOfColumns + 2 is the left and right margin."
	^ (ruler numberOfColumns + 2) * self cellWidth
]

{ #category : #initialization }
HiRS3ViewBuilder >> initialize [
	super initialize.
	
	cellWidth := 20.
	nodeSize := 20.
	commitAvatarFactory := [ :nodeValue |
		self iconNamed: #user ]
]

{ #category : #API }
HiRS3ViewBuilder >> newView [
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
HiRS3ViewBuilder >> nodeSize [
	^ nodeSize
]

{ #category : #accessing }
HiRS3ViewBuilder >> nodeSize: anInteger [
	nodeSize := anInteger
]

{ #category : #accessing }
HiRS3ViewBuilder >> rowHeight [
	^ rowHeight
]

{ #category : #accessing }
HiRS3ViewBuilder >> rowHeight: anInteger [
	rowHeight := anInteger
]

{ #category : #accessing }
HiRS3ViewBuilder >> ruler [
	^ ruler
]

{ #category : #accessing }
HiRS3ViewBuilder >> ruler: anObject [
	ruler := anObject
]
