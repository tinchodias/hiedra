Class {
	#name : #HiMCollapse,
	#superclass : #HiMNodeCommand,
	#category : #'Hiedra-Roassal3-Examples-MultigranularNavigator'
}

{ #category : #execution }
HiMCollapse >> execute [
	navigator collapse: node
]

{ #category : #execution }
HiMCollapse >> inverse [
	^ HiMExpand new
		navigator: navigator;
		node: node;
		yourself
]
