Class {
	#name : #HiRS3SpecExample,
	#superclass : #SpPresenter,
	#instVars : [
		'hiedraColumnController',
		'table'
	],
	#category : #'Hiedra-Roassal3-Examples'
}

{ #category : #specs }
HiRS3SpecExample class >> defaultSpec [
	^ SpBoxLayout newVertical
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
		openWithSpec;
		withWindowDo: [ :window |
			window
				extent: 600 @ 800;
				title: ('Hiedra in Spec2 with Roassal3 - {1} - {2} elements' format: {selector. commits size}) ].

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
	table := self newTable.

	"Configure hiedra controller"
	hiedraColumnController := HiRS3ColumnController new.
	hiedraColumnController
		rowHeight: FTTableMorph defaultRowHeight floor.

	table announcer
		when: SpWidgetBuilt
		send: #onTableWidgetBuilt
		to: self.

	"Configure columns"
	table
		addColumn: (SpImageTableColumn evaluated: [ :item | hiedraColumnController cellMorphAtValue: item ]);
		addColumn: (SpStringTableColumn evaluated: #comment)
]

{ #category : #initialization }
HiRS3SpecExample >> onTableWidgetBuilt [
	"Set up the Hiedra controller with the widget (assumes Morph)."

	self flag: #todo.
	hiedraColumnController
		table: table adapter widget;
		onChangeDo: [ table adapter widget ifNotNil: [ table adapter widget changed ] ]

]

{ #category : #initialization }
HiRS3SpecExample >> onTableWidgetBuilt: announcement [
	"Set up the Hiedra controller with the table widget."

	| tableWidget |
	tableWidget := announcement widget.
	hiedraColumnController
		table: tableWidget;
		onChangeDo: [ tableWidget ifNotNil: [ tableWidget changed ] ]

]
