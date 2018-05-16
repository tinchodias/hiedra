# Hiedra

It is a small Pharo project to visually connect items in a history-like graph. It uses Athens, and provides support for Morphic and Spec.

## Install it

Note this project is already part of Pharo 6 and 7. However, if you need to install it in some situation, the script to do it is:

```Smalltalk
		Metacello new 
			repository: 'github://tinchodias/hiedra/src';
			baseline: 'Hiedra';
			load.
```

## Example of use

```Smalltalk
Class {
	#name : #HiedraExampleModel,
	#superclass : #ComposableModel,
	#instVars : [
		'treeModel rulerController'
	],
	#category : #HiedraExample
}

{ #category : #initialization }
HiedraExampleModel >> initializePresenter [

	super initializePresenter.

	rulerController := HiRulerController new.

	rulerController treeModel: treeModel.
	treeModel whenRootsChanged: [ 
		rulerController updateFromTree ].

]

```			

