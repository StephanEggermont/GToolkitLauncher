Class {
	#name : #GLGMac,
	#superclass : #GLGPlatform,
	#category : 'GToolkitLauncher'
}

{ #category : #'as yet unclassified' }
GLGMac >> installOn: aPath [
	^ GtExternalProcessBuilder new
		command: (aPath asFileReference / 'GlamorousToolkit.app' / 'Contents' / 'MacOS' / 'GlamorousToolkit-cli') fullName;
		args: { '*image'. '--'. 'st'. (self installFilePath: aPath). '--interactive'. '--no-quit' };
		workingDirectory: aPath asFileReference;
		nullStdin;
		nullStdout;
		nullStderr;
		spawn
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
	^ GtExternalProcessBuilder new
		command: 'open';
		arg: (aPath asFileReference / 'GlamorousToolkit.app') fullName;
		workingDirectory: aPath asFileReference;
		nullStdin;
		nullStdout;
		nullStderr;
		spawn
]

{ #category : #'as yet unclassified' }
GLGMac >> stopReleaseOn: aPath [
	^ (GtExternalProcessBuilder new
		command: 'pkill';
		args: { '-f'. aPath asFileReference pathString };
		nullStdin;
		nullStdout;
		nullStderr;
		status) isSuccess
]
