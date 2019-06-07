Class {
	#name : #HiGithubAvatarClient,
	#superclass : #Object,
	#instVars : [
		'remote',
		'credentials',
		'avatarSize',
		'defaultAvatar',
		'commitsIds',
		'avatarUrlByEmail',
		'avatarByEmail'
	],
	#category : #'Hiedra-Roassal3'
}

{ #category : #'accessing - response' }
HiGithubAvatarClient >> avatarByEmail [
	^ avatarByEmail
]

{ #category : #private }
HiGithubAvatarClient >> avatarFor: urlString [

	^ [ ZnEasy getImage: urlString, '&s=', self avatarSize asString ]
			on: ZnHttpUnsuccessful
			do: [ :each | self defaultAvatar ]
]

{ #category : #'accessing - request' }
HiGithubAvatarClient >> avatarSize [
	^ avatarSize
]

{ #category : #'accessing - request' }
HiGithubAvatarClient >> avatarSize: anObject [
	avatarSize := anObject
]

{ #category : #'accessing - response' }
HiGithubAvatarClient >> avatarUrlByEmail [
	^ avatarUrlByEmail
]

{ #category : #'accessing - request' }
HiGithubAvatarClient >> commitsIds [
	^ commitsIds
]

{ #category : #'accessing - request' }
HiGithubAvatarClient >> commitsIds: anObject [
	commitsIds := anObject
]

{ #category : #'accessing - request' }
HiGithubAvatarClient >> credentials [
	^ credentials
]

{ #category : #'accessing - request' }
HiGithubAvatarClient >> credentials: anObject [
	credentials := anObject
]

{ #category : #'accessing - request' }
HiGithubAvatarClient >> defaultAvatar [

	^ defaultAvatar ifNil: [ self iconNamed: #user ]
]

{ #category : #'accessing - request' }
HiGithubAvatarClient >> defaultAvatar: aForm [

	defaultAvatar := aForm
]

{ #category : #action }
HiGithubAvatarClient >> get [

	| response |

	"Query Github"
	response := IceGitHubAPI new
		credentials: self credentials;
		graphql: self graphQL.

	"On sucess: Get avatar URLs"
	avatarUrlByEmail := Dictionary new.
	((response at: 'data') at: 'repository') values
		collect: [:each | each at: 'author' ]
		thenDo: [:each |
			avatarUrlByEmail
				at: (each at: 'email')
				put: (each at: 'avatarUrl') ].

	self flag: #todo. "On fail"

	"Get avatar images"
	avatarByEmail := Dictionary new.
	avatarUrlByEmail keysAndValuesDo: [ :email :urlString |
		avatarByEmail at: email put: (self avatarFor: urlString) ].

]

{ #category : #action }
HiGithubAvatarClient >> graphQL [
	^ String streamContents: [ :stream |
		stream << '{ repository(owner: "' << remote owner << '", name: "' << remote projectName << '") {'.
		commitsIds doWithIndex: [ :id :index |
			stream << 'u' << index asString << ' : object(oid: "' << id << '") { ...authorFragment } ' ].
		stream << '} }
fragment authorFragment on GitObject {
  ... on Commit {
    author {
      email
      avatarUrl
    }
  }
}
' ].
]

{ #category : #'accessing - request' }
HiGithubAvatarClient >> remote [
	^ remote
]

{ #category : #'accessing - request' }
HiGithubAvatarClient >> remote: anObject [
	remote := anObject
]
