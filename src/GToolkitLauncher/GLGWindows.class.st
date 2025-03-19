Class {
	#name : #GLGWindows,
	#superclass : #GLGPlatform,
	#category : #GToolkitLauncher
}

{ #category : #'as yet unclassified' }
GLGWindows >> moveCommand [
	^'move'
]

{ #category : #accessing }
GLGWindows >> platformName [
	^'Win' 
]

{ #category : #accessing }
GLGWindows >> runCommand [
	^'start /b bin/GlamorousToolkit.exe'
]

{ #category : #'as yet unclassified' }
GLGWindows >> runReleaseOn: aPath [
|command|
	command := 'cd "', aPath asFileReference pathString, '" && ',self runCommand.
	LibC runCommand: command
]
