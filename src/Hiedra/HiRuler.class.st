"
I represent a model for a Hiedra visualization (a ruler), which is composed of nodes and links between such nodes.

The user must create a ruler with a list of values. Then, my API provides #addNodeFor: and #addLinkFrom:to: to fill the ruler. Example:

```
	| ruler c b a |
	ruler := HiRuler withValues: #(c b a).

	c := ruler addNodeFor: #c.
	a := ruler addNodeFor: #a.
	ruler addLinkFrom: c to: a.

	b := ruler addNodeFor: #b.
	ruler
		addLinkFrom: c to: b;
		addLinkFrom: b to: a.
```

Which generates a ruler like:

	c
	|\ 
	| | 
	| b 
	| | 
	|/ 
	a 


Note 1: A ruler always has a 1-to-1 relation between values, rows and nodes.
Note 2: See HiAbstractRenderer to render my instances into Forms.
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
		'linksByRow',
		'branchByLink'
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
HiRuler >> branchAtLink: aHiLink [
	"Answer the branch number for a link."

	^ self branchByLink at: aHiLink
]

{ #category : #accessing }
HiRuler >> branchAtNode: aHiNode ifAbsent: aBlock [
	"Answer the branch number for a node."

	| aHiLink |
	aHiLink := aHiNode outgoingLinks
		ifEmpty: [
			aHiNode incomingLinks
				ifEmpty: [ ^ aBlock value ]
				ifNotEmpty: [ :ls | ls first ] ]
		ifNotEmpty: [ :ls | ls first ].
	^ self branchAtLink: aHiLink
]

{ #category : #accessing }
HiRuler >> branchByLink [
	"Answer a dictionary that maps each link to a branch number."
	
	branchByLink ifNil: [ 
		| currentBranch |
		currentBranch := 1.
		branchByLink := Dictionary new.
		self nodes reverseDo: [ :node |
			node incomingLinks do: [ :link | 
				self markBranch: currentBranch startingAt: link.
				currentBranch := currentBranch + 1 ] ].
		 ].
	^ branchByLink
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
HiRuler >> markBranch: aNumber startingAt: link [
	| nextLink |
	"Stop if the link is already marked with a branch"
	(branchByLink includesKey: link) ifTrue: [ ^self ].
	"Iterate the first available branch until there are not more."
	nextLink := link.
	[ nextLink notNil ] whileTrue: [ 
		branchByLink at: nextLink put: aNumber.
		nextLink origin incomingLinks ifEmpty: [ ^self ].
		nextLink := nextLink origin incomingLinks
			detect: [ :each | (branchByLink includesKey: each) not ]
			ifNone: [ nil ] ]
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
