"
I'm a FastTable data source that demonstrates how to show avatars in the Hiedra ruler of Iceberg repositories view.

Activate with:

	self beCurrentDataSourceClass.
	
And open the Iceberg repository view.

"
Class {
	#name : #IceTipHiRS3AvatarsInHiedraDataSource,
	#superclass : #IceTipHiRS3AvatarsDataSource,
	#category : #'Hiedra-Roassal3-Examples-Iceberg'
}

{ #category : #accessing }
IceTipHiRS3AvatarsInHiedraDataSource >> avatarSize [
	^ 20
]

{ #category : #accessing }
IceTipHiRS3AvatarsInHiedraDataSource >> elements: commits [

	self table ifNotNil: [
		self table rowHeight: 30 ].

	super elements: commits.

]

{ #category : #private }
IceTipHiRS3AvatarsInHiedraDataSource >> initialize [
	super initialize.
	
	hiedraColumnController viewBuilder nodeShapeBuilder
		size: self avatarSize;
		paint: [ :node | self avatarFor: node theValue ].
	
	hiedraColumnController viewBuilder linkShapeBuilder
		cornerRadii: self avatarSize / 2;
		width: 3.

	hiedraColumnController viewBuilder cellWidth: self avatarSize.

]
