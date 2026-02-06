Class {
	#name : #GLGMac,
	#superclass : #GLGPlatform,
	#category : #GToolkitLauncher
}

{ #category : #'as yet unclassified' }
GLGMac >> installOn: aPath [
	| command |
	command := 'cd "', aPath asFileReference pathString, '" && open "', 
		aPath asFileReference pathString, '/bin/GlamorousToolkit-cli" *image st ',(self installFilePath: aPath),' --interactive --no-quit &'.
	LibC runCommand: command
]

{ #category : #'as yet unclassified' }
GLGMac >> moveCommand [
	^'mv'
]

{ #category : #accessing }
GLGMac >> platformName [
	OSPlatform current processorArchitecture = 'x86_64'
		ifTrue: [ ^ 'OSX64' ]
		ifFalse: [ ^ 'OSXM1' ]
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
