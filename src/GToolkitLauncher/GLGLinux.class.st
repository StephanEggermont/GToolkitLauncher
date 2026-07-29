Class {
	#name : 'GLGLinux',
	#superclass : 'GLGPlatform',
	#category : 'GToolkitLauncher',
	#package : 'GToolkitLauncher'
}

{ #category : 'as yet unclassified' }
GLGLinux >> installOn: aPath [
	^ GtExternalProcessBuilder new
		command: (aPath asFileReference / 'bin' / 'GlamorousToolkit-cli') fullName;
		args: { '*image'. 'st'. (self installFilePath: aPath). '--interactive'. '--no-quit' };
		workingDirectory: aPath asFileReference;
		nullStdin;
		nullStdout;
		nullStderr;
		spawn
]

{ #category : 'as yet unclassified' }
GLGLinux >> moveCommand [
	^'mv'
]

{ #category : 'accessing' }
GLGLinux >> platformName [
	^'Linux64'
]

{ #category : 'accessing' }
GLGLinux >> runCommand [
	^'/bin/GlamorousToolkit" &'
]

{ #category : 'as yet unclassified' }
GLGLinux >> runReleaseOn: aPath [
	| anExecutable |

	anExecutable := (aPath asFileReference pathString matches: '*GlamorousToolkitLinux64*')
		ifTrue: [ aPath asFileReference / 'glamoroustoolkit' ]
		ifFalse: [ aPath asFileReference / 'bin' / 'GlamorousToolkit' ].

	^ GtExternalProcessBuilder new
		command: anExecutable fullName;
		workingDirectory: aPath asFileReference;
		nullStdin;
		nullStdout;
		nullStderr;
		spawn
]

{ #category : 'as yet unclassified' }
GLGLinux >> stopReleaseOn: aPath [ 
	^ (GtExternalProcessBuilder new
		command: 'pkill';
		args: { '-f'. aPath asFileReference pathString };
		nullStdin;
		nullStdout;
		nullStderr;
		status) isSuccess
]
