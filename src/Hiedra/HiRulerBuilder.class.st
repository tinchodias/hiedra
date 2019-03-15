"
I create HiNode and HiLink instances from a collection of values and a block closure of targets (that  answers what values are connected from a given value). It is important that the nodes and links are ""iterated"" in a breadth-first way as it is expected to build a HiRuler, i.e. a Hiedra visualization.
"
Class {
	#name : #HiRulerBuilder,
	#superclass : #Object,
	#instVars : [
		'values',
		'linksBlock',
		'ruler'
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
	
	ruler := HiRuler withValues: values.

	values do: [ :each | 
		ruler
			nodeAt: each
			ifAbsent: [
				ruler addNodeFor: each.
				self buildLinksStartingAt: each ].
		].

]

{ #category : #private }
HiRulerBuilder >> buildLinksStartingAt: aValue [
	"This method traverses the values using the linkBlock. It is a depth-first traversal."

	| pending |
	pending := Stack new.
	self stackLinksFrom: aValue in: pending.

	[ pending isEmpty ] whileFalse: [
		| next aNode anotherNode |
		next := pending pop.

		aNode := ruler nodeAt: next key.
		anotherNode := ruler
			nodeAt: next value
			ifAbsent: [ 
				self stackLinksFrom: next value in: pending.
				ruler addNodeFor: next value ].

		(aNode hasLinkTo: anotherNode) ifFalse: [ 
			ruler addLinkFrom: aNode to: anotherNode.
		].

	].

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

{ #category : #building }
HiRulerBuilder >> ruler [
	^ ruler
]

{ #category : #private }
HiRulerBuilder >> stackLinksFrom: aValue in: pending [

	| linkedValues |
	linkedValues := linksBlock value: aValue.
	linkedValues reverseDo: [:each | pending push: (aValue -> each) ].

]

{ #category : #accessing }
HiRulerBuilder >> values [
	^ values
]

{ #category : #accessing }
HiRulerBuilder >> values: aCollection [ 
	values := aCollection
]
