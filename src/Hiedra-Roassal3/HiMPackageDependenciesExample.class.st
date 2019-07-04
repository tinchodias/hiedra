Class {
	#name : #HiMPackageDependenciesExample,
	#superclass : #Object,
	#instVars : [
		'packageNames',
		'relationGraph',
		'nodeByDAPackage',
		'nodeByBehavior'
	],
	#category : #'Hiedra-Roassal3-Examples-MultigranularNavigator'
}

{ #category : #accessing }
HiMPackageDependenciesExample >> build [
	relationGraph := DAPackageRelationGraph onPackagesNamed: packageNames.
	relationGraph build.

	relationGraph packages do: [:aDAPackage |
		self ensureAddNodeForPackage: aDAPackage.

"		(relationGraph classesFor: aDAPackage) do: [ :aClass |
			aClass isMeta ifFalse: [
				self ensureAddNodeForClassNamed: aClass name in: aDAPackage] ].

		(relationGraph methodsFor: aDAPackage) do: [ :aMethod | 
			self ensureAddNodeForMethod: aMethod in: aDAPackage ].
"
		aDAPackage dependencies do: [:each | each accept: self ] ]

]

{ #category : #private }
HiMPackageDependenciesExample >> ensureAddNodeForClassNamed: aString in: aPackage [
	self assert: [ (aString endsWith: ' class') not ].

	^ nodeByBehavior
		at: aString
		ifAbsentPut: [ | node |
			node := HiMNode for: aString.
			(self ensureAddNodeForPackage: aPackage) addChild: node.
			node ]
]

{ #category : #private }
HiMPackageDependenciesExample >> ensureAddNodeForMethod: aRGMethodDefinition in: aDAPackage [
	| classNode className |
	className := aRGMethodDefinition className.
	aRGMethodDefinition classIsMeta ifTrue: [ className := className allButLast: ' class' size ].
	
	classNode := self
		ensureAddNodeForClassNamed: className
		in: aDAPackage.

	^ classNode children
		detect: [ :each | each object = aRGMethodDefinition selector ]
		ifNone: [ | node |
			node := HiMNode for: aRGMethodDefinition selector.
			classNode addChild: node.
			node ]
]

{ #category : #private }
HiMPackageDependenciesExample >> ensureAddNodeForPackage: aDAPackage [
	^ nodeByDAPackage
		at: aDAPackage
		ifAbsentPut: [ HiMNode for: aDAPackage packageName ]
]

{ #category : #accessing }
HiMPackageDependenciesExample >> initialNodes [
	^ nodeByDAPackage values
]

{ #category : #accessing }
HiMPackageDependenciesExample >> initialize [
	super initialize.
	
	nodeByDAPackage := Dictionary new.
	nodeByBehavior := Dictionary new.
]

{ #category : #accessing }
HiMPackageDependenciesExample >> packageNames [
	^ packageNames
]

{ #category : #accessing }
HiMPackageDependenciesExample >> packageNames: anObject [
	packageNames := anObject
]

{ #category : #visiting }
HiMPackageDependenciesExample >> visitDACompositeDependency: aDACompositeDependency [
	aDACompositeDependency dependencies do: [ :each | each accept: self ]
]

{ #category : #visiting }
HiMPackageDependenciesExample >> visitDAExtensionDependency: aDAExtensionDependency [ 

	| from to |
	from := self ensureAddNodeForMethod: aDAExtensionDependency method in: aDAExtensionDependency source.
	to := self ensureAddNodeForClassNamed: aDAExtensionDependency theClass instanceSide name in: aDAExtensionDependency target.
	from addOutgoingLinkTo: to.
]

{ #category : #visiting }
HiMPackageDependenciesExample >> visitDAInheritanceDependency: aDAInheritanceDependency [
	
	| from to |
	from := self ensureAddNodeForClassNamed: aDAInheritanceDependency theClass name in: aDAInheritanceDependency source.
	to := self ensureAddNodeForClassNamed: aDAInheritanceDependency superclass name in: aDAInheritanceDependency target.
	from addOutgoingLinkTo: to.
]

{ #category : #visiting }
HiMPackageDependenciesExample >> visitDAMessageSendDependency: aDAMessageSendDependency [

	| from to |
	from := self ensureAddNodeForPackage: aDAMessageSendDependency source.
	to := self ensureAddNodeForPackage: aDAMessageSendDependency target.
	
	from addOutgoingLinkTo: to.
	
	self flag: #todo. "Not true!"
	"from withAllChildrenDo: [:node |
		node addOutgoingLinkTo: to ]."
]

{ #category : #visiting }
HiMPackageDependenciesExample >> visitDAReferenceDependency: aDAReferenceDependency [ 

	| from to |
	from := self ensureAddNodeForMethod: aDAReferenceDependency method in: aDAReferenceDependency source.
	to := self ensureAddNodeForClassNamed: aDAReferenceDependency reference instanceSide name in: aDAReferenceDependency target.
	from addOutgoingLinkTo: to.
]