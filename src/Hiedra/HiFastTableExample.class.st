"
I am an example of use of Hiedra in a FastTable.
"
Class {
	#name : #HiFastTableExample,
	#superclass : #FTSimpleDataSource,
	#instVars : [
		'hiedraColumnController'
	],
	#category : #'Hiedra-UI-Examples'
}

{ #category : #examples }
HiFastTableExample class >> example2870IcebergCommits [
	self openExample: #iceberg_v1_5_6
]

{ #category : #examples }
HiFastTableExample class >> example493PharoCommits [
	self openExample: #pharo_v60507
]

{ #category : #examples }
HiFastTableExample class >> example60RandomCommits [
	self openExample: #randomlyGenerated
]

{ #category : #examples }
HiFastTableExample class >> openExample: selector [

	| commits dataSource table |
	commits := HiExampleCommit perform: selector.
	dataSource := self new elements: commits; yourself.

	table := FTTableMorph new
		extent: 500 @ 700;
		addColumn: (FTColumn id: 'Hiedra');
		addColumn: (FTColumn id: 'Comment');
		dataSource: dataSource;
		rowHeight: dataSource rowHeight;
		beResizable;
		yourself.
	
	table openInWindowLabeled: ('Hiedra in FastTable - {1} - {2} elements' format: {selector. commits size})
]

{ #category : #accessing }
HiFastTableExample >> cellColumn: column row: rowIndex [
	"Answer a morph with the cell view."
	
	| commit |
	commit := self elementAt: rowIndex.

	column id = 'Hiedra' ifTrue: [ 
		^ FTCellMorph new
			addMorphBack: (hiedraColumnController cellMorphFor: commit id);
			yourself
		].

	column id = 'Comment' ifTrue: [ 
		^ commit comment asMorph ].

	^ super cellColumn: column row: rowIndex
]

{ #category : #accessing }
HiFastTableExample >> elements: anObject [

	super elements: anObject.

	hiedraColumnController ruler: (HiRulerBuilder 
		newRulerValues: (elements collect: #id)
		linksBlock: [:id | (elements detect: [:each | each id = id ]) parentIds ]).

	hiedraColumnController refresh.

]

{ #category : #accessing }
HiFastTableExample >> initialize [

	super initialize.

	hiedraColumnController := HiColumnController new.

	"We must set the right height of rows"
	hiedraColumnController renderer rowHeight: self rowHeight.
]

{ #category : #accessing }
HiFastTableExample >> readyToBeDisplayed [
	"In this example we know the controller is already initialized."
	
	self table columns first width: hiedraColumnController rulerWidth.
]

{ #category : #accessing }
HiFastTableExample >> rowHeight [
	^ 22
]
