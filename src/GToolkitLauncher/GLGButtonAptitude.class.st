Class {
	#name : #GLGButtonAptitude,
	#superclass : #BrGlamorousButtonRectangularAptitude,
	#category : #'GToolkitLauncher-GToolkitLauncher'
}

{ #category : #accessing }
GLGButtonAptitude >> initialize [
	| miniPadding tinyPadding smallPadding normalPadding largePadding hugePadding miniHeight tinyHeight smallHeight normalHeight largeHeight hugeHeight |
	super initialize.

	cornerRadius := cornerRadius ifNil: [ 4 ].
	paddingScale := paddingScale ifNil: [ 1.0 ].
	heightScale := heightScale ifNil: [ 1.0 ].
	
	miniPadding := 4 * paddingScale.
	tinyPadding := 6 * paddingScale.
	smallPadding := 6 * paddingScale.
	normalPadding := 8 * paddingScale.
	largePadding := 10 * paddingScale.
	hugePadding := 16 * paddingScale.
	
	miniHeight := 12 * heightScale.
	tinyHeight := 16 * heightScale.
	smallHeight := 20 * heightScale.
	normalHeight := 24 * heightScale.
	largeHeight := 30 * heightScale.
	hugeHeight := 48 * heightScale.

	self default geometry: (BlRoundedRectangleGeometry cornerRadius: cornerRadius).
	
	self add: (BrSizeAdjustmentAptitude new
		mini: [ :aStyle |
			aStyle
				vExact: miniHeight;
				padding: (BlInsets left: miniPadding right: miniPadding) ];
		tiny: [ :aStyle |
			aStyle
				vExact: tinyHeight;
				padding: (BlInsets left: tinyPadding right: tinyPadding) ];
		small: [ :aStyle | 
			aStyle
				vExact: smallHeight;
				padding: (BlInsets left: smallPadding right: smallPadding) ];
		normal: [ :aStyle | 
			aStyle
				vExact: normalHeight;
				padding: (BlInsets left: normalPadding right: normalPadding) ];
		large: [ :aStyle |
			aStyle
				vExact: largeHeight;
				padding: (BlInsets left: largePadding right: largePadding) ];
		huge: [ :aStyle |
			aStyle
				vExact: hugeHeight;
				padding: (BlInsets left: hugePadding right: hugePadding) ]).

	self add: BrGlamorousButtonLayoutAptitude new.
	self add: BrGlamorousButtonExteriorAptitude new.
	self add: BrGlamorousButtonIconAptitude new.
	self add: BrGlamorousButtonWithLabelTooltipAptitude new
]

{ #category : #accessing }
GLGButtonAptitude >> left [
	self default geometry: ( BlRoundedRectangleGeometry cornerRadii: (BlCornerRadii new
							topLeft: cornerRadius;
							topRight: 0;
							bottomLeft: cornerRadius;
							bottomRight: 0)).

]

{ #category : #accessing }
GLGButtonAptitude >> middle [
	self default geometry: ( BlRoundedRectangleGeometry cornerRadii: (BlCornerRadii new
							topLeft: 0;
							topRight: 0;
							bottomLeft: 0;
							bottomRight: 0)).
]

{ #category : #accessing }
GLGButtonAptitude >> right [
	self default geometry: ( BlRoundedRectangleGeometry cornerRadii: (BlCornerRadii new
							topLeft: 0;
							topRight: cornerRadius;
							bottomLeft: 0;
							bottomRight: cornerRadius)).

]
