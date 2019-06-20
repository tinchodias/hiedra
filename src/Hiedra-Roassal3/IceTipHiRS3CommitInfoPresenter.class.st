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
			title: 'UML diff from ancestor';
			presenterProvider: [ self roassal3DiffFromAncestor ];
			yourself).
	notebookPanel
		addPage: (roassal3Page := self newDiffPage 
			title: 'UML diff 2 from ancestor';
			presenterProvider: [ self roassal3Diff2FromAncestor ];
			yourself).

	super initializeCommitPanel.

]

{ #category : #initialization }
IceTipHiRS3CommitInfoPresenter >> roassal3Diff2FromAncestor [

	selectedModel ifNil: [ ^ self newEmpty ].
	
	^ (self instantiate: RS3UMLWithCodePresenter)
			diffPresenter: self diffFromAncestor;
			diffModel: (ancestorTabContainer diffFor: selectedModel);
			yourself

]

{ #category : #initialization }
IceTipHiRS3CommitInfoPresenter >> roassal3DiffFromAncestor [

	selectedModel ifNil: [ ^ self newEmpty ].

	^ (self instantiate: RS3UMLDiffPresenter)
			diffModel: (ancestorTabContainer diffFor: selectedModel);
			yourself

]
