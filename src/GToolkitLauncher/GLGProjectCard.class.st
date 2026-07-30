Class {
	#name : #GLGProjectCard,
	#superclass : #GLGCard,
	#instVars : [
		'project',
		'editor'
	],
	#category : #GToolkitLauncher
}

{ #category : #'as yet unclassified' }
GLGProjectCard >> addContents [
	self
		addChild: self simpleTextField;
		addChild: self scriptEditorPane;
		addChild: self scriptToolbar;
		addChild: self simpleTextList

]

{ #category : #'as yet unclassified' }
GLGProjectCard >> editor [
	^ GLGProjectCardEditor new
		card: self;
		requestFocus
]

{ #category : #'as yet unclassified' }
GLGProjectCard >> initialize [ 
	super initialize.
	self size: 220 @ 260

]

{ #category : #'as yet unclassified' }
GLGProjectCard >> item [
	^project
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
GLGProjectCard >> scriptEditor [
	^ editor := BrEditor new
		hMatchParent;
		vMatchParent;
		aptitude: BrGlamorousCodeEditorAptitude;
		text: ''

]

{ #category : #'as yet unclassified' }
GLGProjectCard >> scriptEditorPane [
	^ BrScrollPane new
		hMatchParent;
		constraintsDo: [ :c | c vertical exact: 120 ];
		content: self scriptEditor ;
		addAptitude: (BrScrollPaneAptitude+BrGlamorousWithVerticalScrollbarAptitude );
		yourself
]

{ #category : #'as yet unclassified' }
GLGProjectCard >> scriptToolbar [
	^ BlElement new
		layout: BlLinearLayout horizontal;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical exact: 30 ];
		addChild: (BrButton new
				aptitude: BrGlamorousButtonWithIconAptitude;
				beSmallSize;
				icon: BrGlamorousVectorIcons accept;
				label: 'Save';
				action: [ self project script: editor text asString ]);
		addChild: (BrButton new
				aptitude: BrGlamorousButtonWithIconAptitude;
				beSmallSize;
				icon: BrGlamorousVectorIcons cancel;
				label: 'Cancel';
				action: [ editor text: self project script ]);
		yourself

]

{ #category : #'as yet unclassified' }
GLGProjectCard >> update: aReleaseRunState [

	 
]

{ #category : #accessing }
GLGProjectCard >> updateContents [
	(self childAt: 1) text: project title.
	editor text: project script.
	(self childAt: 4) items: {}

]
