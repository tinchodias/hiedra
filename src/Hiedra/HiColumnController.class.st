"
I am a column controller. I provide a simple API to users of the Hiedra library either in Spec or Morph (FastTable).
"
Class {
	#name : #HiColumnController,
	#superclass : #Object,
	#instVars : [
		'cellMorphByValue',
		'renderer',
		'formByPageIndex'
	],
	#category : #'Hiedra-UI'
}

{ #category : #private }
HiColumnController >> cellBoundsInPage: pageIndex for: aValue [
	
	| aNode valueRelativeIndex pageFirstRowIndex |
	aNode := self ruler nodeAt: aValue ifAbsent: [ self error ].
	pageFirstRowIndex := (self rowsIntervalForPageIndex: pageIndex) first.
	valueRelativeIndex := aNode rulerPoint y - pageFirstRowIndex.

	^ 0 @ (valueRelativeIndex * renderer rowHeight)
		corner: self rulerWidth @ ((valueRelativeIndex + 1) * renderer rowHeight)
]

{ #category : #API }
HiColumnController >> cellMorphFor: aValue [

	^ cellMorphByValue at: aValue ifAbsent: [ self newCellMorphFor: aValue ]
]

{ #category : #initialization }
HiColumnController >> initialize [

	super initialize.
	renderer := HiSimpleRenderer new.
	self refresh.
]

{ #category : #private }
HiColumnController >> newCellMorphFor: aValue [
	"Answer a Morph that corresponds to aValue in the rendered ruler."

	| pageIndex pageForm aForm cellBoundsInPage |
	pageIndex := self pageIndexFor: aValue.
	pageForm := self pageFormAt: pageIndex.
	cellBoundsInPage := self cellBoundsInPage: pageIndex for: aValue.

	aForm := Form extent: cellBoundsInPage extent depth: 32.
	
	aForm getCanvas
		translucentImage: pageForm
			at: 0@0
			sourceRect: cellBoundsInPage truncated.
	^ aForm asMorph
]

{ #category : #private }
HiColumnController >> pageFormAt: pageIndex [

	^ formByPageIndex
		at: pageIndex
		ifAbsentPut: [
			renderer
				rowsInterval: (self rowsIntervalForPageIndex: pageIndex);
				newForm ]
]

{ #category : #private }
HiColumnController >> pageIndexFor: aValue [
	| rowIndex |
	rowIndex := self ruler values indexOf: aValue.
	self assert: rowIndex > 0. "Else, aValue is not a ruler value."
	^ (rowIndex - 1) // self pageSize
]

{ #category : #private }
HiColumnController >> pageSize [
	^ 30
]

{ #category : #API }
HiColumnController >> refresh [
	"Generate the Hiedra model and visualization for the settings previously configured."

	cellMorphByValue := Dictionary new.
	formByPageIndex := Dictionary new.
]

{ #category : #API }
HiColumnController >> renderer [
	^ renderer
]

{ #category : #private }
HiColumnController >> rowsIntervalForPageIndex: anInteger [
	^ (anInteger * self pageSize) + 1 to: (((anInteger + 1) * self pageSize) min: self ruler numberOfRows)
]

{ #category : #API }
HiColumnController >> ruler [
	^ renderer ruler
]

{ #category : #API }
HiColumnController >> ruler: aHiRuler [
	renderer ruler: aHiRuler
]

{ #category : #API }
HiColumnController >> rulerWidth [

	^ renderer formWidth
]
