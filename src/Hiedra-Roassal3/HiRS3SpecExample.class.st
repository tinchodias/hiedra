Class {
	#name : #HiRS3SpecExample,
	#superclass : #ComposablePresenter,
	#instVars : [
		'hiedraColumnController',
		'table'
	],
	#category : #'Hiedra-Roassal3-Examples'
}

{ #category : #specs }
HiRS3SpecExample class >> defaultSpec [
	^ SpecBoxLayout newVertical
		add: #table;
		yourself
]

{ #category : #specs }
HiRS3SpecExample class >> example2870IcebergCommits [
	self openExample: #iceberg_v1_5_6
]

{ #category : #specs }
HiRS3SpecExample class >> example493PharoCommits [
	self openExample: #pharo_v60507
]

{ #category : #specs }
HiRS3SpecExample class >> example60RandomCommits [
	self openExample: #randomlyGenerated
]

{ #category : #specs }
HiRS3SpecExample class >> openExample: selector [

	| commits |
	commits := HiExampleCommit perform: selector.

	self new
		commits: commits;
		extent: 500 @ 700;
		openWithSpec;
		withWindowDo: [ :window | window title: ('Hiedra in Spec - {1} - {2} elements' format: {selector. commits size}) ]
]

{ #category : #accessing }
HiRS3SpecExample >> commits: commits [ 

	table items: commits.

	hiedraColumnController ruler: (HiRulerBuilder 
		newRulerValues: commits
		linksBlock: [:aCommit |
			aCommit parentIds collect: [:id | 
				commits detect: [:each | each id = id ] ] ]).

	hiedraColumnController reset.
	
	"After #reset, we can know the width of the column."
	table columns first width: hiedraColumnController rulerWidth.
]

{ #category : #initialization }
HiRS3SpecExample >> initializeWidgets [
	
	table := self instantiate: TablePresenter.

	"Configure hiedra controller"
	hiedraColumnController := HiRS3ColumnController new.	

	"Adjust the ruler rendering settings with table's row height."
	hiedraColumnController
		rowHeight: FTTableMorph defaultRowHeight floor;
		onChangeDo: [ table notifyPropertyChanged: #columns ].

	"Configure columns"
	table columns:	{
		ImageTableColumn evaluated: [ :item |
			hiedraColumnController cellMorphAtValue: item ].
		StringTableColumn evaluated: #comment.
	}.

]

{ #category : #accessing }
HiRS3SpecExample >> table [
	^ table
]
