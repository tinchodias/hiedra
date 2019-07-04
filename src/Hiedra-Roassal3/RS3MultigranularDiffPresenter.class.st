Class {
	#name : #RS3MultigranularDiffPresenter,
	#superclass : #RS3DiffPresenter,
	#category : #'Hiedra-Roassal3-Examples-Iceberg'
}

{ #category : #private }
RS3MultigranularDiffPresenter >> buildDiffOn: view [

	TSLine delta: 1.	"Note: global effect!"

	(HiMNavigator newOn: view)
		addElementsFor: self initialNodes;
		yourself.

	view camera scale: 6.
]

{ #category : #private }
RS3MultigranularDiffPresenter >> initialNodes [
	
	| visitor |
	visitor := RS3NodesEntityCollector new.
	iceDiffModel tree accept: visitor.

	^ visitor nodesWithPackages collect: [:each | self nodeForPackageNode: each ].
	

]

{ #category : #private }
RS3MultigranularDiffPresenter >> nodeForClassLevelNode: node [
	| result |
	result := HiMNode for: node key.
	node children
		collect: [ :each | HiMNode for: each key ]
		thenDo: [:each | result addChild: each ].
	^ result

]

{ #category : #private }
RS3MultigranularDiffPresenter >> nodeForPackageNode: node [
	| result |
	result := HiMNode for: node key.
	node children
		collect: [ :each | self nodeForClassLevelNode: each ]
		thenDo: [ :each | result addChild: each ].
	^ result
]
