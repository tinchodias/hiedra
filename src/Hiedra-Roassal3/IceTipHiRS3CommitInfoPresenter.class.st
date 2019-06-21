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
			title: 'UMLdiff from ancestor';
			presenterProvider: [ self umlDiffFromAncestorPresenter ];
			yourself).

	super initializeCommitPanel.

]

{ #category : #initialization }
IceTipHiRS3CommitInfoPresenter >> umlDiffFromAncestorPresenter [

	selectedModel ifNil: [ ^ self newEmpty ].
	
	^ (self instantiate: RS3UMLDiffPresenter)
			diffPresenter: self diffFromAncestor;
			iceDiffModel: (ancestorTabContainer diffFor: selectedModel);
			yourself

]
