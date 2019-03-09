"
I have the aesthetic settings to render the Hiedra visualization using Athens.
"
Class {
	#name : #HiSimpleRenderer,
	#superclass : #HiAbstractRenderer,
	#instVars : [
		'nodeColor',
		'linkDashes',
		'linkWidth',
		'nodeDiameter',
		'nodeBorderWidth',
		'columnWidth',
		'rowHeight',
		'linkColor',
		'linkCurveAngle'
	],
	#category : #'Hiedra-UI'
}

{ #category : #rendering }
HiSimpleRenderer >> addLinkFragmentFrom: startPoint to: endPoint into: athensPathBuilder intermediateY: intermediateY [

	| halfColumn |
	startPoint y < endPoint y
		ifFalse: [ ^ self shouldBeImplemented ].
		"reversed direction --> athensPathBuilder ccwArcTo: targetCanvasPoint angle: 60 degreesToRadians"

	(startPoint x = endPoint x)
		ifTrue: [ ^ athensPathBuilder lineTo: endPoint ].

	halfColumn := columnWidth/2.

	(startPoint x < endPoint x)
		ifTrue: [
			"
			From top-left to bottom-right:
			
				 o
				 \___
				     \
				     o
			"
			athensPathBuilder
				ccwArcTo: (startPoint x + halfColumn) @ intermediateY angle: self linkCurveAngle;
				lineTo:   (endPoint x   - halfColumn) @ intermediateY;
				cwArcTo:  endPoint angle: self linkCurveAngle ]
		ifFalse: [
			"
			From top-right to bottom-left:
			
				     o
				  ___/
				 /
				 o
			"
			athensPathBuilder 
				cwArcTo:  (startPoint x - halfColumn) @ intermediateY angle: self linkCurveAngle;
				lineTo:   (endPoint x   + halfColumn) @ intermediateY;
				ccwArcTo: endPoint angle: self linkCurveAngle ]

]

{ #category : #rendering }
HiSimpleRenderer >> athensPathForLink: aHiLink on: athensCanvas [
	"Answer the Athens path for a link."

	| nodeRatioOffset fragmentStart |
	nodeRatioOffset := 0 @ self nodeRatio.

	^ athensCanvas createPath: [:athensPathBuilder |		
		"Start of first fragment (that connects BELOW of the origin node)"
		fragmentStart := (self cellCenterFor: aHiLink origin rulerPoint) + nodeRatioOffset.
		athensPathBuilder
			absolute;
			moveTo: fragmentStart.

		"All but last fragments"
		aHiLink rulerPoints do: [ :rulerPoint |
			| fragmentEnd |
			fragmentEnd := self cellCenterFor: rulerPoint.
			self
				addLinkFragmentFrom: fragmentStart
				to: fragmentEnd
				into: athensPathBuilder
				intermediateY: (self cellOriginFor: rulerPoint) y + (linkWidth/2) + 2.
			fragmentStart := fragmentEnd ].

		"End of last fragment (that connects ABOVE of the target node)"
		self
			addLinkFragmentFrom: fragmentStart
			to: (self cellCenterFor: aHiLink target rulerPoint) - nodeRatioOffset
			into: athensPathBuilder
			intermediateY: (self cellOriginFor: aHiLink target rulerPoint) y - (linkWidth/2).
		].

]

{ #category : #rendering }
HiSimpleRenderer >> athensPathForNodeOn: athensCanvas [
	"Answer the Athens path for a node."

	| nd pd |
	pd := nodeDiameter.
	nd := -1 * nodeDiameter.
	^ athensCanvas createPath: [ :pathBuilder | 
		pathBuilder
			absolute;
			moveTo: nd @ 0;
			ccwArcTo: 0 @ pd angle: 90 degreesToRadians;
			ccwArcTo: pd @ 0 angle: 90 degreesToRadians;
			ccwArcTo: 0 @ nd angle: 90 degreesToRadians;
			ccwArcTo: nd @ 0 angle: 90 degreesToRadians ]
]

{ #category : #rendering }
HiSimpleRenderer >> cellCenterFor: aRulerPoint [

	^ (self cellOriginFor: aRulerPoint) + ((columnWidth // 2) @ (rowHeight // 2))
]

{ #category : #rendering }
HiSimpleRenderer >> cellOriginFor: aRulerPoint [

	^ ((aRulerPoint x - 1) * columnWidth) @ 
	  ((aRulerPoint y - 1) * rowHeight)
]

{ #category : #accessing }
HiSimpleRenderer >> columnWidth [
	^ columnWidth
]

{ #category : #accessing }
HiSimpleRenderer >> columnWidth: aNumber [
	columnWidth := aNumber
]

{ #category : #initialization }
HiSimpleRenderer >> initialize [
	super initialize.

	nodeDiameter := 2.5.
	nodeBorderWidth := 1.75.
	nodeColor := Smalltalk ui theme caretColor.

	linkWidth := nodeBorderWidth.
	linkDashes := #().
	linkCurveAngle := 45 degreesToRadians.
	linkColor := nodeColor.

	columnWidth := linkWidth * 3.
	rowHeight := nil.	"Important: the user must set the exact height of rows"

]

{ #category : #accessing }
HiSimpleRenderer >> linkColor [
	^ linkColor
]

{ #category : #accessing }
HiSimpleRenderer >> linkColor: aColor [
	linkColor := aColor
]

{ #category : #rendering }
HiSimpleRenderer >> linkCurveAngle [
	^ linkCurveAngle
]

{ #category : #rendering }
HiSimpleRenderer >> linkCurveAngle: anAngleAsRadians [
	"Example argument: 45 degreesToRadians"

	linkCurveAngle := anAngleAsRadians
]

{ #category : #accessing }
HiSimpleRenderer >> linkDashes [
	^ linkDashes
]

{ #category : #accessing }
HiSimpleRenderer >> linkDashes: anArrayOfFillGapPairs [
	"Set how are the links dashed. 
	See AthensStrokePaint>>dashes:offset: to understand the parameter."

	linkDashes := anArrayOfFillGapPairs
]

{ #category : #accessing }
HiSimpleRenderer >> linkWidth [
	^ linkWidth
]

{ #category : #accessing }
HiSimpleRenderer >> linkWidth: aNumber [
	linkWidth := aNumber
]

{ #category : #accessing }
HiSimpleRenderer >> nodeBorderWidth [
	^ nodeBorderWidth
]

{ #category : #accessing }
HiSimpleRenderer >> nodeBorderWidth: aNumber [
	nodeBorderWidth := aNumber
]

{ #category : #accessing }
HiSimpleRenderer >> nodeColor [
	^ nodeColor
]

{ #category : #accessing }
HiSimpleRenderer >> nodeColor: anObject [
	nodeColor := anObject
]

{ #category : #accessing }
HiSimpleRenderer >> nodeDiameter [
	^ nodeDiameter
]

{ #category : #accessing }
HiSimpleRenderer >> nodeDiameter: aNumber [
	nodeDiameter := aNumber
]

{ #category : #rendering }
HiSimpleRenderer >> nodeRatio [

	^ (nodeDiameter / 2) + nodeBorderWidth
]

{ #category : #rendering }
HiSimpleRenderer >> renderLinks: links on: athensCanvas [

	"Set the paint for links"
	(athensCanvas setStrokePaint: linkColor)
		width: linkWidth.
	athensCanvas paint
		joinRound;
		dashes: linkDashes offset: 0.
	
	"Draw the links"
	links do: [ :each | 
		athensCanvas drawShape: (self athensPathForLink: each on: athensCanvas) ]

]

{ #category : #rendering }
HiSimpleRenderer >> renderNodes: nodes on: athensCanvas [

	| nodeAthensPath |
	"Create the Athens path that is common to all nodes."
	nodeAthensPath := self athensPathForNodeOn: athensCanvas.

	athensCanvas paintMode restoreAfter: [
		"Set the stroke for all the nodes."
		(athensCanvas setStrokePaint: nodeColor)
			width: nodeBorderWidth.

		nodes do: [ :each |
			athensCanvas pathTransform restoreAfter: [
				athensCanvas pathTransform
					translateBy: (self cellCenterFor: each rulerPoint).
				athensCanvas drawShape: nodeAthensPath ] ] ].

]

{ #category : #accessing }
HiSimpleRenderer >> rowHeight [
	^ rowHeight
]

{ #category : #accessing }
HiSimpleRenderer >> rowHeight: aNumber [
	rowHeight := aNumber
]
