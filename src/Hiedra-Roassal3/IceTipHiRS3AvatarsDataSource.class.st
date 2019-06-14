"
Abstract DataSource. My subclasses demonstrate how to show avatars in Iceberg repositories view.
"
Class {
	#name : #IceTipHiRS3AvatarsDataSource,
	#superclass : #IceTipHiRS3DataSource,
	#instVars : [
		'avatarByEmail'
	],
	#category : #'Hiedra-Roassal3-Examples-Iceberg'
}

{ #category : #accessing }
IceTipHiRS3AvatarsDataSource >> avatarFor: commitId [
	^ avatarByEmail
		at: (commitById at: commitId) authorEmail
		ifAbsent: [ self iconNamed: #user ]
]

{ #category : #accessing }
IceTipHiRS3AvatarsDataSource >> avatarSize [
	^ self subclassResponsibility
]

{ #category : #private }
IceTipHiRS3AvatarsDataSource >> freshAvatarsByEmail [

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
		avatarSize: self avatarSize;
		commitsIds: commitsIdsToQuery;
		yourself.

	^ [ client get.
		client avatarByEmail ]
			on: NetworkError, ZnHttpUnsuccessful
			do: [ :each | Dictionary new ].

]

{ #category : #private }
IceTipHiRS3AvatarsDataSource >> refreshRulerWithCurrentElements [
	super refreshRulerWithCurrentElements.
	
	avatarByEmail := self freshAvatarsByEmail.
]
