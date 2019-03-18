"
I represent a Hiedra visualization (a ruler), which is composed of nodes and links between such nodes.

A ruler is created with a list of values, and each of these values will have its corresponding node in the corresponding row. In other words, a ruler always has a 1-to-1 relation between values, nodes and rows.
"
Class {
	#name : #HiRuler,
	#superclass : #Object,
	#instVars : [
		'links',
		'elementsByRow',
		'nodeByValue',
		'nodeByRow',
		'valueByRow',
		'rowByValue',
		'linksByRow'
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

	(linksByRow at: aNode rulerPoint y) add: newLink.
	intermediatePoints do: [ :aPoint |
		(elementsByRow at: aPoint y) addLast: newLink.
		(linksByRow at: aPoint y) add: newLink ].
	(linksByRow at: anotherNode rulerPoint y) add: newLink.
	
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
	rowIndex := rowByValue at: aValue.
	rowElements := elementsByRow at: rowIndex.
	columnIndex := rowElements size + 1.
	newNode := HiNode value: aValue rulerPoint: columnIndex@rowIndex.

	rowElements addLast: newNode.
	nodeByRow at: rowIndex put: newNode.
	nodeByValue at: aValue put: newNode.
	valueByRow at: rowIndex put: aValue. "TODO: Remove... too much redundancy"
	
	^ newNode
]

{ #category : #accessing }
HiRuler >> elementsByRow [
	^ elementsByRow
]

{ #category : #initialization }
HiRuler >> initializeWithValues: aSequenceableCollection [ 

	self initialize.
	valueByRow := aSequenceableCollection.

	rowByValue := Dictionary new: valueByRow size.
	valueByRow withIndexDo: [ :each :index | rowByValue at: each put: index ].
	nodeByValue := Dictionary new: valueByRow size.
	nodeByRow := Array new: valueByRow size.
	links := OrderedCollection new.

	elementsByRow := Array new: valueByRow size.
	linksByRow := Array new: valueByRow size.
	1 to: valueByRow size do: [ :index | 
		elementsByRow at: index put: LinkedList new.
		linksByRow at: index put: LinkedList new ]. 

]

{ #category : #accessing }
HiRuler >> links [
	^ links
]

{ #category : #accessing }
HiRuler >> linksAtRow: rowIndex [

	^ linksByRow at: rowIndex
]

{ #category : #accessing }
HiRuler >> nodeAtRow: rowIndex [

	^ nodeByRow at: rowIndex
]

{ #category : #accessing }
HiRuler >> nodeAtValue: aValue [

	^ nodeByValue at: aValue
]

{ #category : #accessing }
HiRuler >> nodeAtValue: aValue ifAbsent: aBlock [

	^ nodeByValue at: aValue ifAbsent: aBlock
]

{ #category : #accessing }
HiRuler >> nodes [
	^ nodeByRow
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
	^ rowByValue
]

{ #category : #accessing }
HiRuler >> values [
	^ valueByRow
]
