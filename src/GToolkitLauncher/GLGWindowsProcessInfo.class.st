Class {
	#name : #GLGWindowsProcessInfo,
	#superclass : #Object,
	#instVars : [
		'pid',
		'command'
	],
	#category : #GToolkitLauncher
}

{ #category : #'as yet unclassified' }
GLGWindowsProcessInfo class >> pid: anObject command: aCommand [ 
	^self new
		pid: anObject;
		command: aCommand;
		yourself
]

{ #category : #accessing }
GLGWindowsProcessInfo >> command [
	^ command
]

{ #category : #accessing }
GLGWindowsProcessInfo >> command: anObject [
	command := anObject
]

{ #category : #accessing }
GLGWindowsProcessInfo >> pid [
	^ pid
]

{ #category : #accessing }
GLGWindowsProcessInfo >> pid: anObject [
	pid := anObject
]
