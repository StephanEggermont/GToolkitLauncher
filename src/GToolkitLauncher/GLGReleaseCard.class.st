Class {
	#name : 'GLGReleaseCard',
	#superclass : 'GLGCard',
	#instVars : [
		'release'
	],
	#category : 'GToolkitLauncher',
	#package : 'GToolkitLauncher'
}

{ #category : 'as yet unclassified' }
GLGReleaseCard >> editor [
	^ GLGReleaseCardEditor new
		card: self;
		requestFocus
]

{ #category : 'as yet unclassified' }
GLGReleaseCard >> item [
	^release
]

{ #category : 'accessing' }
GLGReleaseCard >> release [
	^ release
]

{ #category : 'accessing' }
GLGReleaseCard >> release: anObject [
	release := anObject.
	self updateContents.
]

{ #category : 'as yet unclassified' }
GLGReleaseCard >> update: aReleaseRunState [
	 (aReleaseRunState version matches: '*',release releaseName,'*') ifTrue: [
	 	aReleaseRunState state = #running ifTrue: [
	 		self background: Color green.
	 		(self childAt: 4) text: aReleaseRunState pid] 
	 	ifFalse: [
	 		 self background: Color lightGray muchLighter.
	 		(self childAt: 4) text: '']
	 	].
	 
]

{ #category : 'accessing' }
GLGReleaseCard >> updateContents [
	(self childAt: 1) text: release releaseName.
	(self childAt: 2) text: release lastChanged.
	(self childAt: 3) items: release gitRepos

]
