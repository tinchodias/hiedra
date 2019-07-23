Class {
	#name : #HiColorWheelRenderer,
	#superclass : #HiSimpleRenderer,
	#instVars : [
		'branchMapping',
		'colorByBranch'
	],
	#category : #'Hiedra-UI'
}

{ #category : #rendering }
HiColorWheelRenderer >> colorForLink: aHiLink [
	^ colorByBranch at: (branchMapping branchAtLink: aHiLink)
]

{ #category : #rendering }
HiColorWheelRenderer >> colorForNode: aHiNode [
	^ colorByBranch at: (branchMapping branchAtNode: aHiNode)
]

{ #category : #rendering }
HiColorWheelRenderer >> newColorGenerator [
	| anArrayOfColors numberOfColors |
	numberOfColors := 10.
	anArrayOfColors := Color
		wheel: numberOfColors
		saturation: 1
		brightness: 0.85.

	^ Generator on: [ :generator |
		| nextIndex |
		nextIndex := 1.
		[ generator yield: (anArrayOfColors at: nextIndex).
		nextIndex := (nextIndex + 1) \\ anArrayOfColors size + 1 ] repeat ]
]

{ #category : #rendering }
HiColorWheelRenderer >> renderLinks: links on: athensCanvas [

	"Draw each link on the canvas."
	links do: [ :each | 

		"Set the paint for this link."
		(athensCanvas setStrokePaint: (self colorForLink: each)) width: linkWidth.
		athensCanvas paint joinMiter.
	
		athensCanvas drawShape: (self athensPathForLink: each on: athensCanvas) ]

]

{ #category : #rendering }
HiColorWheelRenderer >> renderNodes: nodes on: athensCanvas [

	| nodeAthensPath |
	"Create the Athens path that is common to all nodes."
	nodeAthensPath := self athensPathForNodeOn: athensCanvas.

	athensCanvas paintMode restoreAfter: [
		nodes do: [ :each |
		
			"Set the stroke for all this node."
			(athensCanvas setStrokePaint: (self colorForNode: each)) width: nodeBorderWidth.

			athensCanvas pathTransform restoreAfter: [
				athensCanvas pathTransform
					translateBy: (self cellCenterFor: each rulerPoint).
				athensCanvas drawShape: nodeAthensPath ] ] ].

]

{ #category : #rendering }
HiColorWheelRenderer >> ruler: aHiRuler [
	super ruler: aHiRuler.

	"Initialize some internal state"
	branchMapping := HiBranchMapping builtFor: ruler.

	colorByBranch := Array streamContents: [ :stream |
		| colorGenerator |
		colorGenerator := self newColorGenerator.
		branchMapping branchCount timesRepeat: [
			stream nextPut: colorGenerator next ] ]
]
