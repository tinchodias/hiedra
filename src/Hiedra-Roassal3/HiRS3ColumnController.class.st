Class {
	#name : #HiRS3ColumnController,
	#superclass : #Object,
	#instVars : [
		'cellMorphByRowIndex',
		'view',
		'table',
		'viewBuilder'
	],
	#category : #'Hiedra-Roassal3-UI'
}

{ #category : #API }
HiRS3ColumnController >> cellMorphAtRow: rowIndex [
	"Answer a Morph that corresponds to a row index. The height of such Morph is given by renderer's rowHeight and the width is given by the ruler's numberOfColumns and the renderer's cellWidth.
	This is an important method of this class, that the table widget will use to fill each Hiedra column's cell."

	^ cellMorphByRowIndex at: rowIndex ifAbsent: [ self newCellMorphForRow: rowIndex ]
]

{ #category : #API }
HiRS3ColumnController >> cellMorphAtValue: aValue [
	"Answer a Morph that corresponds to aValue. See #cellMorphAtRowIndex: for more information."

	^ self cellMorphAtRow: (self rowIndexAtValue: aValue)
]

{ #category : #initialization }
HiRS3ColumnController >> initialize [

	super initialize.
	viewBuilder := HiRS3ViewBuilder new.
	self reset.
]

{ #category : #private }
HiRS3ColumnController >> newCellMorphForRow: rowIndex [
	"Answer a Morph that corresponds to aValue in the rendered ruler."

	| cellY copy rectangle copyRectangle copyShapes |
	cellY := ((viewBuilder ruler nodeAtRow: rowIndex) rulerPoint y) * viewBuilder rowHeight.

	rectangle := (0@(viewBuilder rowHeight) rectangle: (viewBuilder formWidth @ viewBuilder formHeight)).

	view ifNil: [
		viewBuilder onGoToDo: [:aHiNode | table selectIndex: aHiNode rulerPoint y ].
		view := viewBuilder newView.
		].

	"Create a copy"
	copy := view morph copyWithIndependentCamera.
	copyRectangle := Rectangle 
		rsCenter: rectangle rsCenter x@cellY 
		extent: viewBuilder formWidth @ viewBuilder rowHeight.

	"Time optimization for drawOn until RS3 implements it: the canvas only knows the shapes that are visible."
	copyShapes := view canvas shapes select: [ :s | copyRectangle intersects: s encompassingRectangle ].
	copy canvas shapes: copyShapes.

	"The main goal of this code: the camera must point to the right value."
	copy canvas camera translateTo: copyRectangle rsCenter.
	
	"When the use clicks on the empty area (the canvas), we extect that the row gets the selection."
	copy canvas when: TSMouseClick do: [ table selectIndex: rowIndex ].
	
	^ copy

]

{ #category : #API }
HiRS3ColumnController >> onChangeDo: aBlockClosure [ 
	viewBuilder onChangeDo: aBlockClosure
]

{ #category : #API }
HiRS3ColumnController >> reset [
	"Reset the internal state with the purpose to regenerate the visualization the next time #cellMorphFor: is executed."

	cellMorphByRowIndex := Dictionary new.
	view := nil.
]

{ #category : #API }
HiRS3ColumnController >> rowHeight: anInteger [
	viewBuilder rowHeight: anInteger
]

{ #category : #private }
HiRS3ColumnController >> rowIndexAtValue: aValue [
	^ viewBuilder ruler valueIndices
		at: aValue
		ifAbsent: [ self error: 'Value not found. Should the table refresh the ruler?' ]
]

{ #category : #API }
HiRS3ColumnController >> ruler: aHiRuler [
	viewBuilder ruler: aHiRuler
]

{ #category : #API }
HiRS3ColumnController >> rulerWidth [

	^ viewBuilder formWidth
]

{ #category : #accessing }
HiRS3ColumnController >> table [
	^ table
]

{ #category : #accessing }
HiRS3ColumnController >> table: anObject [
	table := anObject
]

{ #category : #API }
HiRS3ColumnController >> viewBuilder [
	^ viewBuilder
]
