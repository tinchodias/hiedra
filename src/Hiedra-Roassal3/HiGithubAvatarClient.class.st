Class {
	#name : #HiGithubAvatarClient,
	#superclass : #Object,
	#instVars : [
		'remote',
		'credentials',
		'avatarSize',
		'commitsIds',
		'avatarUrlByEmail',
		'avatarByEmail'
	],
	#category : #'Hiedra-Roassal3-Examples-Iceberg'
}

{ #category : #'accessing - response' }
HiGithubAvatarClient >> avatarByEmail [
	^ avatarByEmail
]

{ #category : #private }
HiGithubAvatarClient >> avatarFor: urlString [

	^ ZnEasy getImage: urlString, '&s=', self avatarSize asString

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

{ #category : #action }
HiGithubAvatarClient >> get [

	| response |

	"Query Github"
	
	([	response := IceGitHubAPI new
		credentials: self credentials;
		graphql: self graphQL.
	] timeToRun asMilliSeconds asString, ' - to query github') logCr.

	"On sucess: Get avatar URLs"
	avatarUrlByEmail := Dictionary new.
	((response at: 'data') at: 'repository') values
		collect: [:each | each at: 'author' ]
		thenDo: [:each |
			avatarUrlByEmail
				at: (each at: 'email')
				put: (each at: 'avatarUrl') ].

	self flag: #todo. "On fail!?"

	"Get avatar images"
	([self getAvatarsAsync] timeToRun asMilliSeconds asString, ' - to get ALL avatars') logCr.

]

{ #category : #private }
HiGithubAvatarClient >> getAvatarsAsync [

	| sharedQueue semaphore |
	sharedQueue := SharedQueue new.
	semaphore := Semaphore new.

	avatarUrlByEmail keysAndValuesDo: [ :email :urlString |
		[
		
		[ | avatar |
		avatar := self avatarFor: urlString.
		sharedQueue	nextPut: (email -> avatar) ]
			on: NetworkError, ZnHttpUnsuccessful
			do: [ :each | ].
		semaphore signal.
		] fork ].
	avatarUrlByEmail size timesRepeat: [ semaphore wait ].

	avatarByEmail := Dictionary new.
	sharedQueue contents do: [ :association |
		avatarByEmail at: association key put: association value ].

]

{ #category : #private }
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
