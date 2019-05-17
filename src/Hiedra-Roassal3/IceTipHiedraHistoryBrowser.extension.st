Extension { #name : #IceTipHiedraHistoryBrowser }

{ #category : #'*Hiedra-Roassal3' }
IceTipHiedraHistoryBrowser >> newCommitsDataSource [
	^ IceTipHiRS3DataSource new 
		tool: self;
		elements: #(); "It will be set when refreshing"
		yourself
]
