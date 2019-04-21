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
HiRS3Viz class >> openOn: aRuler [

	| v size rowSize shape color polylineShape |
	v := RSView new.

	size := 10.
	rowSize := 12@25.
	color := TSScale category20.

	shape := RSShapeBuilder circle
		size: size;
		noPaint;
		color: [ :node | 
			color scale: (aRuler branchAtNode: node ifAbsent: [ Smalltalk ui theme textColor ]) ];
		interactionDo: [ :i | i draggable ];
		position: [ :node| node rulerPoint * rowSize ];
		onElement;
		when: TSMouseClick do: [ :e | [ e inspect ] ].
	v addAll: (shape elementsOn: aRuler nodes).
	polylineShape := RSSingleEdgeBuilder polyline
		width: 3;
		capRound;
		joinRound;
		color: [ :link | color scale: (aRuler branchAtLink: link) ];
		withVerticalAttachPoint;
		from: [ :link | v elementFromModel: link origin ];
		to: [ :link | v elementFromModel: link target ];
		controlPoints: [ :link | [ :p1 :p2|
			OrderedCollection new
				add: p1;
				addAll: (link intermediatePoints)*rowSize;
				add: p2;
				yourself] ].
	aRuler nodes do:[:node| | edges |
		edges := polylineShape edgesOn: node incomingLinks.
		v addAll: edges ].
	
	v @ RSControlsView.

	v open
]
