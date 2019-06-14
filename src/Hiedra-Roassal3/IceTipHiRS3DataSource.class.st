Class {
	#name : #IceTipHiRS3DataSource,
	#superclass : #IceTipDataSource,
	#instVars : [
		'hiedraColumnController',
		'commitById'
	],
	#classVars : [
		'CurrentDataSourceClass'
	],
	#category : #'Hiedra-Roassal3-Examples-Iceberg'
}

{ #category : #accessing }
IceTipHiRS3DataSource class >> beCurrentDataSourceClass [
	CurrentDataSourceClass := self
]

{ #category : #accessing }
IceTipHiRS3DataSource class >> currentDataSourceClass [
	^ CurrentDataSourceClass ifNil: [ IceTipDataSource ]
]

{ #category : #accessing }
IceTipHiRS3DataSource class >> currentDataSourceClass: aClass [
	CurrentDataSourceClass := aClass
]

{ #category : #'instance creation' }
IceTipHiRS3DataSource class >> newCurrentDataSource [
	^ self currentDataSourceClass new
]

{ #category : #accessing }
IceTipHiRS3DataSource class >> resetCurrentDataSourceClass [
	CurrentDataSourceClass := nil
]

{ #category : #accessing }
IceTipHiRS3DataSource >> cellColumn: column row: rowIndex [
	"Answer a morph with the cell view. I will probably return a FTCellMorph."
	
	column id = ' ' ifTrue: [ 
		^ FTCellMorph new
			addMorphBack: (hiedraColumnController cellMorphAtRow: rowIndex);
			yourself
		].
	
	^ super cellColumn: column row: rowIndex
]

{ #category : #accessing }
IceTipHiRS3DataSource >> elements: commits [

	super elements: commits.

	self table ifNil: [ ^self ].
	
	"Adjust the ruler rendering settings with table's row height."
	hiedraColumnController
		rowHeight: self table rowHeight floor;
		onChangeDo: [ self table changed ].

	"Create a new ruler model with the new elements"
	self refreshRulerWithCurrentElements.

	"Reset the visualization"
	hiedraColumnController reset.
	
	"Adjust the column width in the table"
	self table columns first width: hiedraColumnController rulerWidth.

]

{ #category : #initialization }
IceTipHiRS3DataSource >> initialize [
	
	super initialize.

	hiedraColumnController := HiRS3ColumnController new.
]

{ #category : #private }
IceTipHiRS3DataSource >> refreshRulerWithCurrentElements [

	commitById := Dictionary new.
	elements do: [ :aCommit |
		"Note: Hiedra expects each ancestor id corresponds to a commit in elements."
		commitById
			at: aCommit id
			put: aCommit entity ].

	hiedraColumnController ruler: (HiRulerBuilder
		newRulerValues: (elements collect: #id)
		linksBlock: [ :id | (commitById at: id) ancestorIds ]).

	hiedraColumnController table: self table.

]
