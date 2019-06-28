Extension { #name : #DAPackageDependency }

{ #category : #'*Hiedra-Roassal3' }
DAPackageDependency >> accept: aVisitor [
	^ aVisitor perform: self visitSelector with: self.
]

{ #category : #'*Hiedra-Roassal3' }
DAPackageDependency >> visitSelector [
	^ ('visit', self className, ':') asSymbol
]
