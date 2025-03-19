Class {
	#name : #GLGMonitor,
	#superclass : #Object,
	#instVars : [
		'model',
		'runningProcesses',
		'state'
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
	state := #stopped
]

{ #category : #'as yet unclassified' }
GLGMonitor >> isStarted [
	^state = #started
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
GLGMonitor >> start [
	state := #started
]
