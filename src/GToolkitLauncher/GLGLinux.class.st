Class {
	#name : #GLGLinux,
	#superclass : #GLGPlatform,
	#category : #GToolkitLauncher
}

{ #category : #'as yet unclassified' }
GLGLinux >> moveCommand [
	^'mv'
]

{ #category : #accessing }
GLGLinux >> platformName [
	^'Linux'
]

{ #category : #accessing }
GLGLinux >> runCommand [
	^'/bin/GlamorousToolkit" &'
]

{ #category : #'as yet unclassified' }
GLGLinux >> runReleaseOn: aPath [
|command|
	command := (aPath asFileReference pathString matches: '*GlamorousToolkitLinux64*') ifFalse: [
	'cd "', aPath asFileReference pathString, '" && "',
		 aPath asFileReference pathString, self runCommand] ifTrue: [
	'cd "', aPath asFileReference pathString, '" && "',
		 aPath asFileReference pathString, self oldRunCommand].
	LibC runCommand: command
]
