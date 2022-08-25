Class {
	#name : #GLGToolkitUpdater,
	#superclass : #Object,
	#instVars : [
		'lastUpdated',
		'latestVersion',
		'model',
		'zipName'
	],
	#category : #'GToolkitLauncher-GToolkitLauncher'
}

{ #category : #accessing }
GLGToolkitUpdater class >> on: aLauncherModel [
	^self new
		model: aLauncherModel;
		yourself
]

{ #category : #accessing }
GLGToolkitUpdater >> downloadUpdate: aLocalEnvironment [
	| downloadLink |
	downloadLink := 'https://dl.feenk.com/gt/', zipName.
	ZnClient new
		url: downloadLink;
		downloadTo: aLocalEnvironment downloadPath
]

{ #category : #accessing }
GLGToolkitUpdater >> extractUpdate: aLocalEnvironment [
	| command |
	command := 'cd "' , aLocalEnvironment downloadPath fullName
		, '" && unzip ', zipName, ' -d "'
		, (aLocalEnvironment releasesPath / latestVersion) fullName
		, '"'.
	LibC runCommand: command.
	^ command
]

{ #category : #accessing }
GLGToolkitUpdater >> getLatestVersion [
	| foundVersion |
	foundVersion := (STONJSON fromString: (ZnEasy get: self latestVersionLocation) contents)
			at: #tag_name.
	lastUpdated := DateAndTime now.
	latestVersion := foundVersion
]

{ #category : #accessing }
GLGToolkitUpdater >> lastUpdated [
	^lastUpdated 
]

{ #category : #accessing }
GLGToolkitUpdater >> latestVersion [
	^latestVersion
]

{ #category : #accessing }
GLGToolkitUpdater >> latestVersionLocation [
	^ 'https://api.github.com/repos/feenkcom/gtoolkit/releases/latest'
]

{ #category : #accessing }
GLGToolkitUpdater >> model: aLauncherModel [ 
	model := aLauncherModel
]

{ #category : #accessing }
GLGToolkitUpdater >> moveDownloadedZip: aLocalEnvironment [
	| command |
	command := 'mv "' ,( aLocalEnvironment downloadPath / zipName) fullName,'" "'
		, (aLocalEnvironment releasesPath / latestVersion) fullName
		, '"'.
	LibC runCommand: command.
	^ command
]

{ #category : #accessing }
GLGToolkitUpdater >> updateIn: aLocalEnvironment [
	zipName := 'GlamorousToolkit', GLGPlatform current platformName, '64-release.zip'. 
	self downloadUpdate: aLocalEnvironment.
	self extractUpdate: aLocalEnvironment.
	self moveDownloadedZip: aLocalEnvironment
]
