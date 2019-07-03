Class {
	#name : #HiMCommand,
	#superclass : #Object,
	#instVars : [
		'navigator'
	],
	#category : #'Hiedra-Roassal3-Examples-MultigranularNavigator'
}

{ #category : #accessing }
HiMCommand >> navigator [
	^ navigator
]

{ #category : #accessing }
HiMCommand >> navigator: anObject [
	navigator := anObject
]
