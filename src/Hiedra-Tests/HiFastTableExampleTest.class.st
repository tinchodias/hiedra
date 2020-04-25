"
A HiFastTableExampleTest is a test class for testing the behavior of HiFastTableExample
"
Class {
	#name : #HiFastTableExampleTest,
	#superclass : #HiExampleTest,
	#category : #'Hiedra-Tests-Examples'
}

{ #category : #tests }
HiFastTableExampleTest >> close: anMorph [
	^ anMorph close
]

{ #category : #tests }
HiFastTableExampleTest >> exampleClassToTest [
	^ HiFastTableExample
]
