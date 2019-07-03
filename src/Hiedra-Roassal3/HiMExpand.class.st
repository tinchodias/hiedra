Class {
	#name : #HiMExpand,
	#superclass : #HiMNodeCommand,
	#category : #'Hiedra-Roassal3-Examples-MultigranularNavigator'
}

{ #category : #execution }
HiMExpand >> execute [
	navigator expand: node
]

{ #category : #execution }
HiMExpand >> inverse [
	^ HiMCollapse new
		navigator: navigator;
		node: node;
		yourself
]
