Class {
	#name : #RS3MultigranularDiffPresenter,
	#superclass : #RS3DiffPresenter,
	#instVars : [
		'labelStrategy'
	],
	#category : #'Hiedra-Roassal3-Examples-Iceberg'
}

{ #category : #private }
RS3MultigranularDiffPresenter >> buildDiffOn: view [

	TSLine delta: 1.	"Note: global effect!"

	(HiMNavigator newOn: view)
		labelStrategy: self labelStrategy;
		addElementsFor: self initialNodes;
		yourself.

"	view @ RSControlsView."
	view camera scale: 5.
]

{ #category : #private }
RS3MultigranularDiffPresenter >> initialNodes [
	
	| visitor |
	visitor := RS3IceDiffEntityCollector new.
	iceDiffModel tree accept: visitor.

	^ visitor nodesWithPackages collect: [:each | self nodeForPackageNode: each ].
	

]

{ #category : #accessing }
RS3MultigranularDiffPresenter >> labelStrategy [
	^ labelStrategy
]

{ #category : #accessing }
RS3MultigranularDiffPresenter >> labelStrategy: anObject [
	labelStrategy := anObject
]

{ #category : #private }
RS3MultigranularDiffPresenter >> nodeForClassLevelNode: node [
	| result |
	result := HiMNode for: node.
	node children
		collect: [ :each | HiMNode for: each key ]
		thenDo: [:each | result addChild: each ].
	^ result

]

{ #category : #private }
RS3MultigranularDiffPresenter >> nodeForPackageNode: node [
	| result |
	result := HiMNode for: node.
	node children
		collect: [ :each | self nodeForClassLevelNode: each ]
		thenDo: [ :each | result addChild: each ].
	^ result
]
