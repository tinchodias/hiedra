Class {
	#name : #BaselineOfHiedra,
	#superclass : #BaselineOf,
	#category : #BaselineOfHiedra
}

{ #category : #baseline }
BaselineOfHiedra >> baseline: spec [
	<baseline>
	spec
		for: #pharo
		do: [
			spec
				package: 'Hiedra';
				package: 'Hiedra-Examples' with: [ spec requires: #('Hiedra') ];
				package: 'Hiedra-Tests' with: [ spec requires: #('Hiedra-Examples') ].
			spec
				group: 'core' with: #(Hiedra);
				group: 'core+examples+tests' with: #('Hiedra-Tests');
				group: 'default' with: #('core+examples+tests') ]
]
