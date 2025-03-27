Class {
	#name : #GLGReleaseCardEditor,
	#superclass : #BrHorizontalGrid,
	#instVars : [
		'card'
	],
	#category : #GToolkitLauncher
}

{ #category : #'as yet unclassified' }
GLGReleaseCardEditor >> card: aReleaseCard [
	card := aReleaseCard.
	self updateContents
]

{ #category : #'as yet unclassified' }
GLGReleaseCardEditor >> initialize [
	| aContainer |
	super initialize.
	
	self hFitContent;
		vFitContentLimited;
		padding: (BlInsets all: 3).
		
	aContainer := BrVerticalPane new
		hFitContent;
		vFitContentLimited.
	aContainer addChild: (
			BrButton new
			beSmallSize;
			aptitude: (BrGlamorousButtonWithLabelAptitude new);
			margin: (BlInsets top: 10 left: 5 bottom: 5 right: 0);
			label: 'Show';
			action: [ 
				self fireEvent: BrContextMenuHideWish new.
				card showFolder ]).		
	aContainer addChild: (
			BrButton new
			beSmallSize;
			aptitude: (BrGlamorousButtonWithLabelAptitude new);
			margin: (BlInsets top: 10 left: 5 bottom: 5 right: 0);
			label: 'Run';
			action: [ 
				self fireEvent: BrContextMenuHideWish new.
				card run]).	
	self addChild: (BrScrollPane new
		aptitude: BrScrollPaneAptitude + BrGlamorousWithVerticalScrollbarAptitude;
		vFitContentLimited;
		hFitContent;
		content: aContainer)
]

{ #category : #'as yet unclassified' }
GLGReleaseCardEditor >> updateContents [
	(card background = Color green) ifTrue: [((self childAt: 1) childAt: 2) disable]
]
