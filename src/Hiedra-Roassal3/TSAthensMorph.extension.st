Extension { #name : #TSAthensMorph }

{ #category : #'*Hiedra-Roassal3' }
TSAthensMorph >> copyWithIndependentCamera [
	^ self shallowCopy
		canvas: self canvas copyWithIndependentCamera;
		yourself
]
