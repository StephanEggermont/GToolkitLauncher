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
	^'open ./GlamorousToolkit.app &'
]
