Class {
	#name : #BaselineOfHiedra,
	#superclass : #BaselineOf,
	#category : 'BaselineOfHiedra'
}

{ #category : #baseline }
BaselineOfHiedra >> baseline: spec [
	<baseline>
	spec
		for: #pharo
		do: [ 
		    spec 
                package: 'Hiedra';
                package: 'HiedraTests' with: [ spec requires: #(Hiedra) ].

            spec 
                group: 'core' with: #(Hiedra);
                group: 'core+tests' with: #(HiedraTests);
				group: 'default' with: #('core+tests').
		]
]
