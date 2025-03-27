Class {
	#name : #GLGRelease,
	#superclass : #Object,
	#instVars : [
		'path',
		'model',
		'actualPath'
	],
	#category : #'GToolkitLauncher-GToolkitLauncher'
}

{ #category : #'as yet unclassified' }
GLGRelease class >> onPath: path in: aModel [ 
	^self new
		path: path;
		model: aModel;
		yourself
]

{ #category : #'as yet unclassified' }
GLGRelease >> actualPath [
	"in old releases, the directory structure was different"
	^actualPath
]

{ #category : #'as yet unclassified' }
GLGRelease >> gitRepos [
 	|reposPath|
	reposPath := (actualPath / 'pharo-local' / 'iceberg' ) asFileReference.
	reposPath exists ifFalse: [^#(' N/A')]
	ifTrue: [^Array streamContents: [:a |
		reposPath directories do: [:authorDir |
			authorDir directories do: [:repoDir |
			a nextPut: ("authorDir basename, '/', "repoDir basename) ]]]]
]

{ #category : #'as yet unclassified' }
GLGRelease >> lastChanged [
 	|imagePath|
	imagePath := (actualPath / 'GlamorousToolkit.image') asFileReference.
	imagePath exists ifFalse: [^' N/A'] ifTrue: [^imagePath changeTime asLocalStringYMDHM]
]

{ #category : #accessing }
GLGRelease >> model [
	^ model
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
	| version |
	path := aPath.
	version := path basename.
	"In old releases, the directory structure was different.
	There is then an extra subdirectory containing all data"
	actualPath := (path / ('GlamorousToolkitLinux64-',version)).
	(actualPath asFileReference exists) ifFalse: [actualPath := path].
]

{ #category : #'as yet unclassified' }
GLGRelease >> releaseName [
	^ path basename
]

{ #category : #'as yet unclassified' }
GLGRelease >> run [
	model monitorRun: self.
	GLGPlatform current runReleaseOn: actualPath.

]

{ #category : #'as yet unclassified' }
GLGRelease >> showFolder [
	path inspect
]
