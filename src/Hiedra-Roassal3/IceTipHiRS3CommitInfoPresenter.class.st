Class {
	#name : #IceTipHiRS3CommitInfoPresenter,
	#superclass : #IceTipCommitInfoPresenter,
	#instVars : [
		'roassal3Page'
	],
	#category : #'Hiedra-Roassal3-Examples-Iceberg'
}

{ #category : #initialization }
IceTipHiRS3CommitInfoPresenter >> initializeCommitPanel [
	"This will be initialised in fact on the first refresh"

	notebookPanel
		addPage: (roassal3Page := self newDiffPage 
			title: 'Roassal3 diff from ancestor';
			presenterProvider: [ self roassal3DiffFromAncestor ];
			yourself).

	super initializeCommitPanel.

]

{ #category : #initialization }
IceTipHiRS3CommitInfoPresenter >> roassal3DiffFromAncestor [

	selectedModel ifNil: [ ^ self newEmpty ].
	^ self roassal3ViewPresenterFor: (ancestorTabContainer diffFor: selectedModel)
]

{ #category : #initialization }
IceTipHiRS3CommitInfoPresenter >> roassal3ViewPresenterFor: diffModel [

	^ self newButton
]
