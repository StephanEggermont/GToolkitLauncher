Class {
	#name : #GLGMac,
	#superclass : #GLGPlatform,
	#category : #GToolkitLauncher
}

{ #category : #accessing }
GLGMac >> platformName [
	^'OSX'
]

{ #category : #accessing }
GLGMac >> runCommand [
	^'./GlamorousToolkit.app/Contents/MacOS/GlamorousToolkit GlamorousToolkit.image --no-quit --interactive &'
]
