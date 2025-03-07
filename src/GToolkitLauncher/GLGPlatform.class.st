Class {
	#name : #GLGPlatform,
	#superclass : #Object,
	#classInstVars : [
		'current'
	],
	#category : #GToolkitLauncher
}

{ #category : #accessing }
GLGPlatform class >> current [
	current ifNil: [
		OSPlatform current family = 'MacOSX' ifTrue: [current := GLGMac new].
		OSPlatform current family = 'Unix' ifTrue: [current := GLGLinux new].
		OSPlatform current family = 'Windows' ifTrue: [current := GLGWindows new]].
	^current 
]

{ #category : #accessing }
GLGPlatform class >> reset [
	current := nil
]

{ #category : #accessing }
GLGPlatform >> platformName [
	self subclassResponsibility
]

{ #category : #accessing }
GLGPlatform >> runCommand [
	self subclassResponsibility
]
