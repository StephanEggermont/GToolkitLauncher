"
I am the entry point for the GToolkit Launcher.
"
Class {
	#name : #GLGToolkitLauncher,
	#superclass : #Object,
	#instVars : [
		'launcherView',
		'toolbar',
		'pane',
		'gtButton'
	],
	#category : #GToolkitLauncher
}

{ #category : #accessing }
GLGToolkitLauncher class >> open [
	^self new open
]

{ #category : #accessing }
GLGToolkitLauncher >> gtButton [
	gtButton := BrButton new
		margin:
			(BlInsets
				top: 10
				left: 10
				bottom: 10
				right: 10);
		label: 'Open Development Environment';
		aptitude: BrGlamorousButtonRectangularAptitude+ BrGlamorousButtonExteriorAptitude+		BrGlamorousButtonIconAptitude +
		BrGlamorousButtonWithLabelTooltipAptitude ;
		icon: BrGlamorousVectorIcons gt;
		action: [ GtWorld openDefault ];
		yourself.
	^gtButton
]

{ #category : #accessing }
GLGToolkitLauncher >> launcherView [
	launcherView := BlElement new
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ];
		layout: BlLinearLayout vertical;
		addChild: self toolbar;
		addChild: self pane;
		yourself.
	^launcherView
]

{ #category : #accessing }
GLGToolkitLauncher >> open [
	|space|
	space := BlSpace new.
	space addChild: self launcherView.
	space extent: 800@600.
	space title: 'GToolkit Launcher'.
	space show
]

{ #category : #accessing }
GLGToolkitLauncher >> pane [
	pane := BlElement new
		size: 800@600;
		background: Color lightGray muchLighter lighter;
		padding: (BlInsets all: 2);
		layout: BlLinearLayout horizontal;
		yourself.
	^pane
]

{ #category : #accessing }
GLGToolkitLauncher >> toolbar [
	toolbar := BlElement new
		background: Color lightGray muchLighter;
		layout: BlLinearLayout horizontal;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical exact: 40 ];
		addChild: self gtButton;
		yourself.
	^toolbar
]
