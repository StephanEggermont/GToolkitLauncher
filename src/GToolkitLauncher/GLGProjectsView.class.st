Class {
	#name : #GLGProjectsView,
	#superclass : #BlElement,
	#instVars : [
		'model',
		'pane',
		'nameEditor'
	],
	#category : #GToolkitLauncher
}

{ #category : #'as yet unclassified' }
GLGProjectsView >> addProject [ 
	| aName |
	aName := nameEditor text asString trimBoth.
	aName isEmpty ifTrue: [ ^ self ].
	self addProjectCard: (model addProject: aName).
	nameEditor text: ''.
	nameEditor requestFocus

]

{ #category : #'as yet unclassified' }
GLGProjectsView >> addProjectButton [ 
	^ BrButton new
		margin: (BlInsets
				top: 10
				left: 0
				bottom: 10
				right: 10);
		aptitude: BrGlamorousButtonWithIconAptitude new;
		icon: BrGlamorousVectorIcons add;
		action: [ self addProject ];
		yourself

]

{ #category : #'as yet unclassified' }
GLGProjectsView >> addProjectCard: aProject [
	pane addChild: (GLGProjectCard new project: aProject; yourself)

]

{ #category : #'as yet unclassified' }
GLGProjectsView >> addProjects [
	model projects do: [ :aProject | self addProjectCard: aProject ]

]

{ #category : #'as yet unclassified' }
GLGProjectsView >> initialize [
	super initialize.
	self
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent ];
		layout: BlLinearLayout vertical;
		addChild: self toolbar;
		addChild: self pane

]

{ #category : #'as yet unclassified' }
GLGProjectsView >> model: aModel [
	model := aModel.
	self addProjects
]

{ #category : #'as yet unclassified' }
GLGProjectsView >> nameEditor [
	^ nameEditor := BrEditor new
		background: Color white;
		border: (BlBorder paint: Color lightGray lighter width: 1);
		aptitude: BrGlamorousCodeEditorAptitude;
		margin: (BlInsets
				top: 11
				left: 10
				bottom: 7
				right: 10);
		padding: (BlInsets all: 2);
		text: '';
		addShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination return;
				action: [ :anEvent | self addProject ]);
		when: BrEditorAcceptWish do: [ :aWish | self addProject ];
		yourself

]

{ #category : #'as yet unclassified' }
GLGProjectsView >> pane [ 
	pane := BlElement new
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ];
		background: Color lightGray muchLighter lighter;
		padding: (BlInsets all: 2);
		layout: BlFlowLayout horizontal;
		yourself.
	^ pane

]

{ #category : #'as yet unclassified' }
GLGProjectsView >> toolbar [
	^ BlElement new
		background: Color lightGray muchLighter;
		layout: BlLinearLayout horizontal;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical exact: 40 ];
		addChild: self nameEditor;
		addChild: self addProjectButton;
		yourself

]
