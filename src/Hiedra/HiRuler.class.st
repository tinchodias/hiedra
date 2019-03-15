"
I represent a Hiedra visualization (a ruler), which is composed of nodes and links between such nodes.

A ruler is created with a list of values, and each of these values will have its corresponding node in the corresponding row. In other words, a ruler always has a 1-to-1 relation between values, nodes and rows.
"
Class {
	#name : #HiRuler,
	#superclass : #Object,
	#instVars : [
		'nodes',
		'links',
		'elementsByRow',
		'nodeByValue',
		'values',
		'valueIndices'
	],
	#category : #'Hiedra-Model'
}

{ #category : #'instance creation' }
HiRuler class >> new [
	"use #withNumberOfRows: instead"
	self shouldNotImplement
]

{ #category : #'instance creation' }
HiRuler class >> withValues: aSequenceableCollection [
	
	^ self basicNew
		initializeWithValues: aSequenceableCollection;
		yourself.
]

{ #category : #accessing }
HiRuler >> addLinkFrom: aNode to: anotherNode [
	"Add a HiLink to the ruler from aNode to anotherNode. The link will occupy a free point in the ruler for each intermediate row from the origin to the target node."
	
	| intermediatePoints newLink |
	intermediatePoints := (aNode intermediateRowIndicesTo: anotherNode)
		collect: [ :row | ((elementsByRow at: row) size + 1) @ row ].

	newLink := HiLink
		origin: aNode
		target: anotherNode
		intermediatePoints: intermediatePoints.

	intermediatePoints do: [ :aPoint |
		(elementsByRow at: aPoint y) addLast: newLink ].
		
	aNode addOutgoingLink: newLink.
	anotherNode addIncomingLink: newLink.
	links add: newLink.
	
	^ newLink
]

{ #category : #accessing }
HiRuler >> addNodeFor: aValue [
	"Add the node for aValue. The node will occupy a free point in the ruler in the corresponding row.
	
	Constraints:
	- aValue must belong to the initial list of values used when creating the ruler instance.
	- aValue must be added exactly once as node.
	"

	| newNode rowElements columnIndex rowIndex |
	rowIndex := valueIndices at: aValue.
	rowElements := elementsByRow at: rowIndex.
	columnIndex := rowElements size + 1.
	newNode := HiNode value: aValue rulerPoint: columnIndex@rowIndex.

	rowElements addLast: newNode.
	nodes at: rowIndex put: newNode.
	nodeByValue at: aValue put: newNode.
	values at: rowIndex put: aValue. "TODO: Remove... too much redundancy"
	
	^ newNode
]

{ #category : #accessing }
HiRuler >> elementsByRow [
	^ elementsByRow
]

{ #category : #initialization }
HiRuler >> initializeWithValues: aSequenceableCollection [ 

	self initialize.

	values := aSequenceableCollection.
	valueIndices := Dictionary new: values size.
	values withIndexDo: [ :aValue :index |
		valueIndices at: aValue put: index ].	
	nodeByValue := Dictionary new: values size.
	nodes := Array new: values size.
	elementsByRow := Array streamContents: [ :stream |
		values size timesRepeat: [ stream nextPut: OrderedCollection new ]]. 
	links := OrderedCollection new.

]

{ #category : #accessing }
HiRuler >> links [
	^ links
]

{ #category : #accessing }
HiRuler >> nodeAt: aValue [

	^ nodeByValue at: aValue
]

{ #category : #accessing }
HiRuler >> nodeAt: aValue ifAbsent: aBlock [

	^ nodeByValue at: aValue ifAbsent: aBlock
]

{ #category : #accessing }
HiRuler >> nodes [
	^ nodes
]

{ #category : #accessing }
HiRuler >> numberOfColumns [

	^ elementsByRow 
		ifEmpty: [ 0 ]
		ifNotEmpty: [ elementsByRow max: #size ]
]

{ #category : #accessing }
HiRuler >> numberOfRows [

	^ elementsByRow size
]

{ #category : #accessing }
HiRuler >> valueIndices [
	^ valueIndices
]

{ #category : #accessing }
HiRuler >> values [
	^ values
]
