"
I'm a FastTable data source that demonstrates how to show avatars in the author column of Iceberg repositories view.

Activate with:

	self beCurrentDataSourceClass.
	
And open the Iceberg repository view.
"
Class {
	#name : #IceTipHiRS3AvatarsInColumnDataSource,
	#superclass : #IceTipHiRS3AvatarsDataSource,
	#category : #'Hiedra-Roassal3-Examples-Iceberg'
}

{ #category : #accessing }
IceTipHiRS3AvatarsInColumnDataSource >> avatarSize [
	^ 16
]

{ #category : #accessing }
IceTipHiRS3AvatarsInColumnDataSource >> cellColumn: column row: rowIndex [
	"Answer a morph with the cell view. I will probably return a FTCellMorph."
	
	| cell |	
	cell := super cellColumn: column row: rowIndex.
	
	column id = 'Author' ifTrue: [
		cell addMorphFront: (self avatarFor: (self elementAt: rowIndex) id) asMorph
	].

	
	^ cell
]
