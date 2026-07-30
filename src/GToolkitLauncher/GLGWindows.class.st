Class {
	#name : #GLGWindows,
	#superclass : #GLGPlatform,
	#category : 'GToolkitLauncher'
}

{ #category : #'as yet unclassified' }
GLGWindows >> installOn: aPath [
	^ GtExternalProcessBuilder new
		command: (aPath asFileReference / 'bin' / 'GlamorousToolkit-cli.exe') fullName;
		args: { '*image'. 'st'. (self installFilePath: aPath). '--interactive'. '--no-quit' };
		workingDirectory: aPath asFileReference;
		nullStdin;
		nullStdout;
		nullStderr;
		spawn
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
	^ GtExternalProcessBuilder new
		command: (aPath asFileReference / 'bin' / 'GlamorousToolkit.exe') fullName;
		workingDirectory: aPath asFileReference;
		nullStdin;
		nullStdout;
		nullStderr;
		spawn
]

{ #category : #'as yet unclassified' }
GLGWindows >> stopReleaseOn: aPath [
	| aScript aStatus |
	aScript := 'Get-CimInstance Win32_Process | Where-Object { $_.CommandLine -like ''*',
		aPath asFileReference pathString, '*'' } | ForEach-Object { Stop-Process -Id $_.ProcessId -Force }'.

	aStatus := GtExternalProcessBuilder new
		command: 'powershell';
		args: #('-NoProfile' '-NonInteractive' '-Command');
		arg: aScript;
		nullStdin;
		nullStdout;
		nullStderr;
		status.

	^ aStatus isSuccess
]
