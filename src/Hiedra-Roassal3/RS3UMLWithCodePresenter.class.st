Class {
	#name : #RS3UMLWithCodePresenter,
	#superclass : #RS3UMLDiffPresenter,
	#instVars : [
		'diffPresenter'
	],
	#category : #'Hiedra-Roassal3-Examples-Iceberg'
}

{ #category : #specs }
RS3UMLWithCodePresenter class >> defaultSpec [
	^ SpecBoxLayout newHorizontal
		add: #viewPresenter;
		add: #diffPresenter;
		yourself
]

{ #category : #initialization }
RS3UMLWithCodePresenter >> diffPresenter: aPresenter [
	diffPresenter := aPresenter

]

{ #category : #initialization }
RS3UMLWithCodePresenter >> onMouseClickFor: anIceNode [
	| fastTable index |
	fastTable := diffPresenter changeList widget.
	index := fastTable dataSource indexOfElement: anIceNode.
	fastTable selectIndex: index
]

{ #category : #initialization }
RS3UMLWithCodePresenter >> setup: view with: diffModel [
	| classes b s zuper |
	diffModel tree isEmpty ifTrue: [ ^self ].

	classes := OrderedCollection new.

	diffModel tree
		allChildrenDo: [ :node | 
			(node value definition isClassDefinition
				and: [ node value definition isMeta not ])
				ifTrue: [ classes add: node ] ].

	b := RSUMLClassBuilder new.
	b view: view.

	zuper := [ :node | node value definition asMCDefinition superclassName ].
	b classDescriptor
		classname: [ :cls | cls key asString ];
		instVars: [ :cls | #() ];
		methods: [ :cls |cls children ];
		superclass: [ :cls | 
			s := zuper value: cls.
			classes detect: [ :cls2 | s = cls2 key ] ifNone: [ nil ] ];
		methodSelector: [ :met | met key asString ].

	b renderer methodShape 
		when: TSMouseClick do: [ :anIceNode | [ self onMouseClickFor: anIceNode ] ];
		if: [:node | node value isAddition ] actions: [ :z | z color: Color green muchDarker ];
		if: [:node | node value isRemoval ] actions: [ :z | z color: Color red muchDarker ];
		if: [:node | node value isModification ] actions: [ :z | z color: Color blue muchDarker ].
	b renderer classNameShape
		interactionDo: [ :i | i clear; draggable ];
		when: TSMouseClick do: [ :anIceNode | [ self onMouseClickFor: anIceNode ] ];
		if: [:node | node value isAddition ] actions: [ :z | z color: Color green muchDarker ];
		if: [:node | node value isRemoval ] actions: [ :z | z color: Color red muchDarker ];
		if: [:node | node value isModification ] actions: [ :z | z color: Color blue muchDarker ].

	b classes: classes.
	b build.

	view addInteraction: RSControlsView
]
