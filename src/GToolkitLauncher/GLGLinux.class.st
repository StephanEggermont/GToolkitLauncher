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
	^'"./bin/GlamorousToolkit" &'
]
