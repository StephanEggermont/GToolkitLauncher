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
		'gtButton',
		'updater',
		'versionLabel',
		'model'
	],
	#category : 'GToolkitLauncher'
}

{ #category : #accessing }
GLGToolkitLauncher class >> open [
	^self new open
]

{ #category : #accessing }
GLGToolkitLauncher >> addReleases [
	model update.
	self startMonitor.
(	model releases sorted: [:a :b | a lastChanged asString > b lastChanged asString])do: [:release | 
	pane addChild: (GLGReleaseCard new release: release; yourself)].
]

{ #category : #accessing }
GLGToolkitLauncher >> analyseButton [
	^BrButton new
		margin: (BlInsets
				top: 10
				left: 10
				bottom: 10
				right: 10);
		label: 'Check new and install analyse';
		aptitude: GLGButtonAptitude new separate;
		icon: BrGlamorousVectorIcons target;
		action: self checkAndDownloadAndInstallAction;
		yourself
]

{ #category : #accessing }
GLGToolkitLauncher >> checkAndDownloadAction [
	^ [ :button |
		button disable.
		model updater getLatestVersion.
		versionLabel text: model updater refreshString.
		model run.
		self updateReleases.
		button enable ]
]

{ #category : #accessing }
GLGToolkitLauncher >> checkAndDownloadAndInstallAction [
	^ [ :button |
		button disable.
		model updater getLatestVersion.
		versionLabel text: model updater refreshString.
		model run.
		self updateReleases.
		self installInLatest.
		self updateReleases.
		button enable ]
]

{ #category : #accessing }
GLGToolkitLauncher >> checkButton [
	^BrButton new
		margin: (BlInsets
				top: 10
				left: 10
				bottom: 10
				right: 0);
		label: 'Check & Download Update';
		aptitude: GLGButtonAptitude new left;
		icon: BrGlamorousVectorIcons refresh;
		action: self checkAndDownloadAction;
		yourself
]

{ #category : #accessing }
GLGToolkitLauncher >> gtButton [
	gtButton := BrButton new
			margin: (BlInsets
					top: 10
					left: 0
					bottom: 10
					right: 0);
			label: 'Open Development Environment';
			disable;
			aptitude: GLGButtonAptitude new right;
			icon: BrGlamorousVectorIcons gt;
			action: self openDevelopmentEnvironmentAction;
			yourself.
	^ gtButton
]

{ #category : #accessing }
GLGToolkitLauncher >> initialize [
	model := GLGLauncherModel new
]

{ #category : #accessing }
GLGToolkitLauncher >> installInLatest [
	|release|
	release := model releases detect: [:each | each releaseName = model updater latestVersion].
	release install
]

{ #category : #accessing }
GLGToolkitLauncher >> launcherView [
	launcherView := BlElement new
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ];
		layout: BlLinearLayout vertical;
		addChild: self toolbar;
		addChild:  self tabBar;
		yourself.
	^launcherView
]

{ #category : #accessing }
GLGToolkitLauncher >> model [
	^ model
]

{ #category : #accessing }
GLGToolkitLauncher >> model: anObject [
	model := anObject.

]

{ #category : #accessing }
GLGToolkitLauncher >> open [
	|space|
	space := BlSpace new.
	space addChild: self launcherView.
	space extent: 800@600.
	space title: 'GToolkit Launcher'.
	space
	addEventHandlerOn: BlSpaceClosedEvent
		do: [ 
			model monitor stop.
			model monitor: nil.
			model := nil
		 ].
	model monitor announcer when: ReleasesChanged send: #updateReleases to: self.

	space show
]

{ #category : #accessing }
GLGToolkitLauncher >> openDevelopmentEnvironmentAction [
	^ [ GtWorld openDefault ]
]

{ #category : #accessing }
GLGToolkitLauncher >> pane [
	pane := BlElement new
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ];
		background: Color lightGray muchLighter lighter;
		padding: (BlInsets all: 2);
		layout: BlFlowLayout horizontal;
		yourself.
	self addReleases.
	^pane
]

{ #category : #'as yet unclassified' }
GLGToolkitLauncher >> projectsView [
	projectsView := GLGProjectsView new.
	projectsView background: Color green muchLighter lighter.

	^projectsView
]

{ #category : #accessing }
GLGToolkitLauncher >> startMonitor [
	model monitor stop.
	model monitor start.
	model monitor announcer when: ReleaseRunStateChange send: #updateRunningstate: to: self.
]

{ #category : #'as yet unclassified' }
GLGToolkitLauncher >> tabBar [
	| aTabGroup |
	aTabGroup := BrTabGroup new.
	aTabGroup aptitude: BrGlamorousTabGroupAptitude new.

	aTabGroup
		addTab: (BrTab new
				aptitude: BrGlamorousTabAptitude new;
				label: 'Releases';
				stencil: [ self pane]).

	aTabGroup
		addTab: (BrTab new
				aptitude: BrGlamorousTabAptitude new;
				label: 'Projects';
				stencil: [ self projectsView]).

	^ aTabGroup
]

{ #category : #accessing }
GLGToolkitLauncher >> toolbar [
	toolbar := BlElement new
		background: Color lightGray muchLighter;
		layout: BlLinearLayout horizontal;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical exact: 40 ];
		addChild: self checkButton;
		addChild: self gtButton;
		addChild: self versionLabel;
		addChild: self analyseButton;
		yourself.
	^toolbar
]

{ #category : #accessing }
GLGToolkitLauncher >> updateReleases [
	pane removeChildren.
	self addReleases.
	self startMonitor.
]

{ #category : #accessing }
GLGToolkitLauncher >> updateRunningstate: aReleaseRunState [
	pane childrenDo: [:aCard | aCard update: aReleaseRunState] 
]

{ #category : #accessing }
GLGToolkitLauncher >> versionLabel [
	versionLabel := BrLabel new
		aptitude: BrGlamorousLabelAptitude;
		padding: (BlInsets top:10 left: 2);
		text: model updater latestVersion;
		yourself.
	^versionLabel
]
