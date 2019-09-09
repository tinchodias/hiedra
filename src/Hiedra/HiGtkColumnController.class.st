Class {
	#name : #HiGtkColumnController,
	#superclass : #HiColumnController,
	#category : #'Hiedra-UI'
}

{ #category : #private }
HiGtkColumnController >> newCellMorphForRow: rowIndex [
	"Answer a Morph that corresponds to aValue in the rendered ruler."

	| pageIndex aForm cellBoundsInPage rectangleToCut anAthensSurface |
	pageIndex := self pageIndexAtRow: rowIndex.
	cellBoundsInPage := self
		cellBoundsForRow: rowIndex
		inPage: pageIndex.

	anAthensSurface := self formAtPage: pageIndex.
	rectangleToCut := cellBoundsInPage truncated.

		
	aForm := Form
		extent: cellBoundsInPage extent
		depth: 32.
	aForm getCanvas
		translucentImage: anAthensSurface
		at: 0 @ 0
		sourceRect: rectangleToCut.
	^ aForm
]
