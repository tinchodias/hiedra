"
I render a Hiedra visualization (HiRuler) using Roassal3.
"
Class {
	#name : #HiRS3Renderer,
	#superclass : #HiAbstractRenderer,
	#instVars : [
		'rowHeight'
	],
	#category : #'Hiedra-Roassal3'
}

{ #category : #accessing }
HiRS3Renderer >> cellWidth [
	^ 12
]

{ #category : #API }
HiRS3Renderer >> newForm [
	| view extent |
	view := self newView.
	extent := self formWidth @ self formHeight.
	
	view createMorph.
	view morph extent: extent.
	view camera
		zoomToFit: extent
		rectangle: (0@rowHeight rectangle: extent).
	view morph drawOnMockCanvas.
	^ view morph surface asForm
]

{ #category : #API }
HiRS3Renderer >> newView [
	| v size rowSize shape color polylineShape |
	v := RSView new.

	size := 10.
	rowSize := self cellWidth @ self rowHeight.
	color := TSScale google20.

	shape := RSShapeBuilder circle
		size: size;
		color: [ :node | 
			color scale: (ruler branchAtNode: node ifAbsent: [ node hash ]) ];
		border: [ TSBorder new ];
		position: [ :node| node rulerPoint * rowSize ].
	v addAll: (shape elementsOn: ruler nodes).
	
	polylineShape := RSSingleEdgeBuilder polyline
		cornerRadii: 5;
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
HiRS3Renderer >> rowHeight [
	^ rowHeight
]

{ #category : #accessing }
HiRS3Renderer >> rowHeight: anInteger [
	rowHeight := anInteger
]
