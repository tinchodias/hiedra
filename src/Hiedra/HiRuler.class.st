"
I represent a Hiedra visualization (a ruler), which is composed of nodes and links between nodes.

"
Class {
	#name : #HiRuler,
	#superclass : #Object,
	#instVars : [
		'nodes',
		'links',
		'elementsByRow',
		'nodeByValue',
		'values'
	],
	#category : #'Hiedra-Model'
}

{ #category : #'instance creation' }
HiRuler class >> new [
	"use #withNumberOfRows: instead"
	self shouldNotImplement
]

{ #category : #'instance creation' }
HiRuler class >> withNumberOfRows: anInteger [
	
	^ self basicNew
		initializeWithNumberOfRows: anInteger;
		yourself.
]

{ #category : #accessing }
HiRuler >> addLinkFrom: aNode to: anotherNode [

	| rulerPoints newLink |
	rulerPoints := (self
		intermediateRowIndicesFrom: aNode
		to: anotherNode)
		collect: [ :rowIndex | 
			((elementsByRow at: rowIndex) size + 1) @ rowIndex ].

	newLink := HiLink
		origin: aNode
		target: anotherNode
		rulerPoints: rulerPoints.

	rulerPoints do: [ :aPoint |
		(elementsByRow at: aPoint y) addLast: newLink ].
		
	aNode addOutgoingLink: newLink.
	anotherNode addIncomingLink: newLink.
	links add: newLink.
	
	^ newLink
]

{ #category : #accessing }
HiRuler >> addNodeWithValue: aValue atRowIndex: rowIndex [

	| newNode rowElements columnIndex |
	rowElements := elementsByRow at: rowIndex.
	columnIndex := rowElements size + 1.
	newNode := HiNode value: aValue rulerPoint: columnIndex@rowIndex.

	rowElements addLast: newNode.
	nodes add: newNode.
	nodeByValue at: aValue put: newNode.
	values at: rowIndex put: aValue. "TODO: Remove... too much redundancy"
	
	^ newNode
]

{ #category : #accessing }
HiRuler >> elementsByRow [
	^ elementsByRow
]

{ #category : #initialization }
HiRuler >> initializeWithNumberOfRows: anInteger [ 

	self initialize.
	
	nodeByValue := Dictionary new: anInteger.
	nodes := OrderedCollection new: anInteger.
	values := Array new: anInteger.
	elementsByRow := Array streamContents: [ :stream | anInteger timesRepeat: [ stream nextPut: OrderedCollection new]]. 
	links := OrderedCollection new.

]

{ #category : #private }
HiRuler >> intermediateRowIndicesFrom: origin to: target [

	| originRowIndex targetRowIndex |
	originRowIndex := origin rulerPoint y.
	targetRowIndex := target rulerPoint y.

	^ originRowIndex <= targetRowIndex
		ifTrue: [ originRowIndex + 1 to: targetRowIndex - 1 ]
		ifFalse: [ originRowIndex - 1 to: targetRowIndex + 1 by: -1 ]
]

{ #category : #accessing }
HiRuler >> links [
	^ links
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
HiRuler >> values [
	^ values
]
