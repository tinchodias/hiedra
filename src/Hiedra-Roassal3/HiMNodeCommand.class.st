Class {
	#name : #HiMNodeCommand,
	#superclass : #HiMCommand,
	#instVars : [
		'node'
	],
	#category : #'Hiedra-Roassal3-Examples-MultigranularNavigator'
}

{ #category : #accessing }
HiMNodeCommand >> node [
	^ node
]

{ #category : #accessing }
HiMNodeCommand >> node: anObject [
	node := anObject
]
