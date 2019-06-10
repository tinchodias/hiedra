Class {
	#name : #IceTipHiRS3DataSource,
	#superclass : #IceTipDataSource,
	#instVars : [
		'hiedraColumnController',
		'entityById'
	],
	#category : #'Hiedra-Roassal3'
}

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
	hiedraColumnController renderer rowHeight: self table rowHeight floor.

	"Create a new ruler model with the new elements"
	self refreshRulerWithCurrentElements.

	"Reset the visualization"
	hiedraColumnController reset.
	
	"Adjust the column width in the table"
	self table columns first width: hiedraColumnController rulerWidth.

]

{ #category : #private }
IceTipHiRS3DataSource >> freshAvatarsByEmail [

	| firstRemote commitsByEmail commitsIdsToQuery credentials client |
	elements ifEmpty: [ ^self ].
	firstRemote := elements first repositoryModel entity remotes
		ifEmpty: [ ^self ] ifNotEmpty: #first.
	
	commitsByEmail := elements groupedBy: [ :each | each entity authorEmail ].
	commitsIdsToQuery := commitsByEmail values collect: [:each | each last id ].
	credentials := IceGitHubAPI ensureCredentials; obtainCredentials.

	client := HiGithubAvatarClient new
		remote: firstRemote;
		credentials: credentials;
		avatarSize: self nodeSize;
		commitsIds: commitsIdsToQuery;
		yourself.

	^ [ client get.
		client avatarByEmail ]
			on: NetworkError, ZnHttpUnsuccessful
			do: [ :each | Dictionary new ].

]

{ #category : #initialization }
IceTipHiRS3DataSource >> initialize [
	
	super initialize.

	hiedraColumnController := HiRS3ColumnController new.
]

{ #category : #accessing }
IceTipHiRS3DataSource >> nodeSize [
	^ 20
]

{ #category : #private }
IceTipHiRS3DataSource >> refreshAvatarsWithCurrentElements [

	| avatarByEmail |
	avatarByEmail := self freshAvatarsByEmail.
	hiedraColumnController renderer commitAvatarFactory: [ :commitId |
		avatarByEmail
			at: (entityById at: commitId) authorEmail
			ifAbsent: [ self iconNamed: #user ] ]
]

{ #category : #private }
IceTipHiRS3DataSource >> refreshRulerWithCurrentElements [

	entityById := Dictionary new.
	elements do: [ :aCommit |
		"Note: Hiedra expects each ancestor id corresponds to a commit in elements."
		entityById
			at: aCommit id
			put: aCommit entity ].
	hiedraColumnController renderer
		nodeSize: self nodeSize.

	hiedraColumnController ruler: (HiRulerBuilder
		newRulerValues: (elements collect: #id)
		linksBlock: [ :id | (entityById at: id) ancestorIds ]).

	hiedraColumnController table: self table.

	self refreshAvatarsWithCurrentElements
]
