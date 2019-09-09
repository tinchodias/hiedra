Extension { #name : #Form }

{ #category : #'*Hiedra' }
Form >> asGdkPixbuf [
	^ GdkPixbuf newForm: self
]
