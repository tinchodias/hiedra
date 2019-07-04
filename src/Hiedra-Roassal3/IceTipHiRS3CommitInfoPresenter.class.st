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
		addPage: (self newDiffPage 
			title: 'Classes';
			presenterProvider: [ self umlDiffFromHeadPresenter ];
			yourself).

	notebookPanel
		addPage: (self newDiffPage 
			title: 'Packages';
			presenterProvider: [ self packageDiffFromHeadPresenter ];
			yourself).

	notebookPanel
		addPage: (self newDiffPage 
			title: 'Multi (Floating)';
			presenterProvider: [ self multigranularFloatingLabelsDiffFromHeadPresenter ];
			yourself).

	notebookPanel
		addPage: (self newDiffPage 
			title: 'Multi (Top)';
			presenterProvider: [ self multigranularTopLabelDiffFromHeadPresenter ];
			yourself).

]

{ #category : #initialization }
IceTipHiRS3CommitInfoPresenter >> labelShapeBuilder [
	^ HiMUMLDiffUtils new shapeForClassOrTrait
		scaleBy: 0.2;
		yourself
]

{ #category : #initialization }
IceTipHiRS3CommitInfoPresenter >> multigranularFloatingLabelsDiffFromHeadPresenter [

	selectedModel ifNil: [ ^ self newEmpty ].
	
	^ (self instantiate: RS3MultigranularDiffPresenter)
			labelStrategy: (HiMFloatingLabelStrategy new shapeBuilder: self labelShapeBuilder; yourself);
			diffPresenter: self diffFromHead;
			packageColorScale: packageColorScale;
			iceDiffModel: (headTabContainer diffFor: selectedModel);
			yourself

]

{ #category : #initialization }
IceTipHiRS3CommitInfoPresenter >> multigranularTopLabelDiffFromHeadPresenter [

	selectedModel ifNil: [ ^ self newEmpty ].
	
	^ (self instantiate: RS3MultigranularDiffPresenter)
			labelStrategy: (HiMTopLabelStrategy new shapeBuilder: self labelShapeBuilder; yourself);
			diffPresenter: self diffFromHead;
			packageColorScale: packageColorScale;
			iceDiffModel: (headTabContainer diffFor: selectedModel);
			yourself

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
