Class {
	#name : #GLGProject,
	#superclass : #Object,
	#instVars : [
		'path',
		'model',
		'script',
		'title'
	],
	#category : #GToolkitLauncher
}

{ #category : #'as yet unclassified' }
GLGProject class >> onPath: path in: aModel [ 
	^self new
		path: path;
		model: aModel;
		title: path basename;
		yourself
]

{ #category : #'as yet unclassified' }
GLGProject >> editScript [ 
	self scriptPath asFileReference inspect

]

{ #category : #accessing }
GLGProject >> model [
	^ model
]

{ #category : #accessing }
GLGProject >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GLGProject >> path [
	^ path
]

{ #category : #accessing }
GLGProject >> path: anObject [
	path := anObject
]

{ #category : #'as yet unclassified' }
GLGProject >> run [
]

{ #category : #accessing }
GLGProject >> script [
	^ script ifNil: [
		script := self scriptPath asFileReference exists
			ifTrue: [ self scriptPath asFileReference contents ]
			ifFalse: [ '' ] ]

]

{ #category : #accessing }
GLGProject >> script: anObject [
	script := anObject.
	self scriptPath asFileReference writeStreamDo: [:s | s nextPutAll: anObject]

]

{ #category : #'as yet unclassified' }
GLGProject >> scriptPath [
	^ path / 'load.st'

]

{ #category : #'as yet unclassified' }
GLGProject >> showFolder [
	path inspect
]

{ #category : #'as yet unclassified' }
GLGProject >> stop [
]

{ #category : #accessing }
GLGProject >> title [
	^ title
]

{ #category : #accessing }
GLGProject >> title: anObject [
	title := anObject
]
