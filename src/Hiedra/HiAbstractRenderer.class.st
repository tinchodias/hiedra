"
I know how to render a Hiedra visualization (ruler) on an Athens canvas.

"
Class {
	#name : #HiAbstractRenderer,
	#superclass : #Object,
	#instVars : [
		'ruler',
		'rowsInterval'
	],
	#category : #'Hiedra-UI'
}

{ #category : #accessing }
HiAbstractRenderer >> columnWidth [
	^ self subclassResponsibility
]

{ #category : #API }
HiAbstractRenderer >> formHeight [
	"Answer the height in pixels for the form to be rendered."

	^ rowsInterval size * self rowHeight
]

{ #category : #API }
HiAbstractRenderer >> formWidth [
	"Answer the width in pixels for the form to be rendered."

	"Note: The reason of numberOfColumns + 2 is the left and right margin."
	^ (ruler numberOfColumns + 2) * self columnWidth
]

{ #category : #rendering }
HiAbstractRenderer >> initialTranslationInAthensCanvas [
	"Apply left margin + rowsInterval offset."

	^ self columnWidth @ (-1 * (rowsInterval first - 1) * self rowHeight)
]

{ #category : #API }
HiAbstractRenderer >> newForm [
	"Answer a new form, rendered with the current ruler and rowInterval."
	
	| athensSurface |
	athensSurface := AthensCairoSurface extent: self formWidth @ self formHeight.
	
	athensSurface drawDuring: [ :athensCanvas |
		athensCanvas pathTransform translateBy: self initialTranslationInAthensCanvas.

		self renderOn: athensCanvas ].

	^ athensSurface asForm
]

{ #category : #rendering }
HiAbstractRenderer >> nodesAndLinks [
	
	| links nodes |
	nodes := Set new.
	links := Set new.

	"Add all nodes and links that occupy space in the ruler."
	rowsInterval do: [:row | 
		(ruler elementsByRow at: row) do: [:element |
			(element isKindOf: HiNode) 
				ifTrue: [ nodes add: element ]
				ifFalse: [ links add: element ] ]].

	"Also add links between contiguous nodes 
	(they are not added in previous step as they don't occupy a space in the ruler)."
	nodes do: [:aNode |
		links 
			addAll: aNode incomingLinks;
			addAll: aNode outgoingLinks ].

	^ { nodes. links }
]

{ #category : #rendering }
HiAbstractRenderer >> renderLinks: links on: athensCanvas [ 

	self subclassResponsibility
]

{ #category : #rendering }
HiAbstractRenderer >> renderNodes: nodes on: athensCanvas [

	self subclassResponsibility
]

{ #category : #rendering }
HiAbstractRenderer >> renderOn: athensCanvas [
	"Render all relevant Hiedra ruler elements in the athensCanvas"
	
	| nodesAndLinks |
	nodesAndLinks := self nodesAndLinks.
	self renderLinks: nodesAndLinks second on: athensCanvas.
	self renderNodes: nodesAndLinks first on: athensCanvas.
]

{ #category : #accessing }
HiAbstractRenderer >> rowHeight [
	^ self subclassResponsibility
]

{ #category : #accessing }
HiAbstractRenderer >> rowsInterval [
	^ rowsInterval
]

{ #category : #accessing }
HiAbstractRenderer >> rowsInterval: anObject [
	rowsInterval := anObject
]

{ #category : #accessing }
HiAbstractRenderer >> ruler [
	^ ruler
]

{ #category : #accessing }
HiAbstractRenderer >> ruler: anObject [
	ruler := anObject
]
