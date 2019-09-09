Class {
	#name : #HiGtkColumnController,
	#superclass : #HiColumnController,
	#category : #'Hiedra-UI'
}

{ #category : #private }
HiGtkColumnController >> formAtPage: pageIndex [

	^ formByPageIndex
		at: pageIndex
		ifAbsentPut: [
			renderer
				rowsInterval: (self rowIntervalAtPage: pageIndex);
				newAthensSurface ]
]

{ #category : #private }
HiGtkColumnController >> newCellMorphForRow: rowIndex [
	"Answer a Morph that corresponds to aValue in the rendered ruler."

	| pageIndex cellBoundsInPage rectangleToCut pageAthensSurface |
	pageIndex := self pageIndexAtRow: rowIndex.
	cellBoundsInPage := self
		cellBoundsForRow: rowIndex
		inPage: pageIndex.

	pageAthensSurface := self formAtPage: pageIndex.
	rectangleToCut := cellBoundsInPage truncated.

	^ GdkPixbuf
		newFromSurface: pageAthensSurface
		x: rectangleToCut left
		y: rectangleToCut top
		width: rectangleToCut width
		height: rectangleToCut height
]
