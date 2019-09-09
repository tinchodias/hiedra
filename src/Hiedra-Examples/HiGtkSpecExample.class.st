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
HiGtkSpecExample >> initializeHiedra [
	"Configure the Hiedra controller, which adapts the visualization to the table column cells."

	hiedraColumnController := HiGtkColumnController new.

	"GTK table isn't lazy so it's better to reduce pagination."
	hiedraColumnController pageSize: 1500.

	hiedraColumnController renderer
		nodeRadius: 1.5;
		nodeBorderWidth: 3.0;
		arrowSize: 0;
		nodeConnectionOffset: 3;
		cellWidth: 8;
		rowHeight: 20.
]

{ #category : #initialization }
HiGtkSpecExample >> initializeTable [

	table := self newTable
		hideColumnHeaders;
		addColumn: (SpImageTableColumn evaluated: [ :each | hiedraColumnController cellMorphAtValue: each ]);
		addColumn: (SpStringTableColumn evaluated: [ :each | each comment lines ifNotEmpty: #first ]);
		yourself.

	"Gtk: remove cell padding in table"
	table whenBuiltDo: [ :p |
		p widget child styleContext 
			addProvider: (GtkCssProvider newFromString: '* { -GtkTreeView-vertical-separator: 0px }') ]
]

{ #category : #initialization }
HiGtkSpecExample >> initializeWidgets [
	self initializeHiedra.
	self initializeTable.
]
