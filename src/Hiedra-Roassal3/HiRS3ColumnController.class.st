Class {
	#name : #HiRS3ColumnController,
	#superclass : #Object,
	#instVars : [
		'renderer',
		'cellMorphByRowIndex',
		'view',
		'table'
	],
	#category : #'Hiedra-Roassal3'
}

{ #category : #API }
HiRS3ColumnController >> cellMorphAtRow: rowIndex [
	"Answer a Morph that corresponds to a row index. The height of such Morph is given by renderer's rowHeight and the width is given by the ruler's numberOfColumns and the renderer's cellWidth.
	This is an important method of this class, that the table widget will use to fill each Hiedra column's cell."

	^ cellMorphByRowIndex at: rowIndex ifAbsent: [ self newCellMorphForRow: rowIndex ]
]

{ #category : #initialization }
HiRS3ColumnController >> initialize [

	super initialize.
	renderer := HiRS3Renderer new.
	self reset.
]

{ #category : #private }
HiRS3ColumnController >> newCellMorphForRow: rowIndex [
	"Answer a Morph that corresponds to aValue in the rendered ruler."

	| cellY copy rectangle copyRectangle copyShapes |
	cellY := ((renderer ruler nodeAtRow: rowIndex) rulerPoint y) * renderer rowHeight.

	renderer rowsInterval: (1 to: renderer ruler numberOfRows).
	rectangle := (0@(renderer rowHeight) rectangle: (renderer formWidth @ renderer formHeight)).

	view ifNil: [
		view := renderer newView.
		view createMorph.
		view camera 
			translateTo: rectangle rsCenter;
			scale: 1.
		view morph extent: renderer formWidth @ renderer rowHeight.

		view elements do: [:e |
			e attributes at: #originalColor put: e color.
			e attributes at: #originalBorderColor put: e border color.
			e
				when: TSMouseClick do: [ e inspect ];
				when: TSMouseEnter do: [ 
					e color: (e color mixed: 0.8 with: UITheme current textColor).
					e border color: UITheme current textColor.
					table changed ];
				when: TSMouseLeave do: [
					e color: (e attributes at: #originalColor).
					e border color: (e attributes at: #originalBorderColor).
					table changed ].
			].
		
		view edges do: [ :e |
			e attributes at: #originalColor put: e color.
			e
				when: TSMouseClick do: [ e inspect ];
				when: TSMouseEnter do: [ 
					e color: (e color mixed: 0.8 with: UITheme current textColor).
					table changed ];
				when: TSMouseLeave do: [
					e color: (e attributes at: #originalColor).
					table changed ].
			
			 ]
		].

	"Create a copy"
	copy := view morph copyWithIndependentCamera.
	copyRectangle := Rectangle 
		rsCenter: rectangle rsCenter x@cellY 
		extent: renderer formWidth @ renderer rowHeight.

	"Time optimization for drawOn until RS3 implements it: the canvas only knows the shapes that are visible."
	copyShapes := view canvas shapes select: [ :s | copyRectangle intersects: s encompassingRectangle ].
	copy canvas shapes: copyShapes.

	"The main goal of this code: the camera must point to the right value."
	copy canvas camera translateTo: copyRectangle rsCenter.
	
	"When the use clicks on the empty area (the canvas), we extect that the row gets the selection."
	copy canvas when: TSMouseClick do: [ table selectIndex: rowIndex ].
	
	^copy
	
]

{ #category : #API }
HiRS3ColumnController >> renderer [
	^ renderer
]

{ #category : #API }
HiRS3ColumnController >> reset [
	"Reset the internal state with the purpose to regenerate the visualization the next time #cellMorphFor: is executed."

	cellMorphByRowIndex := Dictionary new.
	view := nil.
]

{ #category : #API }
HiRS3ColumnController >> ruler: aHiRuler [
	renderer ruler: aHiRuler
]

{ #category : #API }
HiRS3ColumnController >> rulerWidth [

	^ renderer formWidth
]

{ #category : #accessing }
HiRS3ColumnController >> table [
	^ table
]

{ #category : #accessing }
HiRS3ColumnController >> table: anObject [
	table := anObject
]
