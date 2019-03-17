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
		'rowHeight',
		'linkColor',
		'linkCurveAngle',
		'arrowSize',
		'cellWidth'
	],
	#category : #'Hiedra-UI'
}

{ #category : #rendering }
HiSimpleRenderer >> addArrowInto: athensPathBuilder descending: aBoolean [

	| c |
	arrowSize isZero ifTrue: [ ^ self ].

	c := aBoolean ifTrue: [ 1 ] ifFalse: [ -1 ].
	athensPathBuilder
		relative;
		lineTo: (-1 * arrowSize) @ (-1 * c * arrowSize);
		lineTo: ( 2 * arrowSize) @ 0;
		lineTo: (-1 * arrowSize) @ (c * arrowSize);
		absolute.
]

{ #category : #rendering }
HiSimpleRenderer >> addLinkFragmentFrom: topPoint to: bottomPoint intermediateY: intermediateY into: athensPathBuilder [
	"Add a curve between two points in a canvas, that pass via an intermediate Y."

	topPoint x = bottomPoint x
		ifTrue: [ ^ athensPathBuilder lineTo: bottomPoint ].

	topPoint x < bottomPoint x
		ifTrue: [
			self
				addLinkFragmentFromTopLeft: topPoint
				toBottomRight: bottomPoint
				intermediateY: intermediateY
				into: athensPathBuilder ]
		ifFalse: [
			self
				addLinkFragmentFromTopRight: topPoint
				toBottomLeft: bottomPoint
				intermediateY: intermediateY
				into: athensPathBuilder ]
]

{ #category : #rendering }
HiSimpleRenderer >> addLinkFragmentFromTopLeft: topPoint toBottomRight: bottomPoint intermediateY: intermediateY into: athensPathBuilder [
	"	
		 s
		 \___
		     \
		     e
	"

	| halfColumn |
	halfColumn := cellWidth/2.
	athensPathBuilder
		ccwArcTo: (topPoint x    + halfColumn) @ intermediateY angle: self linkCurveAngle;
		lineTo:   (bottomPoint x - halfColumn) @ intermediateY;
		cwArcTo:  bottomPoint angle: self linkCurveAngle

]

{ #category : #rendering }
HiSimpleRenderer >> addLinkFragmentFromTopRight: topPoint toBottomLeft: bottomPoint intermediateY: intermediateY into: athensPathBuilder [
	"	
		     s
		  ___/
		 /
		 e
	"

	| halfColumn |
	halfColumn := cellWidth/2.
	athensPathBuilder 
		cwArcTo:  (topPoint x    - halfColumn) @ intermediateY angle: self linkCurveAngle;
		lineTo:   (bottomPoint x + halfColumn) @ intermediateY;
		ccwArcTo: bottomPoint angle: self linkCurveAngle
]

{ #category : #accessing }
HiSimpleRenderer >> arrowSize [
	^ arrowSize
]

{ #category : #accessing }
HiSimpleRenderer >> arrowSize: aNumber [
	arrowSize := aNumber
]

{ #category : #rendering }
HiSimpleRenderer >> athensPathForAscendingLink: aHiLink on: athensCanvas [
	"Answer the Athens path for a link that goes from bottom to top."

	^ athensCanvas createPath: [ :athensPathBuilder | 
		| nodeConnectionYOffset fragmentStart |
		nodeConnectionYOffset := self nodeBottomRelativeConnectionPoint.

		"Start of first fragment (that connects at BOTTOM of the target node)"
		fragmentStart := (self cellCenterFor: aHiLink target rulerPoint) + nodeConnectionYOffset.
		athensPathBuilder absolute; moveTo: fragmentStart.

		self addArrowInto: athensPathBuilder descending: false.

		"Add all fragments except last (in reversed order)"
		aHiLink intermediatePoints reverseDo: [ :rulerPoint | 
			| fragmentEnd |
			fragmentEnd := self cellCenterFor: rulerPoint.
			self
				addLinkFragmentFrom: fragmentStart
				to: fragmentEnd
				intermediateY: (self cellOriginFor: rulerPoint) y
				into: athensPathBuilder.
			fragmentStart := fragmentEnd
			].

		"Add last fragment (that connects at TOP of the origin node)"
		self
			addLinkFragmentFrom: fragmentStart
			to: (self cellCenterFor: aHiLink origin rulerPoint) - nodeConnectionYOffset
			intermediateY: (self cellOriginFor: aHiLink origin rulerPoint) y
			into: athensPathBuilder.
		]
]

{ #category : #rendering }
HiSimpleRenderer >> athensPathForDescendingLink: aHiLink on: athensCanvas [
	"Answer the Athens path for a link that goes from top to bottom."

	^ athensCanvas createPath: [ :athensPathBuilder | 
		| nodeConnectionYOffset fragmentStart |
		nodeConnectionYOffset := self nodeBottomRelativeConnectionPoint.

		"Start of first fragment (that connects BELOW of the origin node)"
		fragmentStart := (self cellCenterFor: aHiLink origin rulerPoint) + nodeConnectionYOffset.
		athensPathBuilder absolute; moveTo: fragmentStart.

		"Add all fragments except last"
		aHiLink intermediatePoints do: [ :rulerPoint |
			| fragmentEnd |
			fragmentEnd := self cellCenterFor: rulerPoint.
			self
				addLinkFragmentFrom: fragmentStart
				to: fragmentEnd
				intermediateY: (self cellOriginFor: rulerPoint) y
				into: athensPathBuilder.
			fragmentStart := fragmentEnd
			].

		"Add last fragment (that connects ABOVE of the target node)"
		self
			addLinkFragmentFrom: fragmentStart
			to: (self cellCenterFor: aHiLink target rulerPoint) - nodeConnectionYOffset
			intermediateY: (self cellOriginFor: aHiLink target rulerPoint) y
			into: athensPathBuilder.

		self addArrowInto: athensPathBuilder descending: true.
		]
]

{ #category : #rendering }
HiSimpleRenderer >> athensPathForLink: aHiLink on: athensCanvas [
	"Answer the Athens path for a link."

	^ aHiLink isDescending
		ifTrue: [ 
			self
				athensPathForDescendingLink: aHiLink
				on: athensCanvas ]
		ifFalse: [
			self
				athensPathForAscendingLink: aHiLink
				on: athensCanvas ]
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

	^ (self cellOriginFor: aRulerPoint) + ((cellWidth // 2) @ (rowHeight // 2))
]

{ #category : #rendering }
HiSimpleRenderer >> cellOriginFor: aRulerPoint [

	^ ((aRulerPoint x - 1) * cellWidth) @ 
	  ((aRulerPoint y - 1) * rowHeight)
]

{ #category : #accessing }
HiSimpleRenderer >> cellWidth [
	^ cellWidth
]

{ #category : #accessing }
HiSimpleRenderer >> cellWidth: aNumber [
	cellWidth := aNumber
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
	arrowSize := linkWidth * 0.75.

	"Important: the user must set the height of rows (integers worked better than a floats)"
	rowHeight := nil.
	cellWidth := linkWidth * 3.

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

{ #category : #rendering }
HiSimpleRenderer >> nodeBottomRelativeConnectionPoint [

	^ 0 @ ((nodeDiameter / 2) + nodeBorderWidth + 1)
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
