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
		background: Color lightGray muchLighter;
		border: (BlBorder paint: Color lightGray muchLighter width: 1);
		layout: BlLinearLayout vertical;
		margin: (BlInsets all: 6);
		padding:
			(BlInsets
				top: 2
				left: 2
				bottom: 2
				right: 2);
		aptitude: (BrGlamorousWithContextMenuAptitude
			handle: [ BlElement new
					size: 2@2;
					geometry: BlEllipseGeometry new ]
			content: [ GLGReleaseCardEditor new
				card: self;
				requestFocus]);
		addChild:
			(BrLabel new
				aptitude: BrGlamorousLabelAptitude new glamorousRegularFontAndSize;
				padding: (BlInsets left: 2);
				text: '');
		addChild:
			(BrLabel new
				aptitude: BrGlamorousLabelAptitude new glamorousRegularFontAndSize;
				padding: (BlInsets left: 2);
				text: '');
		addChild:
			(BrSimpleList new
				aptitude: BrSimpleListAptitude new ;
				itemStencil: [ BrLabel new 
					hMatchParent beSmallSize 
					aptitude: BrGlamorousLabelAptitude ];				
				padding: (BlInsets left: 2);
				itemDataBinder: [ :anItemElement :anItem | anItemElement text: anItem ];
				items: #()).

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
GLGReleaseCard >> update: aReleaseRunState [
	 (aReleaseRunState version matches: '*',release releaseName,'*') ifTrue: [
	 	self background: Color random].
	 
]

{ #category : #accessing }
GLGReleaseCard >> updateContents [
	(self childAt: 1) text: release releaseName.
	(self childAt: 2) text: release lastChanged.
	(self childAt: 3) items: release gitRepos

]
