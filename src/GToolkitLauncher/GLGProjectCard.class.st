Class {
	#name : 'GLGProjectCard',
	#superclass : 'GLGCard',
	#instVars : [
		'project'
	],
	#category : 'GToolkitLauncher',
	#package : 'GToolkitLauncher'
}

{ #category : 'as yet unclassified' }
GLGProjectCard >> editor [
	^ GLGReleaseCardEditor new
		card: self;
		requestFocus
]

{ #category : 'as yet unclassified' }
GLGProjectCard >> item [
	^project
]

{ #category : 'accessing' }
GLGProjectCard >> project [
	^ project
]

{ #category : 'accessing' }
GLGProjectCard >> project: anObject [
	project := anObject.
	self updateContents
]

{ #category : 'as yet unclassified' }
GLGProjectCard >> update: aReleaseRunState [

	 
]

{ #category : 'accessing' }
GLGProjectCard >> updateContents [
	(self childAt: 1) text: project title.
	(self childAt: 3) items: {}

]
