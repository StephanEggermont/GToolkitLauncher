Class {
	#name : 'GLGProject',
	#superclass : 'Object',
	#instVars : [
		'path',
		'model',
		'script',
		'title'
	],
	#category : 'GToolkitLauncher',
	#package : 'GToolkitLauncher'
}

{ #category : 'as yet unclassified' }
GLGProject class >> onPath: path in: aModel [ 
	^self new
		path: path;
		model: aModel;
		yourself
]

{ #category : 'accessing' }
GLGProject >> model [
	^ model
]

{ #category : 'accessing' }
GLGProject >> model: anObject [
	model := anObject
]

{ #category : 'accessing' }
GLGProject >> path [
	^ path
]

{ #category : 'accessing' }
GLGProject >> path: anObject [
	path := anObject
]

{ #category : 'accessing' }
GLGProject >> script [
	^ script
]

{ #category : 'accessing' }
GLGProject >> script: anObject [
	script := anObject
]

{ #category : 'as yet unclassified' }
GLGProject >> showFolder [
	path inspect
]

{ #category : 'accessing' }
GLGProject >> title [
	^ title
]

{ #category : 'accessing' }
GLGProject >> title: anObject [
	title := anObject
]
