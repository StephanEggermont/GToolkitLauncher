Class {
	#name : #GLGLauncherModel,
	#superclass : #Object,
	#instVars : [
		'localEnvironment',
		'updater'
	],
	#category : #'GToolkitLauncher-GToolkitLauncher'
}

{ #category : #accessing }
GLGLauncherModel >> initialize [
	localEnvironment := GLGLocalEnvironment on: self.
	localEnvironment ensureDirectories.
	updater := GLGToolkitUpdater on: self.
]

{ #category : #accessing }
GLGLauncherModel >> localEnvironment [
	^localEnvironment
]

{ #category : #'as yet unclassified' }
GLGLauncherModel >> releases [
	^(localEnvironment releasesPath asFileReference directories) collect: [:path |
	GLGRelease onPath: path in: self]
]

{ #category : #'as yet unclassified' }
GLGLauncherModel >> run [ 
	(localEnvironment hasRelease: updater latestVersion) ifFalse: [
		updater getLatestVersion.
		updater updateIn: localEnvironment]
]

{ #category : #accessing }
GLGLauncherModel >> updater [
	^updater 
]
