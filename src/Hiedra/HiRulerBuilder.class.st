"
I create HiNode and HiLink instances from a collection of values and a block closure of targets (that  answers what values are connected from a given value). It is important that the nodes and links are ""iterated"" in a breadth-first way as it is expected to build a HiRuler, i.e. a Hiedra visualization.
"
Class {
	#name : #HiRulerBuilder,
	#superclass : #Object,
	#instVars : [
		'values',
		'linksBlock',
		'ruler',
		'valueIndices'
	],
	#category : #'Hiedra-Model'
}

{ #category : #convenience }
HiRulerBuilder class >> newRulerValues: aCollection linksBlock: aBlockClosure [
	^ self new
		values: aCollection;
		linksBlock: aBlockClosure;
		build;
		ruler
]

{ #category : #building }
HiRulerBuilder >> build [
	
	self prepareToProcess.
	
	values do: [ :each | self processNodesAndLinksFrom: each ].


]

{ #category : #private }
HiRulerBuilder >> ensureCreateNodeAtProperRowFor: aValue [
	^ ruler
		nodeAt: aValue
		ifAbsent: [ | rowIndex |
			rowIndex := valueIndices at: aValue.
			ruler
				addNodeWithValue: aValue
				atRowIndex: rowIndex
			]
]

{ #category : #initialization }
HiRulerBuilder >> initialize [

	super initialize.
	linksBlock := [ :value | #() ].
	values := #().
]

{ #category : #accessing }
HiRulerBuilder >> linksBlock [
	^ linksBlock
]

{ #category : #accessing }
HiRulerBuilder >> linksBlock: aBlockClosure [

	linksBlock := aBlockClosure
]

{ #category : #private }
HiRulerBuilder >> prepareToProcess [

	valueIndices := Dictionary new.	
	values withIndexDo: [ :aValue :index |
		valueIndices at: aValue put: index ].

	ruler := HiRuler withNumberOfRows: values size.
]

{ #category : #private }
HiRulerBuilder >> processLinkFrom: aNode to: anotherNode [

	ruler addLinkFrom: aNode to: anotherNode
]

{ #category : #private }
HiRulerBuilder >> processNodesAndLinksFrom: aValue [
	"This method traverses the values using the linkBlock. It is a depth-first traversal."

	| aNode |
	aNode := self ensureCreateNodeAtProperRowFor: aValue.

	(linksBlock value: aValue) do: [ :anotherValue |
		| anotherNode |
		anotherNode := self ensureCreateNodeAtProperRowFor: anotherValue.

		(aNode hasLinkTo: anotherNode) ifFalse: [
			self processLinkFrom: aNode to: anotherNode.
			self processNodesAndLinksFrom: anotherValue ].
	].

]

{ #category : #building }
HiRulerBuilder >> ruler [
	^ ruler
]

{ #category : #accessing }
HiRulerBuilder >> values [
	^ values
]

{ #category : #accessing }
HiRulerBuilder >> values: aCollection [ 
	values := aCollection
]
