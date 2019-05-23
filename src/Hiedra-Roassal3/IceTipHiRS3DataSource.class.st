Class {
	#name : #IceTipHiRS3DataSource,
	#superclass : #IceTipDataSource,
	#instVars : [
		'hiedraColumnController'
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

{ #category : #accessing }
IceTipHiRS3DataSource >> getAllAvatars [

	| github firstRemote commitsIdsToQuery graphQL response commitsByEmail avatarUrlByEmail avatarByEmail |
	avatarUrlByEmail := Dictionary new.
	avatarByEmail := Dictionary new.
	elements ifEmpty: [ ^self ].
	firstRemote := elements first repositoryModel entity remotes
		ifEmpty: [ ^self ] ifNotEmpty: #first.
	
	commitsByEmail := elements groupedBy: [ :each | each entity authorEmail ].
	commitsIdsToQuery := commitsByEmail values collect: [:each | each first id ].

	github := IceGitHubAPI new credentials: (IceGitHubAPI ensureCredentials; obtainCredentials); yourself.

	graphQL := String streamContents: [ :stream |
		stream << '{ repository(owner: "' << firstRemote owner << '", name: "' << firstRemote projectName << '") {'.
		commitsIdsToQuery doWithIndex: [ :id :index |
			stream << 'u' << index asString << ' : object(oid: "' << id << '") { ...foo } ' ].
		stream << '} }
fragment foo on GitObject {
  ... on Commit {
    author {
      email
      avatarUrl
    }
  }
}
'		].
	
	response := github graphql: graphQL.

	((response at: 'data') at: 'repository') values collect: [:each | each at: 'author' ] thenDo: [:each |
		avatarUrlByEmail at: (each at: 'email') put: (each at: 'avatarUrl') ].

	avatarUrlByEmail keysAndValuesDo: [ :key :value |
		| paint form |
		form := ZnEasy getJpeg: value, '&s=16'.
		paint := (AthensCairoPatternSurfacePaint createForSurface: (AthensCairoSurface fromForm: form)).
		paint origin: (form extent / 2) negated.
		avatarByEmail at: key put: paint.
	].

	hiedraColumnController renderer avatarByEmail: avatarByEmail.
]

{ #category : #accessing }
IceTipHiRS3DataSource >> initialize [
	
	super initialize.

	hiedraColumnController := HiRS3ColumnController new.
]

{ #category : #accessing }
IceTipHiRS3DataSource >> refreshRulerWithCurrentElements [

	| entityById |
	entityById := Dictionary new.
	elements do: [ :aCommit |
		"Note: Hiedra expects each ancestor id corresponds to a commit in elements."
		entityById
			at: aCommit id
			put: aCommit entity ].
	hiedraColumnController renderer entityById: entityById.

	hiedraColumnController ruler: (HiRulerBuilder
		newRulerValues: (elements collect: #id)
		linksBlock: [ :id | (entityById at: id) ancestorIds ]).

	hiedraColumnController table: self table.

	self getAllAvatars.
]
