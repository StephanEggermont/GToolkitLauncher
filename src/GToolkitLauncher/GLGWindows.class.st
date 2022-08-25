Class {
	#name : #GLGWindows,
	#superclass : #GLGPlatform,
	#category : #GToolkitLauncher
}

{ #category : #accessing }
GLGWindows >> platformName [
	^'Win' 
]

{ #category : #accessing }
GLGWindows >> runCommand [
	^'bin/GlamorousToolkit.exe'
]
