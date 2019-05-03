Class {
	#name : #HiRS3ColumnController,
	#superclass : #Object,
	#instVars : [
		'renderer',
		'cellMorphByRowIndex',
		'view'
	],
	#category : #'Hiedra-Roassal3'
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
	renderer := HiRS3Renderer new.
	cellMorphByRowIndex := Dictionary new.
	self reset.
]

{ #category : #private }
HiRS3ColumnController >> newCellMorphForRow: rowIndex [
	"Answer a Morph that corresponds to aValue in the rendered ruler."

	| cellY copy rectangle |
	cellY := ((self ruler nodeAtRow: rowIndex) rulerPoint y) * renderer rowHeight.

	renderer rowsInterval: (1 to: self ruler numberOfRows).
	rectangle := (0@(renderer rowHeight) rectangle: (renderer formWidth @ renderer formHeight)).

	view ifNil: [

		view := renderer newView.
		view color: Color transparent.
		view createMorph.
		view camera 
			translateTo: rectangle rsCenter;
			scale: 1.
		view morph extent: renderer formWidth @ renderer rowHeight.
		
		].
	copy := view morph copyWithIndependentCamera.
	
	copy canvas camera translateTo: rectangle rsCenter x@cellY.
	^copy
	
	"HiRS3CellMorph new
		view: view;
		addMorphBack: 'hola' asMorph;
		clipArea: cellBoundsInPage;
		yourself.
"
]

{ #category : #API }
HiRS3ColumnController >> renderer [
	^ renderer
]

{ #category : #API }
HiRS3ColumnController >> renderer: aHiRulerRenderer [
	renderer := aHiRulerRenderer
]

{ #category : #API }
HiRS3ColumnController >> reset [
	"Reset the internal state with the purpose to regenerate the visualization the next time #cellMorphFor: is executed."

	cellMorphByRowIndex := Dictionary new.
	view := nil.
]

{ #category : #API }
HiRS3ColumnController >> rowIndexAtValue: aValue [
	^ self ruler valueIndices
		at: aValue
		ifAbsent: [ self error: 'Value not found. Should the table refresh the ruler?' ]
]

{ #category : #API }
HiRS3ColumnController >> ruler [
	^ renderer ruler
]

{ #category : #API }
HiRS3ColumnController >> ruler: aHiRuler [
	renderer ruler: aHiRuler
]

{ #category : #API }
HiRS3ColumnController >> rulerWidth [

	^ renderer formWidth
]
