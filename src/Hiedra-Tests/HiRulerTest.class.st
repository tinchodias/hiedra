"
A HiRulerTest is a test class for testing the behavior of HiRuler
"
Class {
	#name : #HiRulerTest,
	#superclass : #TestCase,
	#category : #'Hiedra-Tests-Model'
}

{ #category : #tests }
HiRulerTest >> rulerWithTwoMergedForks [
	"
	c
	|\ 
	| | 
	| b 
	| | 
	|/ 
	a 
	"
	
	| ruler |
	^ ruler
]

{ #category : #tests }
HiRulerTest >> testEmpty [
	
	| ruler |
	ruler := HiRuler withNumberOfRows: 0.
	
	self assert: ruler nodes isEmpty.
	self assert: ruler links isEmpty.
	self assert: ruler elementsByRow isEmpty.
	self assert: ruler numberOfColumns equals: 0.
	self assert: ruler numberOfRows equals: 0.
]

{ #category : #tests }
HiRulerTest >> testTwoMergedForks [
	"
	c
	|\ 
	| | 
	| b 
	| | 
	|/ 
	a 
	"

	| ruler c b a |
	ruler := HiRuler withNumberOfRows: 3.

	c := ruler addNodeWithValue: #c atRowIndex: 1.
	a := ruler addNodeWithValue: #a atRowIndex: 3.
	ruler addLinkFrom: c to: a.

	b := ruler addNodeWithValue: #b atRowIndex: 2.
	ruler
		addLinkFrom: c to: b;
		addLinkFrom: b to: a.

	self assert: ruler nodes asSet equals: {c. b. a} asSet.
	self assert: ruler links size equals: 3.

	self assert: c rulerPoint equals: 1@1.
	self assert: b rulerPoint equals: 2@2.
	self assert: a rulerPoint equals: 1@3.

	self assert: c theValue equals: #c.
	self assert: b theValue equals: #b.
	self assert: a theValue equals: #a.

]
