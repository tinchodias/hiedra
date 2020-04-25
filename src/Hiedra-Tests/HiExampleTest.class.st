Class {
	#name : #HiExampleTest,
	#superclass : #TestCase,
	#category : #'Hiedra-Tests-Examples'
}

{ #category : #testing }
HiExampleTest class >> isAbstract [
	^ self = HiExampleTest
]

{ #category : #tests }
HiExampleTest >> close: anExample [
	^ self subclassResponsibility
]

{ #category : #tests }
HiExampleTest >> exampleClassToTest [
	^ self subclassResponsibility
]

{ #category : #tests }
HiExampleTest >> exampleMethods [
	^ self exampleClassToTest classSide methods select:
		[ :each |
			(each selector beginsWith: 'example') 
			and: [ each numArgs = 0 ] ]
]

{ #category : #tests }
HiExampleTest >> shouldntErrorExample: aSymbol [
	self
		shouldnt: [ 
			| example |
			example := aSymbol methodClass instanceSide perform: aSymbol selector.
			100 milliSeconds wait. "For the case there is something to wait."
			self close: example ]
		raise: Error
]

{ #category : #tests }
HiExampleTest >> testAllExamples [
	| exampleMethods |
	exampleMethods := self exampleMethods.
	self deny: exampleMethods isEmpty.
	exampleMethods do: [ :each | self shouldntErrorExample: each ]
]
