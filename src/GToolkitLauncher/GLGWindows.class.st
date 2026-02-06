Class {
	#name : #GLGWindows,
	#superclass : #GLGPlatform,
	#category : #GToolkitLauncher
}

{ #category : #'as yet unclassified' }
GLGWindows >> installOn: aPath [
	| command |
	command := 'cd "', aPath asFileReference pathString, '" && start /b"', 
		aPath asFileReference pathString, '/bin/GlamorousToolkit-cli" *image st ',(self installFilePath: aPath),' --interactive --no-quit &'.
	LibC runCommand: command
]

{ #category : #'as yet unclassified' }
GLGWindows >> moveCommand [
	^'move'
]

{ #category : #accessing }
GLGWindows >> platformName [
	^'Win64' 
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
