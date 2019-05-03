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
			spec baseline: 'Roassal3' with: [
				spec repository: 'github://ObjectProfile/Roassal3/src' ].
			spec
				package: 'Hiedra';
				package: 'Hiedra-Roassal3' with: [ spec requires: #(Hiedra Roassal3) ];
				package: 'Hiedra-Tests' with: [ spec requires: #(Hiedra) ].
			spec
				group: 'core' with: #(Hiedra);
				group: 'core+tests' with: #('Hiedra-Tests');
				group: 'all' with: #('Hiedra-Roassal3' 'Hiedra-Tests');
				group: 'default' with: #(all) ]
]
