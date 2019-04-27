Class {
	#name : #HiRS3Viz,
	#superclass : #Object,
	#category : #'Hiedra-Roassal3'
}

{ #category : #'instance creation' }
HiRS3Viz class >> exampleIceberg156 [
	| commits ruler |
	commits := HiExampleCommit perform: #iceberg_v1_5_6.
	ruler := HiRulerBuilder
		newRulerValues: commits
		linksBlock: [ :aCommit | 
			aCommit parentIds
				collect: [ :id | commits detect: [ :each | each id = id ] ] ].
	^ self openOn: ruler
]

{ #category : #'instance creation' }
HiRS3Viz class >> exampleRandom [
	| commits ruler |
	commits := HiExampleCommit perform: #randomlyGenerated.
	ruler := HiRulerBuilder
		newRulerValues: commits
		linksBlock: [ :aCommit | 
			aCommit parentIds
				collect: [ :id | commits detect: [ :each | each id = id ] ] ].
	^ self openOn: ruler
]

{ #category : #'instance creation' }
HiRS3Viz class >> openOn: aRuler [

	| v size rowSize shape color polylineShape |
	v := RSView new.

	size := 10.
	rowSize := 12@25.
	color := TSScale google20.

	shape := RSShapeBuilder circle
		size: size;
		color: [ :node | 
			color scale: (aRuler branchAtNode: node ifAbsent: [ node hash ]) ];
		border: TSBorder new;
		interactionDo: [ :i | i draggable ];
		position: [ :node| node rulerPoint * rowSize ];
		onElement;
		when: TSMouseClick do: [ :e | [ e inspect ] ].
	v addAll: (shape elementsOn: aRuler nodes).
	
	polylineShape := RSSingleEdgeBuilder polyline
		cornerRadii: 5;
		width: 3;
		joinRound;
		color: [ :link | color scale: (aRuler branchAtLink: link) ];
		controlPoints: [ :link |
			OrderedCollection new
				add: (v elementFromModel: link origin);
				addAll: (link intermediatePoints)*rowSize;
				add: (v elementFromModel: link target);
				yourself ].
	aRuler nodes do:[:node| | edges |
		edges := polylineShape edgesOn: node incomingLinks.
		v addAll: edges ].
	v edges pushBack.
	v @ RSControlsView.

	v open
]
