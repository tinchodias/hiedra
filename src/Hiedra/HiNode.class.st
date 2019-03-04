"
I am a node in a Hiedra ruler.
"
Class {
	#name : #HiNode,
	#superclass : #HiRulerElement,
	#instVars : [
		'value',
		'incomingLinks',
		'outgoingLinks',
		'rulerPoint'
	],
	#category : #'Hiedra-Model'
}

{ #category : #'instance creation' }
HiNode class >> value: aValue rulerPoint: aPoint [
	^ self basicNew
		initializeWithValue: aValue
			rulerPoint: aPoint;
		yourself
]

{ #category : #accessing }
HiNode >> addIncomingLink: aHiLink [ 
	incomingLinks add: aHiLink
]

{ #category : #accessing }
HiNode >> addOutgoingLink: aHiLink [ 
	outgoingLinks add: aHiLink 
]

{ #category : #testing }
HiNode >> hasLinkTo: aHiNode [ 
	
	^ outgoingLinks anySatisfy: [ :each | each target = aHiNode ]
]

{ #category : #accessing }
HiNode >> incomingLinks [
	^ incomingLinks
]

{ #category : #initialization }
HiNode >> initializeWithValue: aValue rulerPoint: aPoint [

	self initialize.
	rulerPoint := aPoint.
	value := aValue.
	outgoingLinks := OrderedCollection new.
	incomingLinks := OrderedCollection new.
]

{ #category : #accessing }
HiNode >> outgoingLinks [
	^ outgoingLinks
]

{ #category : #printing }
HiNode >> printOn: aStream [

	super printOn: aStream.
	
	aStream
		nextPut: $(;
		print: value;
		space;
		print: self rulerPoint;
		nextPut: $).
]

{ #category : #accessing }
HiNode >> rulerPoint [
	^ rulerPoint
]

{ #category : #accessing }
HiNode >> theValue [
	^ value
]
