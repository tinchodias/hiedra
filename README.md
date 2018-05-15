# Hiedra

It is a small Pharo project to visually connect items in a history-like graph. It uses Athens, and provides support for Morphic and Spec.


## Example of use

```
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

