Class {
	#name : 'GLGProcessInfo',
	#superclass : 'Object',
	#instVars : [
		'pid',
		'command',
		'cpu',
		'mem'
	],
	#category : 'GToolkitLauncher',
	#package : 'GToolkitLauncher'
}

{ #category : 'as yet unclassified' }
GLGProcessInfo class >> fromPsLine: aLine [ 
	"Parse one line of `ps aux` output. Command could have extra spaces in the path."
	<return: #GLGProcessInfo>
 
	| fields substrings substringStart colCount result |
	fields := #(user pid pcpu pmem vsz rss tty stat start time command).
	substrings := (Array new: 11) writeStream.
	colCount := 1.
	1 to: aLine size do: [ :i |
		| nextChar |
		nextChar := aLine at: i.
		(nextChar = Character space)
			ifTrue: [
				(colCount < 11) ifTrue: [
				substringStart
					ifNotNil: [
						substrings nextPut: (aLine copyFrom: substringStart to: i - 1).
						colCount := colCount+1.
						substringStart := nil ] ]]
			ifFalse: [ substringStart ifNil: [ substringStart := i ] ] ].
	substringStart
		ifNotNil: [ substrings nextPut: (aLine copyFrom: substringStart to: aLine size) ].
	result := Dictionary new.
	substrings contents withIndexDo: [:text :ind |
		result at: (fields at: ind) put: text].
 
	^ self
		pid: (result at: #pid) asInteger
		command: (result at: #command)
		cpu: (result at: #pcpu)
		mem: (result at: #pmem)

]

{ #category : 'as yet unclassified' }
GLGProcessInfo class >> pid: aPid command: aCommand cpu: aCpu mem: aMem [
	^self new
		pid: aPid;
		command: aCommand;
		cpu: aCpu;
		mem: aMem;
		yourself
]

{ #category : 'as yet unclassified' }
GLGProcessInfo >> = aProcessInfo [
	^self pid = aProcessInfo pid
]

{ #category : 'accessing' }
GLGProcessInfo >> command [
	^ command
]

{ #category : 'accessing' }
GLGProcessInfo >> command: anObject [
	command := anObject
]

{ #category : 'accessing' }
GLGProcessInfo >> cpu [
	^ cpu
]

{ #category : 'accessing' }
GLGProcessInfo >> cpu: anObject [
	cpu := anObject
]

{ #category : 'as yet unclassified' }
GLGProcessInfo >> hash [
	^self pid hash
]

{ #category : 'accessing' }
GLGProcessInfo >> mem [
	^ mem
]

{ #category : 'accessing' }
GLGProcessInfo >> mem: anObject [
	mem := anObject
]

{ #category : 'accessing' }
GLGProcessInfo >> pid [
	^ pid
]

{ #category : 'accessing' }
GLGProcessInfo >> pid: anObject [
	pid := anObject
]
