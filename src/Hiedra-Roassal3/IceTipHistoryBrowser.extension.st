Extension { #name : #IceTipHistoryBrowser }

{ #category : #'*Hiedra-Roassal3' }
IceTipHistoryBrowser >> initializeWidgets [
	super initializeWidgets.	
	commitList := self newIceTable.
	commitInfoTabs := self instantiate: IceTipHiRS3CommitInfoPresenter.
	
	self initializeCommitList.
	
	commitList widget 
		onAnnouncement: FTSelectionChanged 
		send: #selectionChanged:
		to: self.
	
	self focusOrder 
		add: commitList;
		add: commitInfoTabs.
		
	self refresh
]

{ #category : #'*Hiedra-Roassal3' }
IceTipHistoryBrowser class >> panelSpec [
	<spec>
	
	^ SpecPanedLayout newHorizontal
		add: #commitList;
		add: #commitInfoTabs;
		yourself
]
