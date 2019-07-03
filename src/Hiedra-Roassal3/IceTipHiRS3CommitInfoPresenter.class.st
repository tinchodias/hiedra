Class {
	#name : #IceTipHiRS3CommitInfoPresenter,
	#superclass : #IceTipCommitInfoPresenter,
	#instVars : [
		'visualDiffToAncestorPage',
		'visualDiffToHeadPage',
		'packageColorScale'
	],
	#category : #'Hiedra-Roassal3-Examples-Iceberg'
}

{ #category : #initialization }
IceTipHiRS3CommitInfoPresenter >> initializeCommitPanel [
	"This will be initialised in fact on the first refresh"

	super initializeCommitPanel.

	packageColorScale := TSScale category20.

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

	notebookPanel
		addPage: (visualDiffToAncestorPage := self newDiffPage 
			title: 'Package diff to HEAD';
			presenterProvider: [ self packageDiffFromHeadPresenter ];
			yourself).


]

{ #category : #initialization }
IceTipHiRS3CommitInfoPresenter >> packageDiffFromHeadPresenter [

	selectedModel ifNil: [ ^ self newEmpty ].
	
	^ (self instantiate: RS3PackageDiffPresenter)
			diffPresenter: self diffFromHead;
			packageColorScale: packageColorScale;
			iceDiffModel: (headTabContainer diffFor: selectedModel);
			yourself

]

{ #category : #initialization }
IceTipHiRS3CommitInfoPresenter >> umlDiffFromAncestorPresenter [

	selectedModel ifNil: [ ^ self newEmpty ].
	
	^ (self instantiate: RS3ClassDiffPresenter)
			diffPresenter: self diffFromAncestor;
			packageColorScale: packageColorScale;
			iceDiffModel: (ancestorTabContainer diffFor: selectedModel);
			yourself

]

{ #category : #initialization }
IceTipHiRS3CommitInfoPresenter >> umlDiffFromHeadPresenter [

	selectedModel ifNil: [ ^ self newEmpty ].
	
	^ (self instantiate: RS3ClassDiffPresenter)
			diffPresenter: self diffFromHead;
			packageColorScale: packageColorScale;
			iceDiffModel: (headTabContainer diffFor: selectedModel);
			yourself

]
