Class {
	#name : #BaselineOfGToolkitLauncher,
	#superclass : #BaselineOf,
	#category : #BaselineOfGToolkitLauncher
}

{ #category : #'as yet unclassified' }
BaselineOfGToolkitLauncher >> baseline: spec [
	<baseline>
	spec for: #common do: [ 
		spec package: 'GToolkitLauncher'].
]

{ #category : #'as yet unclassified' }
BaselineOfGToolkitLauncher >> loadLepiter [
	IceRepository registry  
		detect: [ :aRepository |
			aRepository name = 'GToolkitLauncher' ]
		ifFound: [ :aRepository | 
			| defaultDatabase currentProperties |
			defaultDatabase := LeDatabasesRegistry defaultLogicalDatabase.
			currentProperties := defaultDatabase properties.
			currentProperties addRegisteredDirectory: aRepository repositoryDirectory / 'lepiter'.
			defaultDatabase reload ]
		ifNone: [
			self inform: 'Repository not found.' ]
]
