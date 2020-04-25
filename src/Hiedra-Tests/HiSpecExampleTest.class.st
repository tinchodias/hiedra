Class {
	#name : #HiSpecExampleTest,
	#superclass : #HiExampleTest,
	#category : #'Hiedra-Tests-Examples'
}

{ #category : #tests }
HiSpecExampleTest >> close: aHiSpecExample [
	^ aHiSpecExample withWindowDo: [ :w | w close ]
]

{ #category : #tests }
HiSpecExampleTest >> exampleClassToTest [
	^ HiSpecExample
]
