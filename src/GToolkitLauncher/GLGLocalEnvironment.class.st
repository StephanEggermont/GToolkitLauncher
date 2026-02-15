Class {
	#name : 'GLGLocalEnvironment',
	#superclass : 'Object',
	#instVars : [
		'rootPath',
		'model'
	],
	#category : 'GToolkitLauncher',
	#package : 'GToolkitLauncher'
}

{ #category : 'accessing' }
GLGLocalEnvironment class >> on: aLauncherModel [
	^self new
		model: aLauncherModel;
		yourself
]

{ #category : 'accessing' }
GLGLocalEnvironment >> analytics [
	^'
"I don''t need to track changes here, so we disable them"
EpMonitor current disable.

[
| lepiterDir props |
lepiterDir := (FileLocator imageDirectory / ''pharo-local'' / ''lepiter'') asFileReference.
lepiterDir ensureCreateDirectory.
props := LeDatabasesRegistry defaultLogicalDatabase properties.
props localFile asFileReference exists ifFalse: [ props save ].

Metacello new
	repository: ''github://StephanEggermont/GtRepositoryExploration:master/src'';
	baseline: ''GtRepositoryExploration'';
	load.
	
Metacello new
	repository: ''github://StephanEggermont/GtMicroPrints:main/src'';
	baseline: ''GtMicroPrints'';
	load.

Metacello new
	repository: ''github://StephanEggermont/GitBlame:master/src'';
	baseline: ''GitBlame'';
	load.
	

#BaselineOfGtRepositoryExploration asClass loadLepiter.

#BaselineOfGtMicroPrints asClass loadLepiter.

#BaselineOfGitBlame asClass loadLepiter.

] ensure: [ EpMonitor current enable ].

BlHost pickHost universe snapshot: true andQuit: true.'
]

{ #category : 'accessing' }
GLGLocalEnvironment >> defaultRootPath [
	^(OSEnvironment current at: 'GTPATH' ifAbsent: [FileLocator home / 'gt']) asPath
]

{ #category : 'accessing' }
GLGLocalEnvironment >> downloadPath [
	^self rootPath / 'downloads'
]

{ #category : 'accessing' }
GLGLocalEnvironment >> ensureAnalytics [
	|projectFile|
	projectFile := (self projectsPath asFileReference / 'analytics.st').
	projectFile exists ifFalse: [projectFile writeStreamDo: [:s | s nextPutAll: self analytics]]
]

{ #category : 'accessing' }
GLGLocalEnvironment >> ensureDirectories [
	self rootPath asFileReference ensureCreateDirectory.
	self downloadPath asFileReference ensureCreateDirectory.
	self releasesPath asFileReference ensureCreateDirectory.
	self projectsPath asFileReference ensureCreateDirectory.
]

{ #category : 'as yet unclassified' }
GLGLocalEnvironment >> hasRelease: aVersionString [ 
	^ (self releasesPath / aVersionString) asFileReference exists

]

{ #category : 'accessing' }
GLGLocalEnvironment >> model: aLauncherModel [ 
	model := aLauncherModel
]

{ #category : 'accessing' }
GLGLocalEnvironment >> projectsPath [
	^self rootPath / 'projects'
]

{ #category : 'accessing' }
GLGLocalEnvironment >> releasesPath [
	^self rootPath / 'releases'
]

{ #category : 'accessing' }
GLGLocalEnvironment >> rootPath [
	^rootPath ifNil: [rootPath := self defaultRootPath]
]

{ #category : 'accessing' }
GLGLocalEnvironment >> rootPath: aPath [
	rootPath := aPath
]
