Class {
	#name : #HiTextWidthKeeper,
	#superclass : #Object,
	#category : #'Hiedra-Roassal3-Utils'
}

{ #category : #convenience }
HiTextWidthKeeper class >> stringFor: aString font: aFont maxSize: anInteger [
	| width |
	width := aFont widthOfString: aString.
	^ (width <= anInteger or: [ aString size <= 3 ])
		ifTrue: [ aString ]
		ifFalse: [ self stringFor: ((aString allButLast: 2), '…') font: aFont maxSize: anInteger ]
]
