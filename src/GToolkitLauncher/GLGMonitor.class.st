Class {
	#name : 'GLGMonitor',
	#superclass : 'Object',
	#instVars : [
		'model',
		'runningProcesses',
		'state',
		'psLines',
		'process',
		'interval',
		'announcer',
		'oldRunningProcesses'
	],
	#category : 'GToolkitLauncher',
	#package : 'GToolkitLauncher'
}

{ #category : 'accessing' }
GLGMonitor class >> on: aModel [
	^(self new)
		model: aModel;
		yourself
]

{ #category : 'as yet unclassified' }
GLGMonitor >> announcer [
	^announcer
]

{ #category : 'as yet unclassified' }
GLGMonitor >> defaultInterval [
	^10 "seconds".
]

{ #category : 'as yet unclassified' }
GLGMonitor >> initialize [ 
	oldRunningProcesses := OrderedCollection new.
	runningProcesses := OrderedCollection new.
	interval := self defaultInterval.
	announcer := Announcer new
]

{ #category : 'as yet unclassified' }
GLGMonitor >> isRunning [
	^process notNil
]

{ #category : 'as yet unclassified' }
GLGMonitor >> markRunning [
	oldRunningProcesses := runningProcesses.
	runningProcesses := (psLines select: [:each | (self normalizePathSeparators: each command) matches: (self normalizePathSeparators: self releasesPathPattern)]) asOrderedCollection.
	oldRunningProcesses removeAllFoundIn: runningProcesses.
	runningProcesses do: [:psr | self announcer announce: (ReleaseRunStateChange new 
		pid: psr pid; 
		version: psr command; 
		state: #running;
		yourself)].
	oldRunningProcesses do: [:psr | self announcer announce: (ReleaseRunStateChange new 
		pid: psr pid; 
		version: psr command; 
		state: #stopped;
		yourself)].

]

{ #category : 'accessing' }
GLGMonitor >> model: aModel [ 
	model := aModel
]

{ #category : 'as yet unclassified' }
GLGMonitor >> normalizePathSeparators: aString [ 
	"Windows process command lines (e.g. from CIM/WMI) use backslashes, while
	release paths are built via FileReference (forward-slash normalized) even
	on Windows. Normalize both sides to forward slashes before matching so
	#markRunning correctly recognizes running releases on every platform."
 
	^ aString copyReplaceAll: '\' with: '/'
]

{ #category : 'as yet unclassified' }
GLGMonitor >> parseWindowsProcessLine: aLine [ 
	"Each line is 'PID<TAB>CPU<TAB>MEM<TAB>CommandLine' - command last since
	it's the only field that may itself contain further structure."
	<return: #GLGProcessInfo>
 
	| parts |
	parts := aLine substrings: {Character tab}.
 
	^ GLGProcessInfo
		pid: (parts at: 1 ifAbsent: ['0']) trimBoth asInteger
		command: (parts at: 4 ifAbsent: [''])
		cpu: (parts at: 2 ifAbsent: [''])
		mem: (parts at: 3 ifAbsent: [''])
]

{ #category : 'as yet unclassified' }
GLGMonitor >> releasesPathPattern [
	"The glob pattern identifying a release process by its command line.
	Written with forward slashes; both this pattern and the candidate command
	line are run through #normalizePathSeparators: before comparing, so the
	authored form here doesn't matter."
 
	^ '*/gt/releases/*'
]

{ #category : 'as yet unclassified' }
GLGMonitor >> run: aRelease [
	self isRunning ifFalse: [self start].
	self announcer announce: (ReleaseRunStateChange new
		version: aRelease releaseName;
		state: #running;
		pid: '';
		yourself)
]

{ #category : 'as yet unclassified' }
GLGMonitor >> runPs [
	"Populate psLines with the currently running processes, one entry per process,
	each responding to #pid and #command. Uses the native external-process
	library (no shell, no LibC) so nothing is executed through msvcrt.dll's
	faked #system() and no console window is ever shown."
 
	psLines := OSPlatform current isWindows
		ifTrue: [ self runPsWindows ]
		ifFalse: [ self runPsUnix ]

]

{ #category : 'as yet unclassified' }
GLGMonitor >> runPsUnix [ 
	^ (GtExternalProcessBuilder new
		command: 'ps';
		args: #('aux');
		nullStdin;
		output) stdout lines collect: [ :line | GLGProcessInfo fromPsLine: line ]
]

{ #category : 'as yet unclassified' }
GLGMonitor >> runPsWindows [ 
	"There is no 'ps' on Windows. Query the process list (pid, cpu time in
	seconds, working-set memory in MB, and full command line, which is what
	#markRunning matches against) via CIM/WMI through PowerShell, run
	windowlessly and synchronously through GtExternalProcessBuilder.
	Each output line is 'PID<TAB>CPU<TAB>MEM<TAB>CommandLine'."
	<return: #Collection>
 
	| aScript anOutput |
	aScript := 'Get-CimInstance Win32_Process | ForEach-Object { "{0}`t{1}`t{2}`t{3}" -f $_.ProcessId, (($_.UserModeTime + $_.KernelModeTime) / 1e7), ($_.WorkingSetSize / 1MB), $_.CommandLine }'.
 
	anOutput := GtExternalProcessBuilder new
		command: 'powershell';
		args: #('-NoProfile' '-NonInteractive' '-Command');
		arg: aScript;
		nullStdin;
		output.
 
	^ ((anOutput stdout lines collect: [ :line | line trimBoth ])
		reject: [ :line | line isEmpty ])
		collect: [ :line | self parseWindowsProcessLine: line ]
]

{ #category : 'as yet unclassified' }
GLGMonitor >> start [
	self isRunning ifTrue: [^self].
	process := 
	[ [ self runPs.
		self markRunning.
		interval seconds wait.] repeat
	] forkAt: Processor userBackgroundPriority named: self class name
]

{ #category : 'as yet unclassified' }
GLGMonitor >> stop [
	process ifNotNil: [
		process terminate.
		process := nil.
	 ].
]

{ #category : 'as yet unclassified' }
GLGMonitor >> stopRelease: aRelease [ 
	self announcer announce: (ReleaseRunStateChange new
		version: aRelease releaseName;
		state: #stopped;
		pid: '';
		yourself)

]
