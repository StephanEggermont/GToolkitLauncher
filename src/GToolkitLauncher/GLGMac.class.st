Class {
	#name : #GLGMac,
	#superclass : #GLGPlatform,
	#category : #GToolkitLauncher
}

{ #category : #'as yet unclassified' }
GLGMac >> moveCommand [
	^'mv'
]

{ #category : #accessing }
GLGMac >> platformName [
	^'OSX'
]

{ #category : #accessing }
GLGMac >> runCommand [
	^'/GlamorousToolkit.app &'
]

{ #category : #'as yet unclassified' }
GLGMac >> runReleaseOn: aPath [
|command|
	command := 'cd "', aPath asFileReference pathString, '" && open ',aPath asFileReference pathString,self runCommand.
	LibC runCommand: command
]
