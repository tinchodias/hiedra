"
I render a Hiedra visualization (HiRuler) using Roassal3. 
"
Class {
	#name : #HiRS3ViewBuilder,
	#superclass : #Object,
	#instVars : [
		'rowHeight',
		'cellWidth',
		'ruler',
		'changeBlockClosure',
		'actionGoToBlockClosure',
		'linkShapeBuilder',
		'nodeShapeBuilder'
	],
	#category : #'Hiedra-Roassal3-UI'
}

{ #category : #'private - menu' }
HiRS3ViewBuilder >> addGoToChildSubMenuIn: menu node: node [

	| groupMenu |
	groupMenu := MenuMorph new.
	node model incomingLinks reverseDo: [:each |
		(groupMenu
			add: ('{1} above' format: { node model rulerPoint y - each origin rulerPoint y })
			target: self
			selector: #basicGoTo:
			argument: each origin)
			icon: (self iconNamed: #up)
 	].
	menu
		add: 'Go to child'
		icon: (self iconNamed: #up)
		subMenu: groupMenu.

]

{ #category : #'private - menu' }
HiRS3ViewBuilder >> addGoToParentSubmenuIn: menu node: node [

	| groupMenu |
	groupMenu := MenuMorph new.
	node model outgoingLinks reverseDo: [:each |
		(groupMenu
			add: ('{1} below' format: { each target rulerPoint y - node model rulerPoint y })
			target: self
			selector: #basicGoTo:
			argument: each target)
			icon: (self iconNamed: #down)
	].
	menu
		add: 'Go to parent'
		icon: (self iconNamed: #down)
		subMenu: groupMenu.

]

{ #category : #'private - menu' }
HiRS3ViewBuilder >> basicGoTo: aHiNode [
	actionGoToBlockClosure value: aHiNode
]

{ #category : #'private - highlighting' }
HiRS3ViewBuilder >> basicHighlightNode: aRSElement [
"	aRSElement color:
		((aRSElement attributes at: #originalColor)
				mixed: 0.8
				with: UITheme current textColor).
"	aRSElement border color: UITheme current textColor
]

{ #category : #'private - highlighting' }
HiRS3ViewBuilder >> basicUnhighlightElement: aRSElement [
	aRSElement color: (aRSElement attributes at: #originalColor).
	aRSElement border
		color: (aRSElement attributes at: #originalBorderColor);
		width: (aRSElement attributes at: #originalBorderWidth).
]

{ #category : #accessing }
HiRS3ViewBuilder >> cellWidth: anObject [
	cellWidth := anObject
]

{ #category : #'private - menu' }
HiRS3ViewBuilder >> edgeMenuInteraction [
	^ RSMenuActivable new
		menuDo: [ :menu :edge | 
			(menu
				add: 'Go to child'
				target: self
				selector: #basicGoTo:
				argument: edge model origin)
				icon: (self iconNamed: #up).
			(menu
				add: 'Go to parent'
				target: self
				selector: #basicGoTo:
				argument: edge model target)
				icon: (self iconNamed: #down).
			(menu add: 'Inspect' target: edge selector: #inspect)
				icon: (self iconNamed: #smallInspectIt)
			];
		yourself
]

{ #category : #'private - highlighting' }
HiRS3ViewBuilder >> highlightBranchAtLink: aRSEdge in: view [

	| branch linksToHighlight aColor |
	branch := ruler branchAtLink: aRSEdge model.
	linksToHighlight := Array streamContents: [:stream |
		ruler branchByLink keysAndValuesDo: [:key :value | 
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
HiRS3ViewBuilder >> highlightBranchesAtNode: aRSElement in: view [

	aRSElement connectedEdges do: [ :each |
		self highlightBranchAtLink: each in: view ].

	aRSElement border width: 1.5.

]

{ #category : #initialization }
HiRS3ViewBuilder >> initialize [
	super initialize.
	
	cellWidth := 9.
	nodeShapeBuilder := RSShapeBuilder circle
		color: Smalltalk ui theme backgroundColor;
		size: 7;
		yourself.
	linkShapeBuilder := RSSingleEdgeBuilder polyline
		cornerRadii: 7;
		width: 2.5;
		joinRound.

]

{ #category : #accessing }
HiRS3ViewBuilder >> linkShapeBuilder [
	^ linkShapeBuilder
]

{ #category : #accessing }
HiRS3ViewBuilder >> linkShapeBuilder: anObject [
	linkShapeBuilder := anObject
]

{ #category : #API }
HiRS3ViewBuilder >> newView [
	| view rulerPointExtent branchScale rectangle |
	view := RSView new.

	rulerPointExtent := cellWidth @ rowHeight.
	branchScale := TSScale google20.

	nodeShapeBuilder
		position: [ :node | node rulerPoint * rulerPointExtent ];
		border: [ :node |
			TSBorder new
				color: 
					(branchScale scale: (ruler branchAtNode: node ifAbsent: [ node hash ]));
				yourself ].
	view addAll: (nodeShapeBuilder elementsOn: ruler nodes).
	
	linkShapeBuilder
		color: [ :link | branchScale scale: (ruler branchAtLink: link) ];
		controlPoints: [ :link |
			OrderedCollection new
				add: (view elementFromModel: link origin);
				addAll: link intermediatePoints * rulerPointExtent;
				add: (view elementFromModel: link target);
				yourself ].
	ruler nodes do:[:node| | edges |
		edges := linkShapeBuilder edgesOn: node incomingLinks.
		view addAll: edges ].
	view edges pushBack.

	view color: Color transparent.

	rectangle := 0 @ rowHeight rectangle: self rulerExtent.

	view createMorph.
	view camera 
		translateTo: rectangle rsCenter;
		scale: 1.
	view morph extent:  self rulerWidth @ rowHeight.

	view elements do: [ :e |
		e attributes at: #originalColor put: e color.
		e attributes at: #originalBorderColor put: e border color.
		e attributes at: #originalBorderWidth put: e border width.
		e
			when: TSMouseEnter do: [ self highlightBranchesAtNode: e in: view. self signalChange. ];
			when: TSMouseLeave do: [ self unhighlightAllIn: view. self signalChange. ];
			addInteraction: self nodeMenuInteraction.
		].
	
	view edges do: [ :e |
		e attributes at: #originalColor put: e color.
		e attributes at: #originalBorderColor put: e border color.
		e attributes at: #originalBorderWidth put: e border width.
		e
			when: TSMouseEnter do: [ self highlightBranchAtLink: e in: view. self signalChange. ];
			when: TSMouseLeave do: [ self unhighlightAllIn: view. self signalChange. ];
			addInteraction: self edgeMenuInteraction.
		 ].

	^ view
]

{ #category : #'private - menu' }
HiRS3ViewBuilder >> nodeMenuInteraction [
	^ RSMenuActivable new
		menuDo: [ :menu :node |
			self addGoToChildSubMenuIn: menu node: node.
			self addGoToParentSubmenuIn: menu node: node.

			(menu add: 'Inspect' target: node selector: #inspect)
				icon: (self iconNamed: #smallInspectIt).
			];
		yourself
]

{ #category : #accessing }
HiRS3ViewBuilder >> nodeShapeBuilder [
	^ nodeShapeBuilder
]

{ #category : #accessing }
HiRS3ViewBuilder >> nodeShapeBuilder: anObject [
	nodeShapeBuilder := anObject
]

{ #category : #accessing }
HiRS3ViewBuilder >> onChangeDo: aBlockClosure [
	"Establishes what to do when there is something new in the view."

	changeBlockClosure := aBlockClosure
]

{ #category : #accessing }
HiRS3ViewBuilder >> onGoToDo: aBlockClosure [
	"Establishes what to do when user selects go to in the contextual menu. The block will receive an HiNode as argument."

	actionGoToBlockClosure := aBlockClosure
]

{ #category : #accessing }
HiRS3ViewBuilder >> rowHeight [
	^ rowHeight
]

{ #category : #accessing }
HiRS3ViewBuilder >> rowHeight: anInteger [
	rowHeight := anInteger
]

{ #category : #accessing }
HiRS3ViewBuilder >> ruler [
	^ ruler
]

{ #category : #accessing }
HiRS3ViewBuilder >> ruler: anObject [
	ruler := anObject
]

{ #category : #accessing }
HiRS3ViewBuilder >> rulerExtent [
	"Answer the pixel extent for the view to be rendered (as a Point)."

	^ self rulerWidth @ self rulerHeight
]

{ #category : #accessing }
HiRS3ViewBuilder >> rulerHeight [
	"Answer the height in pixels for the form to be rendered."
	
	^ ruler numberOfRows * self rowHeight
]

{ #category : #accessing }
HiRS3ViewBuilder >> rulerWidth [
	"Answer the width in pixels for the form to be rendered."

	"Note: The reason of numberOfColumns + 2 is the left and right margin."
	^ (ruler numberOfColumns + 2) * cellWidth
]

{ #category : #private }
HiRS3ViewBuilder >> signalChange [
	changeBlockClosure value
]

{ #category : #'private - highlighting' }
HiRS3ViewBuilder >> unhighlightAllIn: view [

	view edges do: [:each | self basicUnhighlightElement: each ].
	view elements do: [:each | self basicUnhighlightElement: each ].

]
