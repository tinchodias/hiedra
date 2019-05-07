Extension { #name : #TSCanvas }

{ #category : #'*Hiedra-Roassal3' }
TSCanvas >> copyWithIndependentCamera [

	| cam copy |
	cam := self camera shallowCopy.
	copy := self shallowCopy
		camera: cam;
		yourself.
	cam canvas: copy.
	^ copy.
]
