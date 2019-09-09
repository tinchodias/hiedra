Class {
	#name : #HiGtkColumnController,
	#superclass : #HiColumnController,
	#category : #'Hiedra-UI'
}

{ #category : #private }
HiGtkColumnController >> formAtPage: pageIndex [
	"For GTK, answer the AthensSurface that represents a page with many table cells (see #pageSize)."

	^ formByPageIndex
		at: pageIndex
		ifAbsentPut: [
			renderer
				rowsInterval: (self rowIntervalAtPage: pageIndex);
				newAthensSurface ]
]

{ #category : #private }
HiGtkColumnController >> newCellMorphForRow: rowIndex [
	"For GTK, answer the GdkPixbuf directly that represents one table cell."

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
