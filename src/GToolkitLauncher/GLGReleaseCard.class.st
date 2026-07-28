Class {
	#name : #GLGReleaseCard,
	#superclass : #GLGCard,
	#instVars : [
		'release'
	],
	#category : #GToolkitLauncher
}

{ #category : #'as yet unclassified' }
GLGReleaseCard >> editor [
	^ GLGReleaseCardEditor new
		card: self;
		requestFocus
]

{ #category : #accessing }
GLGReleaseCard >> release [
	^ release
]

{ #category : #accessing }
GLGReleaseCard >> release: anObject [
	release := anObject.
	self updateContents.
]

{ #category : #'as yet unclassified' }
GLGReleaseCard >> run [
	release run.

]

{ #category : #'as yet unclassified' }
GLGReleaseCard >> showFolder [
	release showFolder
]

{ #category : #'as yet unclassified' }
GLGReleaseCard >> simpleTextField [
	^ BrLabel new
		aptitude: BrGlamorousLabelAptitude new glamorousRegularFontAndSize;
		padding: (BlInsets left: 2);
		text: ''
]

{ #category : #'as yet unclassified' }
GLGReleaseCard >> simpleTextList [
	^ BrSimpleList new
		aptitude: BrSimpleListAptitude new;
		itemStencil: [ BrLabel new hMatchParent vFitContent beTinySize aptitude: BrGlamorousLabelAptitude ];
		padding: (BlInsets left: 2);
		itemDataBinder: [ :anItemElement :anItem | anItemElement text: anItem ];
		items: #()
]

{ #category : #'as yet unclassified' }
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

{ #category : #accessing }
GLGReleaseCard >> updateContents [
	(self childAt: 1) text: release releaseName.
	(self childAt: 2) text: release lastChanged.
	(self childAt: 3) items: release gitRepos

]
