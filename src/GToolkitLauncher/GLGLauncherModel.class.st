Class {
	#name : #GLGLauncherModel,
	#superclass : #Object,
	#instVars : [
		'localEnvironment',
		'updater',
		'monitor',
		'releases'
	],
	#category : #'GToolkitLauncher-GToolkitLauncher'
}

{ #category : #'as yet unclassified' }
GLGLauncherModel >> getReleases [
	^(localEnvironment releasesPath asFileReference directories) collect: [:path |
	GLGRelease onPath: path in: self]
]

{ #category : #accessing }
GLGLauncherModel >> initialize [
	localEnvironment := GLGLocalEnvironment on: self.
	localEnvironment ensureDirectories.
	updater := GLGToolkitUpdater on: self.
	monitor := GLGMonitor on: self
]

{ #category : #accessing }
GLGLauncherModel >> localEnvironment [
	^localEnvironment
]

{ #category : #accessing }
GLGLauncherModel >> monitor [
	^ monitor
]

{ #category : #accessing }
GLGLauncherModel >> monitor: anObject [
	monitor := anObject
]

{ #category : #'as yet unclassified' }
GLGLauncherModel >> monitorRun: aRelease [
	monitor run: aRelease
]

{ #category : #'as yet unclassified' }
GLGLauncherModel >> releases [
	^releases ifNil: [releases := self getReleases]
]

{ #category : #'as yet unclassified' }
GLGLauncherModel >> run [ 
	(localEnvironment hasRelease: updater latestVersion) ifFalse: [
		updater getLatestVersion.
		updater updateIn: localEnvironment]
]

{ #category : #'as yet unclassified' }
GLGLauncherModel >> update [
	releases := self getReleases
]

{ #category : #accessing }
GLGLauncherModel >> updater [
	^updater 
]
