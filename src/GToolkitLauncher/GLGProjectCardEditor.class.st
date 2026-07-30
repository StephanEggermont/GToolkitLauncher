Class {
	#name : #GLGProjectCardEditor,
	#superclass : #BrHorizontalGrid,
	#instVars : [
		'card'
	],
	#category : #GToolkitLauncher
}

{ #category : #'as yet unclassified' }
GLGProjectCardEditor >> card: aProjectCard [
	card := aProjectCard.
	self updateContents

]

{ #category : #'as yet unclassified' }
GLGProjectCardEditor >> editScriptButton [
	^ BrButton new
		beSmallSize;
		aptitude: BrGlamorousButtonWithLabelAptitude new;
		margin: (BlInsets
				top: 5
				left: 5
				bottom: 5
				right: 5);
		label: 'Edit Script';
		action: [ self fireEvent: BrContextMenuHideWish new.
			card editScript ]

]

{ #category : #'as yet unclassified' }
GLGProjectCardEditor >> initialize [
	| aContainer |
	super initialize.
 
	self
		hFitContent;
		vFitContentLimited;
		geometry: (BlRoundedRectangleGeometry cornerRadius: 3);
		padding: (BlInsets all: 3).
 
	aContainer := BrVerticalPane new
			hFitContent;
			vFitContentLimited;
			geometry: (BlRoundedRectangleGeometry cornerRadius: 3);
			background: Color white;
			border: (BlBorder paint: Color lightGray width: 1).
	aContainer addChild: self showFolderButton.
	aContainer addChild: self editScriptButton.
	self
		addChild: (BrScrollPane new
				aptitude: BrScrollPaneAptitude + BrGlamorousWithVerticalScrollbarAptitude;
				vFitContentLimited;
				hFitContent;
				content: aContainer)

]

{ #category : #'as yet unclassified' }
GLGProjectCardEditor >> showFolderButton [
	^ BrButton new
		beSmallSize;
		aptitude: BrGlamorousButtonWithLabelAptitude new;
		margin: (BlInsets
				top: 10
				left: 5
				bottom: 5
				right: 5);
		label: 'Show';
		action: [ self fireEvent: BrContextMenuHideWish new.
			card showFolder ]

]

{ #category : #'as yet unclassified' }
GLGProjectCardEditor >> updateContents [
]
