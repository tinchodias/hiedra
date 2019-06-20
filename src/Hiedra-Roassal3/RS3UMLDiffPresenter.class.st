Class {
	#name : #RS3UMLDiffPresenter,
	#superclass : #ComposablePresenter,
	#instVars : [
		'viewPresenter'
	],
	#category : #'Hiedra-Roassal3-Examples-Iceberg'
}

{ #category : #specs }
RS3UMLDiffPresenter class >> defaultSpec [
	^ SpecBoxLayout newVertical
		add: #viewPresenter;
		yourself
]

{ #category : #initialization }
RS3UMLDiffPresenter >> diffModel: anIceDiffModel [

	viewPresenter script: [ :view | self setup: view with: anIceDiffModel ].
]

{ #category : #initialization }
RS3UMLDiffPresenter >> initializeWidgets [
	viewPresenter := self instantiate: RoassalPresenter
]

{ #category : #initialization }
RS3UMLDiffPresenter >> setup: view with: diffModel [
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
		if: [:node | node value isAddition ] actions: [ :z | z color: Color green muchDarker ];
		if: [:node | node value isRemoval ] actions: [ :z | z color: Color red muchDarker ];
		if: [:node | node value isModification ] actions: [ :z | z color: Color blue muchDarker ].
	b renderer classNameShape
		if: [:node | node value isAddition ] actions: [ :z | z color: Color green muchDarker ];
		if: [:node | node value isRemoval ] actions: [ :z | z color: Color red muchDarker ];
		if: [:node | node value isModification ] actions: [ :z | z color: Color blue muchDarker ].

	b classes: classes.
	b build.

	view addInteraction: RSControlsView
]
