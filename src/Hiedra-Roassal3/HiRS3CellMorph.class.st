Class {
	#name : #HiRS3CellMorph,
	#superclass : #FTCellMorph,
	#instVars : [
		'view',
		'clipArea'
	],
	#category : #'Hiedra-Roassal3'
}

{ #category : #accessing }
HiRS3CellMorph >> clipArea [
	^ clipArea
]

{ #category : #accessing }
HiRS3CellMorph >> clipArea: anObject [
	clipArea := anObject
]

{ #category : #drawing }
HiRS3CellMorph >> drawOn: aCanvas [
	super drawOn: aCanvas.
"	'super' asMorph drawOn: aCanvas"
]

{ #category : #accessing }
HiRS3CellMorph >> view [
	^ view
]

{ #category : #accessing }
HiRS3CellMorph >> view: anObject [
	view := anObject
]
