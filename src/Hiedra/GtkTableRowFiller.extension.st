Extension { #name : #GtkTableRowFiller }

{ #category : #'*Hiedra' }
GtkTableRowFiller >> visitImageColumn: aTableColumn [
	| image |
	image := aTableColumn readObject: self row.
	image ifNil: [ ^ self ].
	
	self gtkRow
		at: (self columnIndexOf: aTableColumn) 
		putObject: (self 
			cacheAt: image 
			ifAbsentPut: [ image asGdkPixbuf ])
]
