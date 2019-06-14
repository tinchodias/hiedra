Extension { #name : #IceTipHiedraHistoryBrowser }

{ #category : #'*Hiedra-Roassal3' }
IceTipHiedraHistoryBrowser >> initializeCommitList [

	"Add the Hiedra column at the beginning. The Datasource has the logic to render it."
	commitList widget addColumn:
		(IceTipTableColumn new
			id: ' ';
			yourself).

	super initializeCommitList.
]

{ #category : #'*Hiedra-Roassal3' }
IceTipHiedraHistoryBrowser >> newCommitsDataSource [
	^ IceTipHiRS3DataSource newCurrentDataSource
		tool: self;
		elements: #(); "It will be set when refreshing"
		yourself
]
