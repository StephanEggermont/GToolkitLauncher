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
	^'bin/GlamorousToolkit.exe'
]
