Class {
	#name : #GLGLocalEnvironment,
	#superclass : #Object,
	#instVars : [
		'rootPath',
		'model'
	],
	#category : #GToolkitLauncher
}

{ #category : #accessing }
GLGLocalEnvironment class >> on: aLauncherModel [
	^self new
		model: aLauncherModel;
		yourself
]

{ #category : #accessing }
GLGLocalEnvironment >> defaultRootPath [
	^(OSEnvironment current at: 'GTPATH' ifAbsent: [FileLocator home / 'gt']) asPath
]

{ #category : #accessing }
GLGLocalEnvironment >> downloadPath [
	^self rootPath / 'downloads'
]

{ #category : #accessing }
GLGLocalEnvironment >> ensureDirectories [
	self rootPath asFileReference ensureCreateDirectory.
	self downloadPath asFileReference ensureCreateDirectory.
	self releasesPath asFileReference ensureCreateDirectory.
]

{ #category : #'as yet unclassified' }
GLGLocalEnvironment >> hasRelease: aVersionString [ 
	^ (self releasesPath / aVersionString) asFileReference exists

]

{ #category : #accessing }
GLGLocalEnvironment >> model: aLauncherModel [ 
	model := aLauncherModel
]

{ #category : #accessing }
GLGLocalEnvironment >> releasesPath [
	^self rootPath / 'releases'
]

{ #category : #accessing }
GLGLocalEnvironment >> rootPath [
	^rootPath ifNil: [rootPath := self defaultRootPath]
]

{ #category : #accessing }
GLGLocalEnvironment >> rootPath: aPath [
	rootPath := aPath
]
