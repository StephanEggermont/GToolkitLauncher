Class {
	#name : #GLGCard,
	#superclass : #BlElement,
	#category : #GToolkitLauncher
}

{ #category : #'as yet unclassified' }
GLGCard >> addContents [
	self addChild: self simpleTextField;
		addChild: self simpleTextField;
		addChild: self simpleTextList;
		addChild: self simpleTextField
]

{ #category : #'as yet unclassified' }
GLGCard >> editor [
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
GLGCard >> initialize [
	super initialize.
	self
		size: 120 @ 90;
		geometry: (BlRoundedRectangleGeometry cornerRadius: 3);
		background: Color lightGray muchLighter;
		border: (BlBorder paint: Color lightGray lighter width: 1);
		layout: BlLinearLayout vertical;
		margin: (BlInsets all: 6);
		padding: (BlInsets
				top: 2
				left: 2
				bottom: 2
				right: 2);
		aptitude: (BrGlamorousWithExplicitContextMenuAptitude
				handle: [ BlElement new
						size: 2 @ 2;
						geometry: BlEllipseGeometry new ]
				content: [ self editor ]);
		addContents
]

{ #category : #'as yet unclassified' }
GLGCard >> item [
	^self subclassResponsibility
]

{ #category : #'as yet unclassified' }
GLGCard >> run [
	self item run
]

{ #category : #'as yet unclassified' }
GLGCard >> showFolder [
	self item showFolder
]

{ #category : #'as yet unclassified' }
GLGCard >> simpleTextField [
	^ BrLabel new
		aptitude: BrGlamorousLabelAptitude new glamorousRegularFontAndSize;
		padding: (BlInsets left: 2);
		text: ''
]

{ #category : #'as yet unclassified' }
GLGCard >> simpleTextList [
	^ BrSimpleList new
		aptitude: BrSimpleListAptitude new;
		itemStencil: [ BrLabel new hMatchParent vFitContent beTinySize aptitude: BrGlamorousLabelAptitude ];
		padding: (BlInsets left: 2);
		itemDataBinder: [ :anItemElement :anItem | anItemElement text: anItem ];
		items: #()
]

{ #category : #'as yet unclassified' }
GLGCard >> stop [
	self item stop
]
