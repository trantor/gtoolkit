Class {
	#name : #GtProfilerCompositionLayers,
	#superclass : #BrVerticalPane,
	#instVars : [
		'profiledSpace',
		'toolbar',
		'updateButton'
	],
	#category : 'GToolkit-Profiler'
}

{ #category : #initialization }
GtProfilerCompositionLayers >> initialize [
	super initialize.
	
	self matchParent.
	self alignTopCenter.
	self padding: (BlInsets all: 10).
	
	self when: BlMouseWheelEvent do: [ :anEvent |
		self
			childNamed: #compositionLayer
			ifFound: [ :aPannableElement |
				anEvent isScrollDown
					ifTrue: [ aPannableElement zoomIn ].
				anEvent isScrollUp
					ifTrue: [ aPannableElement zoomOut ] ]
			ifNone: [  ] ].
	
	toolbar := BrToolbar new
		aptitude: BrGlamorousToolbarAptitude new.
	
	updateButton := BrButton new
		disable;
		aptitude: BrGlamorousButtonWithLabelAptitude new;
		beSmallSize;
		label: 'Render';
		action: [ :aButton | self updateLayer ].
		
	toolbar addItems: { updateButton }.
	
	self addChild: toolbar.
]

{ #category : #accessing }
GtProfilerCompositionLayers >> profileSpace: anOpenedSpace [
	profiledSpace = anOpenedSpace
		ifTrue: [ ^ self ].

	profiledSpace := anOpenedSpace.
	self removeChildNamed: #compositionLayer.
	updateButton enable
]

{ #category : #accessing }
GtProfilerCompositionLayers >> profiledSpace [
	^ profiledSpace
]

{ #category : #accessing }
GtProfilerCompositionLayers >> profiledSpace: anObject [
	profiledSpace := anObject.
]

{ #category : #private }
GtProfilerCompositionLayers >> updateLayer [
	self removeChildNamed: #compositionLayerContainer.
	
	updateButton disable.

	profiledSpace space enqueueTask: (BlTaskAction new action: [
		| aLayer |
		aLayer := BlCompositionPainter repaintSpace: profiledSpace space.

		(aLayer gtTreeFor: GtPhlowEmptyView new)
			asElementDo: [ :anElement | self enqueueTask: (BlTaskAction new action: [
				self addChild: anElement as: #compositionLayerContainer.
				anElement children first
					containerName: #compositionLayer;
					zoomStep: 0.05.
				updateButton enable ]) ] ]).
]
