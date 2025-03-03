Class {
	#name : #GLGLinux,
	#superclass : #GLGPlatform,
	#category : #GToolkitLauncher
}

{ #category : #accessing }
GLGLinux >> platformName [
	^'Linux'
]

{ #category : #accessing }
GLGLinux >> runCommand [
	^'"./bin/GlamorousToolkit" &'
]
