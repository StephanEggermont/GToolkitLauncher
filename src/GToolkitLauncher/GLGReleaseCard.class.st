Class {
	#name : #GLGReleaseCard,
	#superclass : #BlElement,
	#instVars : [
		'release'
	],
	#category : #GToolkitLauncher
}

{ #category : #'as yet unclassified' }
GLGReleaseCard >> initialize [
	super initialize.
	self
		size: 120 @ 90;
		geometry: (BlRoundedRectangleGeometry cornerRadius: 3);
		background: Color lightGray muchLighter;
		border: (BlBorder paint: Color lightGray lighter width: 1);
		layout: BlLinearLayout vertical;
		margin: (BlInsets all: 6);
		padding: (BlInsets
				top: 2
				left: 2
				bottom: 2
				right: 2);
		aptitude: (BrGlamorousWithContextMenuAptitude
				handle: [ BlElement new
						size: 2 @ 2;
						geometry: BlEllipseGeometry new ]
				content: [ GLGReleaseCardEditor new
						card: self;
						requestFocus ]);
		addChild: self simpleTextField;
		addChild: self simpleTextField;
		addChild: self simpleTextList;
		addChild: self simpleTextField
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
	release model monitor announcer when: ReleaseRunStateChange send: #update: to: self.
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
		itemStencil: [ BrLabel new hMatchParent beSmallSize aptitude: BrGlamorousLabelAptitude ];
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
