Class {
	#name : 'ReleaseRunStateChange',
	#superclass : 'Announcement',
	#instVars : [
		'version',
		'state',
		'pid'
	],
	#category : 'GToolkitLauncher',
	#package : 'GToolkitLauncher'
}

{ #category : 'accessing' }
ReleaseRunStateChange >> pid [
	^ pid
]

{ #category : 'accessing' }
ReleaseRunStateChange >> pid: anObject [
	pid := anObject
]

{ #category : 'accessing' }
ReleaseRunStateChange >> state [
	^ state
]

{ #category : 'accessing' }
ReleaseRunStateChange >> state: anObject [
	state := anObject
]

{ #category : 'accessing' }
ReleaseRunStateChange >> version [
	^ version
]

{ #category : 'accessing' }
ReleaseRunStateChange >> version: anObject [
	version := anObject
]
