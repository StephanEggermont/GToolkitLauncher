Class {
	#name : #GLGRelease,
	#superclass : #Object,
	#instVars : [
		'path'
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
GLGRelease >> gtCardOn: aView [

]

{ #category : #'as yet unclassified' }
GLGRelease >> lastChanged [
 	|imagePath|
	imagePath := (path / 'GlamorousToolkit.image') asFileReference.
	imagePath exists ifFalse: [^' N/A'] ifTrue: [^imagePath changeTime]
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
