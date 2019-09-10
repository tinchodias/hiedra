Class {
	#name : #HiGtkSpecExample,
	#superclass : #HiSpecExample,
	#category : #'Hiedra-Examples'
}

{ #category : #specs }
HiGtkSpecExample class >> openExample: selector [

	| commits app |
	commits := HiExampleCommit perform: selector.
	
	app := SpApplication new.
	app useBackend: #Gtk.
	
	(app new: self)
		commits: commits;
		openWithSpec;
		withWindowDo: [ :window |
			window title: ('Hiedra in Spec2 with Roassal3 - {1} - {2} elements' format: {selector. commits size}) ].

]

{ #category : #initialization }
HiGtkSpecExample >> initializeTable [
	super initializeTable.

	"Gtk: remove cell padding in table"
	table whenBuiltDo: [ :p |
		p widget child styleContext 
			addProvider: (GtkCssProvider newFromString: '* { -GtkTreeView-vertical-separator: 0px }') ]
]

{ #category : #initialization }
HiGtkSpecExample >> newHiedraColummnController [
	^ HiGtkColumnController new
]
