Class {
	#name : #RS3IceDiffEntityCollector,
	#superclass : #IceTreeVisitor,
	#instVars : [
		'nodesWithClasses',
		'nodesWithMethods',
		'nodesWithClassExtensions',
		'nodesWithMetaclasses',
		'nodesWithPackages',
		'nodesWithFiles'
	],
	#category : #'Hiedra-Roassal3-Examples-Iceberg'
}

{ #category : #initialization }
RS3IceDiffEntityCollector >> initialize [
	super initialize.
	
	nodesWithPackages := OrderedCollection new.
	nodesWithClasses := OrderedCollection new.
	nodesWithMetaclasses := OrderedCollection new.
	nodesWithMethods := OrderedCollection new.
	nodesWithClassExtensions := OrderedCollection new.
	nodesWithFiles := OrderedCollection new.
]

{ #category : #accessing }
RS3IceDiffEntityCollector >> nodesWithClassExtensions [
	^ nodesWithClassExtensions
]

{ #category : #accessing }
RS3IceDiffEntityCollector >> nodesWithClasses [
	^ nodesWithClasses
]

{ #category : #accessing }
RS3IceDiffEntityCollector >> nodesWithMetaclasses [
	^ nodesWithMetaclasses
]

{ #category : #accessing }
RS3IceDiffEntityCollector >> nodesWithMethods [
	^ nodesWithMethods
]

{ #category : #accessing }
RS3IceDiffEntityCollector >> nodesWithPackages [
	^ nodesWithPackages
]

{ #category : #visiting }
RS3IceDiffEntityCollector >> visitAddition: anIceAddition [ 
	self visitRemoval: anIceAddition
]

{ #category : #visiting }
RS3IceDiffEntityCollector >> visitClassDefinition: anIceClassDefinition [ 
	anIceClassDefinition isMeta
		ifFalse: [ nodesWithClasses add: currentNode ]
		ifTrue: [ nodesWithMetaclasses add: currentNode ].
	self visitChildrenOf: currentNode.
	
]

{ #category : #visiting }
RS3IceDiffEntityCollector >> visitDirectoryDefinition: anIceDirectoryDefinition [ 
	
	self visitChildrenOf: currentNode
]

{ #category : #visiting }
RS3IceDiffEntityCollector >> visitExtensionDefinition: anIceExtensionDefinition [ 
	nodesWithClassExtensions add: currentNode.
	self visitChildrenOf: currentNode.

]

{ #category : #visiting }
RS3IceDiffEntityCollector >> visitFileNode: anIceFileDefinition [ 
	nodesWithFiles add: currentNode.
	self visitChildrenOf: currentNode.

]

{ #category : #visiting }
RS3IceDiffEntityCollector >> visitMethodNode: anIceMethodDefinition [ 
	nodesWithMethods add: currentNode.
	self visitChildrenOf: currentNode.
	
]

{ #category : #visiting }
RS3IceDiffEntityCollector >> visitModification: anIceModification [ 
	
	^ anIceModification leftDefinition accept: self
]

{ #category : #visiting }
RS3IceDiffEntityCollector >> visitNoModification: anIceNoModification [ 

	anIceNoModification definition accept: self
]

{ #category : #visiting }
RS3IceDiffEntityCollector >> visitPackage: anIcePackageDefinition [ 
	nodesWithPackages add: currentNode.
	self visitChildrenOf: currentNode.
]

{ #category : #visiting }
RS3IceDiffEntityCollector >> visitRemoval: anIceRemoval [ 
	anIceRemoval definition accept: self
]

{ #category : #visiting }
RS3IceDiffEntityCollector >> visitRootDefinition: anIceRootDefinition [ 
	
	self visitChildrenOf: currentNode
]

{ #category : #visiting }
RS3IceDiffEntityCollector >> visitTraitDefinition: anIceTraitDefinition [ 
	self visitClassDefinition: anIceTraitDefinition
]
