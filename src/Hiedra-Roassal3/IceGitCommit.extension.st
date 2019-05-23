Extension { #name : #IceGitCommit }

{ #category : #'*Hiedra-Roassal3' }
IceGitCommit >> authorEmail [
	^ self libgitCommit author email
]
