Extension { #name : #TSCanvas }

{ #category : #'*Hiedra-Roassal3' }
TSCanvas >> copyWithIndependentCamera [
	^ self shallowCopy
		camera: self camera shallowCopy;
		yourself
]
