Class {
	#name : #GLGLauncherModel,
	#superclass : #Object,
	#instVars : [
		'localEnvironment',
		'updater',
		'monitor',
		'releases',
		'projects'
	],
	#category : #'GToolkitLauncher-GToolkitLauncher'
}

{ #category : #'as yet unclassified' }
GLGLauncherModel >> getProjects [
	^(localEnvironment projectsPath asFileReference directories) collect: [:path |
	GLGProject onPath: path in: self]
]

{ #category : #'as yet unclassified' }
GLGLauncherModel >> getReleases [
	^(localEnvironment releasesPath asFileReference directories) collect: [:path |
	GLGRelease onPath: path in: self]
]

{ #category : #'as yet unclassified' }
GLGLauncherModel >> gtViewProjectsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Projects';
		priority: 20;
		items: (self projects sorted: #title descending);
		column: 'Name' text: [ :each | each title ];
		actionUpdateButton
]

{ #category : #'as yet unclassified' }
GLGLauncherModel >> gtViewReleasesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Releases';
		priority: 10;
		items: (self releases sorted: #lastChanged descending);
		column: 'Name' text: [ :each | each releaseName ];
		column: 'Last changed' text: [ :each | each lastChanged ];
		actionUpdateButton
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
GLGLauncherModel >> projects [
	^projects ifNil: [projects := self getProjects]
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
