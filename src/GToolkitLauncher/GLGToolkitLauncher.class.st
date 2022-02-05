"
I am the entry point for the GToolkit Launcher.
"
Class {
	#name : #GLGToolkitLauncher,
	#superclass : #Object,
	#category : #GToolkitLauncher
}

{ #category : #accessing }
GLGToolkitLauncher class >> open [
	^self new open
]

{ #category : #accessing }
GLGToolkitLauncher >> open [
	|space|
	space := BlSpace new.
	space title: 'GToolkit Launcher'.
	space show
]
