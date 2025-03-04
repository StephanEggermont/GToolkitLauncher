Class {
	#name : #GLGRelease,
	#superclass : #Object,
	#instVars : [
		'path',
		'model'
	],
	#category : #'GToolkitLauncher-GToolkitLauncher'
}

{ #category : #'as yet unclassified' }
GLGRelease class >> onPath: path [ 
	^self new
		path: path;
		yourself
]

{ #category : #'as yet unclassified' }
GLGRelease class >> onPath: path in: aModel [ 
	^self new
		path: path;
		model: aModel;
		yourself
]

{ #category : #'as yet unclassified' }
GLGRelease >> gtCardOn: aView [

]

{ #category : #'as yet unclassified' }
GLGRelease >> lastChanged [
 	|imagePath|
	imagePath := (path / 'GlamorousToolkit.image') asFileReference.
	imagePath exists ifFalse: [^' N/A'] ifTrue: [^imagePath changeTime]
]

{ #category : #'as yet unclassified' }
GLGRelease >> model: aModel [ 
	model := aModel
]

{ #category : #accessing }
GLGRelease >> path [
	^ path
]

{ #category : #'as yet unclassified' }
GLGRelease >> path: aPath [ 
	path := aPath
]

{ #category : #'as yet unclassified' }
GLGRelease >> releaseName [
	^ path basename
]

{ #category : #'as yet unclassified' }
GLGRelease >> run [
	|command|
	command := 'cd "', self path fullName, '" && ',
	 	GLGPlatform current runCommand.
	LibC runCommand: command
]

{ #category : #'as yet unclassified' }
GLGRelease >> showFolder [
	path inspect
]
