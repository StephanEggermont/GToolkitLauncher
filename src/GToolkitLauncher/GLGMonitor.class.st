Class {
	#name : #GLGMonitor,
	#superclass : #Object,
	#instVars : [
		'model',
		'runningProcesses',
		'state',
		'psLines',
		'process'
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
GLGMonitor >> initialize [ 
	runningProcesses := OrderedCollection new.

]

{ #category : #'as yet unclassified' }
GLGMonitor >> isRunning [
	^process notNil
]

{ #category : #'as yet unclassified' }
GLGMonitor >> isStarted [
	^state = #started
]

{ #category : #'as yet unclassified' }
GLGMonitor >> markRunning [
	|toBeDeleted|
	toBeDeleted := OrderedCollection new.
	runningProcesses do: [:release |
		psLines detect: [:line |
			line matches: '*', release actualPath, '*'] 
			ifNone: [toBeDeleted add: release]].
	runningProcesses removeAll: toBeDeleted
	
]

{ #category : #accessing }
GLGMonitor >> model: aModel [ 
	model := aModel
]

{ #category : #'as yet unclassified' }
GLGMonitor >> run: aRelease [
	runningProcesses add: aRelease.
	self isStarted ifFalse: self start
]

{ #category : #'as yet unclassified' }
GLGMonitor >> runPs [
	psLines := (LibC resultOfCommand: 'ps aux') lines.
]

{ #category : #'as yet unclassified' }
GLGMonitor >> start [
	self isRunning ifTrue: [^self].
	process := 
	[ [10 seconds wait.
		self runPs.
		self markRunning] repeat
	] forkAt: Processor userBackgroundPriority named: self class name
]

{ #category : #'as yet unclassified' }
GLGMonitor >> stop [
	process ifNotNil: [
		process terminate.
		process := nil.
	 ]
]
