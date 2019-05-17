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

{ #category : #'private - menu' }
HiRS3ColumnController >> actionGoTo: aHiNode [
	table selectIndex: aHiNode rulerPoint y
]

{ #category : #'private - highlighting' }
HiRS3ColumnController >> basicHighlightNode: aRSElement [
	aRSElement color:
		((aRSElement attributes at: #originalColor)
				mixed: 0.8
				with: UITheme current textColor).
	aRSElement border color: UITheme current textColor
]

{ #category : #'private - highlighting' }
HiRS3ColumnController >> basicUnhighlightElement: aRSElement [
	aRSElement color: (aRSElement attributes at: #originalColor).
	aRSElement border
		color: (aRSElement attributes at: #originalBorderColor);
		width: (aRSElement attributes at: #originalBorderWidth).
]

{ #category : #API }
HiRS3ColumnController >> cellMorphAtRow: rowIndex [
	"Answer a Morph that corresponds to a row index. The height of such Morph is given by renderer's rowHeight and the width is given by the ruler's numberOfColumns and the renderer's cellWidth.
	This is an important method of this class, that the table widget will use to fill each Hiedra column's cell."

	^ cellMorphByRowIndex at: rowIndex ifAbsent: [ self newCellMorphForRow: rowIndex ]
]

{ #category : #'private - menu' }
HiRS3ColumnController >> edgeMenuInteraction [
	^ RSMenuActivable new
		menuDo: [ :menu :edge | 
			(menu
				add: 'Go to origin'
				target: self
				selector: #actionGoTo:
				argument: edge model origin)
				icon: (self iconNamed: #up).
			(menu
				add: 'Go to target'
				target: self
				selector: #actionGoTo:
				argument: edge model target)
				icon: (self iconNamed: #down).
			(menu add: 'Inspect' target: edge selector: #inspect)
				icon: (self iconNamed: #smallInspectIt) ];
		yourself
]

{ #category : #'private - highlighting' }
HiRS3ColumnController >> highlightBranchAtLink: aRSEdge [

	| branch linksToHighlight aColor |
	branch := renderer ruler branchAtLink: aRSEdge model.
	linksToHighlight := Array streamContents: [:stream |
		renderer ruler branchByLink keysAndValuesDo: [:key :value | 
		value = branch ifTrue: [ stream nextPut: key ] ] ].
	aColor := (aRSEdge attributes at: #originalColor) mixed: 0.4 with: UITheme current textColor.

	view edges
		select: [:edge | linksToHighlight includes: edge model ]
		thenDo: [:edge |
			edge color: aColor.
			self basicHighlightNode: edge controlPoints first.
			self basicHighlightNode: edge controlPoints last.
			].

]

{ #category : #'private - highlighting' }
HiRS3ColumnController >> highlightBranchesAtNode: aRSElement [

	aRSElement connectedEdges do: [ :each |
		self highlightBranchAtLink: each ].

	aRSElement border width: 3.

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

		view elements do: [ :e |
			e attributes at: #originalColor put: e color.
			e attributes at: #originalBorderColor put: e border color.
			e attributes at: #originalBorderWidth put: e border width.
			e
				when: TSMouseEnter do: [ self highlightBranchesAtNode: e. table changed. ];
				when: TSMouseLeave do: [ self unhighlightAll. table changed. ];
				addInteraction: self nodeMenuInteraction.
			].
		
		view edges do: [ :e |
			e attributes at: #originalColor put: e color.
			e attributes at: #originalBorderColor put: e border color.
			e attributes at: #originalBorderWidth put: e border width.
			e
				when: TSMouseEnter do: [ self highlightBranchAtLink: e. table changed. ];
				when: TSMouseLeave do: [ self unhighlightAll. table changed. ];
				addInteraction: self edgeMenuInteraction.
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
	
	^ copy

]

{ #category : #'private - menu' }
HiRS3ColumnController >> nodeMenuInteraction [
	^ RSMenuActivable new
		menuDo: [ :menu :node |
			node model incomingLinks withIndexDo: [:each :index |
				(menu
					add: ('Go to incoming #{1}' format: { index })
					target: self
					selector: #actionGoTo:
					argument: each origin)
					icon: (self iconNamed: #up)
			].
			node model outgoingLinks withIndexDo: [:each :index |
				(menu
					add: ('Go to outgoing #{1}' format: { index })
					target: self
					selector: #actionGoTo:
					argument: each target)
					icon: (self iconNamed: #down)
			].
			(menu add: 'Inspect' target: node selector: #inspect)
				icon: (self iconNamed: #smallInspectIt).
			];
		yourself
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

{ #category : #'private - highlighting' }
HiRS3ColumnController >> unhighlightAll [

	view edges do: [:each | self basicUnhighlightElement: each ].
	view elements do: [:each | self basicUnhighlightElement: each ].

]
