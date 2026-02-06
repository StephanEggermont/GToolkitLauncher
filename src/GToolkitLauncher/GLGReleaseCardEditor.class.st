Class {
	#name : 'GLGReleaseCardEditor',
	#superclass : 'BrHorizontalGrid',
	#instVars : [
		'card'
	],
	#category : 'GToolkitLauncher',
	#package : 'GToolkitLauncher'
}

{ #category : 'as yet unclassified' }
GLGReleaseCardEditor >> card: aReleaseCard [
	card := aReleaseCard.
	self updateContents
]

{ #category : 'as yet unclassified' }
GLGReleaseCardEditor >> initialize [
	| aContainer |
	super initialize.
	
	self hFitContent;
		vFitContentLimited;
		geometry: (BlRoundedRectangleGeometry cornerRadius: 3);
		padding: (BlInsets all: 3).
		
	aContainer := BrVerticalPane new
		hFitContent;
		vFitContentLimited;
		geometry: (BlRoundedRectangleGeometry cornerRadius: 3);
		background: Color white;
		border: (BlBorder paint: Color lightGray width: 1).
	aContainer addChild: (
			BrButton new
			beSmallSize;
			aptitude: (BrGlamorousButtonWithLabelAptitude new);
			margin: (BlInsets top: 10 left: 5 bottom: 5 right: 5);
			label: 'Show';
			action: [ 
				self fireEvent: BrContextMenuHideWish new.
				card showFolder ]).		
	aContainer addChild: (
			BrButton new
			beSmallSize;
			aptitude: (BrGlamorousButtonWithLabelAptitude new);
			margin: (BlInsets top: 5 left: 5 bottom: 5 right: 5);
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

{ #category : 'as yet unclassified' }
GLGReleaseCardEditor >> updateContents [
	(card background = Color green) ifTrue: [((self childAt: 1) childAt: 2) disable]
]
