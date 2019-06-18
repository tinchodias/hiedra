Class {
	#name : #IceTipHiRS3Settings,
	#superclass : #Object,
	#category : #'Hiedra-Roassal3-Examples-Iceberg'
}

{ #category : #settings }
IceTipHiRS3Settings class >> settingsOn: aBuilder [ 
	<systemsettings>
	
	(aBuilder pickOne: #currentDataSourceClass)
		parent: #Iceberg;
		target: IceTipHiRS3DataSource;
		label: 'Commit list data source';
"		description: 'Select your preferred file format.';"
		domainValues: IceTipHiRS3DataSource dataSourceClassOptions.

]
