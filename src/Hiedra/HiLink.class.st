"
I am a link in a Hiedra ruler.
"
Class {
	#name : #HiLink,
	#superclass : #HiRulerElement,
	#instVars : [
		'origin',
		'target',
		'intermediatePoints'
	],
	#category : #'Hiedra-Model'
}

{ #category : #'instance creation' }
HiLink class >> origin: aNode target: anotherNode intermediatePoints: aListOfPoints [

	^ self basicNew
		initializeWithOrigin: aNode target: anotherNode intermediatePoints: aListOfPoints;
		yourself
]

{ #category : #testing }
HiLink >> doesContinue: anotherLink [
	^ anotherLink target = origin
]

{ #category : #initialization }
HiLink >> initializeWithOrigin: aNode target: anotherNode intermediatePoints: aCollectionOfPoints [

	self initialize.
	
	origin := aNode.
	target := anotherNode.
	intermediatePoints := aCollectionOfPoints.
]

{ #category : #accessing }
HiLink >> intermediatePoints [
	^ intermediatePoints
]

{ #category : #testing }
HiLink >> isDescending [
	^ origin rulerPoint y < target rulerPoint y
]

{ #category : #accessing }
HiLink >> origin [
	^ origin
]

{ #category : #printing }
HiLink >> printOn: aStream [

	super printOn: aStream.
	
	aStream
		nextPut: $(;
		print: origin theValue;
		nextPutAll: '->';
		print: target theValue;
		nextPut: $).
]

{ #category : #accessing }
HiLink >> target [
	^ target
]
