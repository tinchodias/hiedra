Class {
	#name : #RS3NodesEntityCollector,
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
RS3NodesEntityCollector >> initialize [
	super initialize.
	
	nodesWithPackages := OrderedCollection new.
	nodesWithClasses := OrderedCollection new.
	nodesWithMetaclasses := OrderedCollection new.
	nodesWithMethods := OrderedCollection new.
	nodesWithClassExtensions := OrderedCollection new.
	nodesWithFiles := OrderedCollection new.
]

{ #category : #accessing }
RS3NodesEntityCollector >> nodesWithClassExtensions [
	^ nodesWithClassExtensions
]

{ #category : #accessing }
RS3NodesEntityCollector >> nodesWithClasses [
	^ nodesWithClasses
]

{ #category : #accessing }
RS3NodesEntityCollector >> nodesWithMetaclasses [
	^ nodesWithMetaclasses
]

{ #category : #accessing }
RS3NodesEntityCollector >> nodesWithMethods [
	^ nodesWithMethods
]

{ #category : #accessing }
RS3NodesEntityCollector >> nodesWithPackages [
	^ nodesWithPackages
]

{ #category : #visiting }
RS3NodesEntityCollector >> visitAddition: anIceAddition [ 
	self visitRemoval: anIceAddition
]

{ #category : #visiting }
RS3NodesEntityCollector >> visitClassDefinition: anIceClassDefinition [ 
	anIceClassDefinition isMeta
		ifFalse: [ nodesWithClasses add: currentNode ]
		ifTrue: [ nodesWithMetaclasses add: currentNode ].
	self visitChildrenOf: currentNode.
	
]

{ #category : #visiting }
RS3NodesEntityCollector >> visitDirectoryDefinition: anIceDirectoryDefinition [ 
	
	self visitChildrenOf: currentNode
]

{ #category : #visiting }
RS3NodesEntityCollector >> visitExtensionDefinition: anIceExtensionDefinition [ 
	nodesWithClassExtensions add: currentNode.
	self visitChildrenOf: currentNode.

]

{ #category : #visiting }
RS3NodesEntityCollector >> visitFileNode: anIceFileDefinition [ 
	nodesWithFiles add: currentNode.
	self visitChildrenOf: currentNode.

]

{ #category : #visiting }
RS3NodesEntityCollector >> visitMethodNode: anIceMethodDefinition [ 
	nodesWithMethods add: currentNode.
	self visitChildrenOf: currentNode.
	
]

{ #category : #visiting }
RS3NodesEntityCollector >> visitModification: anIceModification [ 
	
	^ anIceModification leftDefinition accept: self
]

{ #category : #visiting }
RS3NodesEntityCollector >> visitNoModification: anIceNoModification [ 

	anIceNoModification definition accept: self
]

{ #category : #visiting }
RS3NodesEntityCollector >> visitPackage: anIcePackageDefinition [ 
	nodesWithPackages add: currentNode.
	self visitChildrenOf: currentNode.
]

{ #category : #visiting }
RS3NodesEntityCollector >> visitRemoval: anIceRemoval [ 
	anIceRemoval definition accept: self
]

{ #category : #visiting }
RS3NodesEntityCollector >> visitRootDefinition: anIceRootDefinition [ 
	
	self visitChildrenOf: currentNode
]

{ #category : #visiting }
RS3NodesEntityCollector >> visitTraitDefinition: anIceTraitDefinition [ 
	self visitClassDefinition: anIceTraitDefinition
]
