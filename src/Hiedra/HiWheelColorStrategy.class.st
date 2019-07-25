"
I map nodes and links of a ruler to colors depending on the branches. Check HiBranchMapping to see how to decide what's the branch of a node or link.
"
Class {
	#name : #HiWheelColorStrategy,
	#superclass : #HiAbstractColorStrategy,
	#instVars : [
		'branchMapping',
		'colorByBranch',
		'colorWheel'
	],
	#category : #'Hiedra-UI'
}

{ #category : #accessing }
HiWheelColorStrategy >> colorForLink: aHiLink [
	^ colorByBranch at: (branchMapping branchAtLink: aHiLink)
]

{ #category : #accessing }
HiWheelColorStrategy >> colorForNode: aHiNode [
	^ colorByBranch at: (branchMapping branchAtNode: aHiNode)
]

{ #category : #accessing }
HiWheelColorStrategy >> colorWheel [
	^ colorWheel ifNil: [ colorWheel := self defaultColorWheel ]
]

{ #category : #accessing }
HiWheelColorStrategy >> colorWheel: aCollectionOfColors [
	colorWheel := aCollectionOfColors
]

{ #category : #accessing }
HiWheelColorStrategy >> defaultColorWheel [
	| referenceColor |
	referenceColor := Smalltalk ui theme textColor.

	^ (Color wheel: 37 saturation: 0.98 brightness: 0.7)
		collect: [ :each | each mixed: 0.85 with: referenceColor ]
]

{ #category : #private }
HiWheelColorStrategy >> newColorGenerator [
	^ Generator
		on: [ :generator | 
			| nextIndex |
			nextIndex := 1.
			[ generator yield: (self colorWheel at: nextIndex).
			nextIndex := (nextIndex + 1) \\ self colorWheel size + 1 ] repeat ]
]

{ #category : #accessing }
HiWheelColorStrategy >> ruler: aHiRuler [
	aHiRuler ifNil: [ ^self ].
	
	branchMapping := HiBranchMapping builtFor: aHiRuler.

	colorByBranch := Array streamContents: [ :stream |
		| colorGenerator |
		colorGenerator := self newColorGenerator.
		branchMapping branchCount timesRepeat: [
			stream nextPut: colorGenerator next ] ]
]
