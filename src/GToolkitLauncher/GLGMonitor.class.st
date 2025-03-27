Class {
	#name : #GLGMonitor,
	#superclass : #Object,
	#instVars : [
		'model',
		'runningProcesses',
		'state',
		'psLines',
		'process',
		'interval',
		'announcer',
		'oldRunningProcesses'
	],
	#category : #GToolkitLauncher
}

{ #category : #accessing }
GLGMonitor class >> on: aModel [
	^(self new)
		model: aModel;
		yourself
]

{ #category : #'as yet unclassified' }
GLGMonitor >> announcer [
	^announcer
]

{ #category : #'as yet unclassified' }
GLGMonitor >> defaultInterval [
	^10 "seconds".
]

{ #category : #'as yet unclassified' }
GLGMonitor >> initialize [ 
	oldRunningProcesses := OrderedCollection new.
	runningProcesses := OrderedCollection new.
	interval := self defaultInterval.
	announcer := Announcer new
]

{ #category : #'as yet unclassified' }
GLGMonitor >> isRunning [
	^process notNil
]

{ #category : #'as yet unclassified' }
GLGMonitor >> markRunning [
	oldRunningProcesses := runningProcesses.
	runningProcesses := psLines select: [:each | each command matches: '*/gt/releases/*'].
	runningProcesses do: [:psr | self announcer announce: (ReleaseRunStateChange new 
		pid: psr pid; 
		version: psr command; 
		yourself)].
]

{ #category : #accessing }
GLGMonitor >> model: aModel [ 
	model := aModel
]

{ #category : #'as yet unclassified' }
GLGMonitor >> run: aRelease [
	runningProcesses add: aRelease.
	self isRunning ifFalse: self start
]

{ #category : #'as yet unclassified' }
GLGMonitor >> runPs [
	psLines := (LibC resultOfCommand: 'ps aux') lines collect: [:line | GLPSResult on: line].
]

{ #category : #'as yet unclassified' }
GLGMonitor >> start [
	self isRunning ifTrue: [^self].
	process := 
	[ [interval seconds wait.
		self runPs.
		self markRunning] repeat
	] forkAt: Processor userBackgroundPriority named: self class name
]

{ #category : #'as yet unclassified' }
GLGMonitor >> stop [
	process ifNotNil: [
		process terminate.
		process := nil.
	 ].
	self announcer
		ifNotNil: [ :anAnnouncer | anAnnouncer subscriptions reset ]
]
