Class {
	#name : 'GLGWindowsProcessInfo',
	#superclass : 'Object',
	#instVars : [
		'pid',
		'command'
	],
	#category : 'GToolkitLauncher',
	#package : 'GToolkitLauncher'
}

{ #category : 'as yet unclassified' }
GLGWindowsProcessInfo class >> pid: anObject command: aCommand [ 
	^self new
		pid: anObject;
		command: aCommand;
		yourself
]

{ #category : 'as yet unclassified' }
GLGWindowsProcessInfo >> = aProcessInfo [
	^self pid = aProcessInfo pid
]

{ #category : 'accessing' }
GLGWindowsProcessInfo >> command [
	^ command
]

{ #category : 'accessing' }
GLGWindowsProcessInfo >> command: anObject [
	command := anObject
]

{ #category : 'as yet unclassified' }
GLGWindowsProcessInfo >> hash [
	^self pid hash
]

{ #category : 'accessing' }
GLGWindowsProcessInfo >> pid [
	^ pid
]

{ #category : 'accessing' }
GLGWindowsProcessInfo >> pid: anObject [
	pid := anObject
]
