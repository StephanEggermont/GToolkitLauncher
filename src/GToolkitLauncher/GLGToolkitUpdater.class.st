Class {
	#name : #GLGToolkitUpdater,
	#superclass : #Object,
	#instVars : [
		'lastUpdated',
		'latestVersion',
		'model',
		'zipName'
	],
	#category : 'GToolkitLauncher-GToolkitLauncher'
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
	command := 'cd "' , aLocalEnvironment downloadPath asFileReference pathString
		, '" && unzip ', zipName, ' -d "'
		, (aLocalEnvironment releasesPath / latestVersion) asFileReference pathString
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
	^latestVersion ifNil: ['Not checked']
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
	| command move|
	(aLocalEnvironment releasesPath / latestVersion) asFileReference ensureCreateDirectory.
	move := GLGPlatform current moveCommand.
	command := move,' "' ,( aLocalEnvironment downloadPath / zipName) asFileReference pathString,'" "'
		, (aLocalEnvironment releasesPath / latestVersion) asFileReference pathString
		, '"'.
	LibC runCommand: command.
	^ command
]

{ #category : #'as yet unclassified' }
GLGToolkitUpdater >> refreshString [
	^String streamContents: [:s |
		lastUpdated ifNil: [
			s nextPutAll:'Not checked'] 
		ifNotNil: [
			s nextPutAll: lastUpdated asStringYMDHM].
		s nextPutAll: ' - '.
		s nextPutAll: latestVersion asString
	]
]

{ #category : #accessing }
GLGToolkitUpdater >> updateIn: aLocalEnvironment [
	zipName := 'GlamorousToolkit', GLGPlatform current platformName, '-release.zip'. 
	self downloadUpdate: aLocalEnvironment.
	self extractUpdate: aLocalEnvironment.
	self moveDownloadedZip: aLocalEnvironment
]
