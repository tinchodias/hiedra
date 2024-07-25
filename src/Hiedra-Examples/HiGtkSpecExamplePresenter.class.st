Class {
	#name : #HiGtkSpecExamplePresenter,
	#superclass : #HiSpecExamplePresenter,
	#category : #'Hiedra-Examples'
}

{ #category : #examples }
HiGtkSpecExamplePresenter class >> openExample: selector [

	| commits app |
	commits := HiExampleCommit perform: selector.

	app := SpApplication new.
	app useBackend: #Gtk.

	(app new: self)
		commits: commits;
		open;
		withWindowDo: [ :window |
			window title:
				('Hiedra in Spec-GTK - {1} - {2} elements'
					format: {selector. commits size}) ]
]

{ #category : #initialization }
HiGtkSpecExamplePresenter >> initializeTable [

	super initializeTable.

	"Gtk: remove cell padding in table"
	table whenBuiltDo: [ :p |
		p widget child styleContext 
			addProvider: (GtkCssProvider newFromString: '* { -GtkTreeView-vertical-separator: 0px }') ]
]

{ #category : #initialization }
HiGtkSpecExamplePresenter >> newHiedraColummnController [

	^ HiGtkColumnController new
]
