Class {
	#name : #GLGPlatform,
	#superclass : #Object,
	#classInstVars : [
		'current'
	],
	#category : 'GToolkitLauncher'
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

{ #category : #'as yet unclassified' }
GLGPlatform >> installFilePath: aPath [
	^aPath asFileReference pathString, '/../../projects/analytics.st'
]

{ #category : #'as yet unclassified' }
GLGPlatform >> installOn: aPath [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
GLGPlatform >> moveCommand [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
GLGPlatform >> oldRunCommand [
	^'/glamoroustoolkit" &'
]

{ #category : #accessing }
GLGPlatform >> platformName [
	self subclassResponsibility
]

{ #category : #accessing }
GLGPlatform >> runCommand [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
GLGPlatform >> runReleaseOn: aPath [
|command|
	command := 'cd "', aPath asFileReference pathString, '" && "',
		 aPath asFileReference pathString, self runCommand.
	LibC runCommand: command
]
