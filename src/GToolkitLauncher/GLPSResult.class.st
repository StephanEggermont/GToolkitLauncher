Class {
	#name : #GLPSResult,
	#superclass : #Object,
	#instVars : [
		'pid',
		'pcpu',
		'pmem',
		'vsz',
		'rss',
		'stat',
		'start',
		'time',
		'command',
		'tty',
		'user'
	],
	#category : #GToolkitLauncher
}

{ #category : #'as yet unclassified' }
GLPSResult class >> on: aLine [
	"parse result of ps aux. command could have extra spaces in the path"
	| substrings substringStart colCount fields result|
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
	result := self new.
	substrings contents withIndexDo: [:text :ind |
		result perform: ((fields at: ind),':') with: text].
	^result
]

{ #category : #accessing }
GLPSResult >> command [
	^ command
]

{ #category : #accessing }
GLPSResult >> command: anObject [
	command := anObject
]

{ #category : #accessing }
GLPSResult >> pcpu [
	^ pcpu
]

{ #category : #accessing }
GLPSResult >> pcpu: anObject [
	pcpu := anObject
]

{ #category : #accessing }
GLPSResult >> pid [
	^ pid
]

{ #category : #accessing }
GLPSResult >> pid: anObject [
	pid := anObject
]

{ #category : #accessing }
GLPSResult >> pmem [
	^ pmem
]

{ #category : #accessing }
GLPSResult >> pmem: anObject [
	pmem := anObject
]

{ #category : #accessing }
GLPSResult >> rss [
	^ rss
]

{ #category : #accessing }
GLPSResult >> rss: anObject [
	rss := anObject
]

{ #category : #accessing }
GLPSResult >> start [
	^ start
]

{ #category : #accessing }
GLPSResult >> start: anObject [
	start := anObject
]

{ #category : #accessing }
GLPSResult >> stat [
	^ stat
]

{ #category : #accessing }
GLPSResult >> stat: anObject [
	stat := anObject
]

{ #category : #accessing }
GLPSResult >> time [
	^ time
]

{ #category : #accessing }
GLPSResult >> time: anObject [
	time := anObject
]

{ #category : #accessing }
GLPSResult >> tty [
	^ tty
]

{ #category : #accessing }
GLPSResult >> tty: anObject [
	tty := anObject
]

{ #category : #accessing }
GLPSResult >> user [
	^ user
]

{ #category : #accessing }
GLPSResult >> user: anObject [
	user := anObject
]

{ #category : #accessing }
GLPSResult >> vsz [
	^ vsz
]

{ #category : #accessing }
GLPSResult >> vsz: anObject [
	vsz := anObject
]
