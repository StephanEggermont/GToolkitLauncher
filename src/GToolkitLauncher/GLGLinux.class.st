Class {
	#name : #GLGLinux,
	#superclass : #GLGPlatform,
	#category : #GToolkitLauncher
}

{ #category : #'as yet unclassified' }
GLGLinux >> installOn: aPath [
	| command |
	command := (self cdCommandFor: aPath), '"',
		aPath asFileReference pathString, '/bin/GlamorousToolkit-cli" *image st ',(self installFilePath: aPath),' --interactive --no-quit &'.
	LibC runCommand: command
]

{ #category : #'as yet unclassified' }
GLGLinux >> moveCommand [
	^'mv'
]

{ #category : #accessing }
GLGLinux >> platformName [
	^'Linux64'
]

{ #category : #accessing }
GLGLinux >> runCommand [
	^'/bin/GlamorousToolkit" &'
]

{ #category : #'as yet unclassified' }
GLGLinux >> runReleaseOn: aPath [
	| command runCmd |
	runCmd := (aPath asFileReference pathString matches: '*GlamorousToolkitLinux64*')
		ifTrue: [ self oldRunCommand ]
		ifFalse: [ self runCommand ].
	command := (self cdCommandFor: aPath), '"',
		 aPath asFileReference pathString, runCmd.
	LibC runCommand: command
]

{ #category : #'as yet unclassified' }
GLGLinux >> stopReleaseOn: aPath [ 
	| command |
	command := 'pkill -f "', aPath asFileReference pathString, '"'.
	LibC runCommand: command
]
