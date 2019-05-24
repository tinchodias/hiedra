Extension { #name : #IceTipCommitModel }

{ #category : #'*Hiedra-Roassal3' }
IceTipCommitModel >> descriptionWithDecoration [
	| text |
	text := (', ' join: self entity tagNames) asText allBold makeAllColor: Color gray.
	text ifNotEmpty: [ text := text , ' ' ].
	text append: (self entity comment withLineEndings: ' ') asText.
	^ text
]
