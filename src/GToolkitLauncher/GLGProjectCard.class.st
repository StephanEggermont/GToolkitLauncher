Class {
	#name : #GLGProjectCard,
	#superclass : #BlElement,
	#instVars : [
		'project'
	],
	#category : #GToolkitLauncher
}

{ #category : #'as yet unclassified' }
GLGProjectCard >> initialize [
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
		aptitude: (BrGlamorousWithExplicitContextMenuAptitude
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
GLGProjectCard >> project [
	^ project
]

{ #category : #accessing }
GLGProjectCard >> project: anObject [
	project := anObject.
	self updateContents
]

{ #category : #'as yet unclassified' }
GLGProjectCard >> run [
	project run.

]

{ #category : #'as yet unclassified' }
GLGProjectCard >> showFolder [
	project showFolder
]

{ #category : #'as yet unclassified' }
GLGProjectCard >> simpleTextField [
	^ BrLabel new
		aptitude: BrGlamorousLabelAptitude new glamorousRegularFontAndSize;
		padding: (BlInsets left: 2);
		text: ''
]

{ #category : #'as yet unclassified' }
GLGProjectCard >> simpleTextList [
	^ BrSimpleList new
		aptitude: BrSimpleListAptitude new;
		itemStencil: [ BrLabel new hMatchParent vFitContent beTinySize aptitude: BrGlamorousLabelAptitude ];
		padding: (BlInsets left: 2);
		itemDataBinder: [ :anItemElement :anItem | anItemElement text: anItem ];
		items: #()
]

{ #category : #'as yet unclassified' }
GLGProjectCard >> update: aReleaseRunState [

	 
]

{ #category : #accessing }
GLGProjectCard >> updateContents [
	(self childAt: 1) text: release releaseName.
	(self childAt: 2) text: release lastChanged.
	(self childAt: 3) items: release gitRepos

]
