Class {
	#name : #GLGLauncherStartup,
	#superclass : #Object,
	#category : #GToolkitLauncher
}

{ #category : #'as yet unclassified' }
GLGLauncherStartup class >> initialize [
	SessionManager default addDeferredStartupAction: [
		GLGToolkitLauncher allInstances do: [:aLauncher |
			aLauncher model ifNotNil: [
			aLauncher pane ifNotNil: [:pa | pa isVisible ifTrue: [aLauncher updateReleases]]]]
	]
]
