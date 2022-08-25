Class {
	#name : #GLGToolkitUpdater,
	#superclass : #Object,
	#instVars : [
		'lastUpdated',
		'latestVersion',
		'model'
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
GLGToolkitUpdater >> getLatestVersion [
	|foundVersion|
	foundVersion := (STONJSON fromString: (ZnEasy get: 'https://api.github.com/repos/feenkcom/gtoolkit/releases/latest') contents) at: #tag_name.
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
GLGToolkitUpdater >> model: aLauncherModel [ 
	model := aLauncherModel
]
