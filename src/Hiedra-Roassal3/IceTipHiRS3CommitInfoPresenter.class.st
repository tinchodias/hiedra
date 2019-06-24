Class {
	#name : #IceTipHiRS3CommitInfoPresenter,
	#superclass : #IceTipCommitInfoPresenter,
	#instVars : [
		'visualDiffToAncestorPage',
		'visualDiffToHeadPage'
	],
	#category : #'Hiedra-Roassal3-Examples-Iceberg'
}

{ #category : #initialization }
IceTipHiRS3CommitInfoPresenter >> initializeCommitPanel [
	"This will be initialised in fact on the first refresh"

	super initializeCommitPanel.

	notebookPanel
		addPage: (visualDiffToHeadPage := self newDiffPage 
			title: 'Visual diff to HEAD';
			presenterProvider: [ self umlDiffFromHeadPresenter ];
			yourself).

	notebookPanel
		addPage: (visualDiffToAncestorPage := self newDiffPage 
			title: 'Visual diff to ancestor';
			presenterProvider: [ self umlDiffFromAncestorPresenter ];
			yourself).

]

{ #category : #initialization }
IceTipHiRS3CommitInfoPresenter >> umlDiffFromAncestorPresenter [

	selectedModel ifNil: [ ^ self newEmpty ].
	
	^ (self instantiate: RS3UMLDiffPresenter)
			diffPresenter: self diffFromAncestor;
			iceDiffModel: (ancestorTabContainer diffFor: selectedModel);
			yourself

]

{ #category : #initialization }
IceTipHiRS3CommitInfoPresenter >> umlDiffFromHeadPresenter [

	selectedModel ifNil: [ ^ self newEmpty ].
	
	^ (self instantiate: RS3UMLDiffPresenter)
			diffPresenter: self diffFromHead;
			iceDiffModel: (headTabContainer diffFor: selectedModel);
			yourself

]
