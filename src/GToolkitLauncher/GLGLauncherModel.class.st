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
	updater := GLGToolkitUpdater on: self.
]

{ #category : #accessing }
GLGLauncherModel >> localEnvironment [
	^localEnvironment
]

{ #category : #'as yet unclassified' }
GLGLauncherModel >> releases [
	^(localEnvironment releasesPath asFileReference directories) collect: [:path |
	GLGRelease onPath: path]
]

{ #category : #accessing }
GLGLauncherModel >> updater [
	^updater 
]
