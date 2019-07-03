Class {
	#name : #RS3DiffPresenter,
	#superclass : #ComposablePresenter,
	#instVars : [
		'diffPresenter',
		'viewPresenter',
		'iceDiffModel',
		'packageColorScale'
	],
	#category : #'Hiedra-Roassal3-Examples-Iceberg'
}

{ #category : #specs }
RS3DiffPresenter class >> defaultSpec [
	^ SpecBoxLayout newVertical
		add: #viewPresenter;
		spacing: 5;
		add: #diffPresenter;
		yourself
]

{ #category : #private }
RS3DiffPresenter >> buildDiffOn: view [
	self subclassResponsibility
]

{ #category : #accessing }
RS3DiffPresenter >> diffPresenter: aPresenter [
	diffPresenter := aPresenter

]

{ #category : #accessing }
RS3DiffPresenter >> iceDiffModel: anIceDiffModel [

	iceDiffModel := anIceDiffModel.
	viewPresenter refresh.
]

{ #category : #initialization }
RS3DiffPresenter >> initializeWidgets [
	viewPresenter := self instantiate: RoassalPresenter.
	viewPresenter script: [ :view | self buildDiffOn: view ].
]

{ #category : #private }
RS3DiffPresenter >> packageColorScale [
	^ packageColorScale ifNil: [ packageColorScale := TSScale category10 ]
]

{ #category : #private }
RS3DiffPresenter >> packageColorScale: aScale [
	packageColorScale := aScale
]
