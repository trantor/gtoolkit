Class {
	#name : #GtHome,
	#superclass : #BlElement,
	#instVars : [
		'sectionsHolder',
		'feedElement',
		'notificationsElement',
		'knowledgeBase'
	],
	#category : #'GToolkit-World-UI'
}

{ #category : #updating }
GtHome >> clearKnowledgeBase [
	knowledgeBase := nil
]

{ #category : #accessing }
GtHome >> collectHomeSectionStencils [
	^ GtHomeSectionsCollector new
		fromObject: self;
		collect
]

{ #category : #building }
GtHome >> createSectionWrapperFor: aSectionStencil [
	^ BrAsyncWidget new
			margin: (BlInsets all: self spaceGap);
			layout: BlFrameLayout new;
			constraintsDo: [ :c |
				c vertical exact: 100.
				c horizontal matchParent ];
			postAction: [ :theLazyElement | theLazyElement constraintsDo: [ :c | 
				c vertical fitContent ] ];
			stencil: aSectionStencil
]

{ #category : #building }
GtHome >> createSectionsHolder [
	^ BrVerticalPane new
		hMatchParent;
		vFitContent
]

{ #category : #building }
GtHome >> createVersionLabel [
	^ BrButton new 
		label: 'Glamorous Toolkit ', GtImage instance version versionString; 
		beSmallSize;
		aptitude: (BrGlamorousButtonWithLabelAptitude new + (BrGlamorousButtonExteriorAptitude new borderPaint: Color transparent; backgroundPaint: Color transparent));
		margin: (BlInsets all: 5);
		constraintsDo: [ :c | c linear horizontal alignRight ];
		action: [ :button | 
			| database startPage |
			database := LeDatabasesRegistry default currentLoadedDefaultLogicalDatabase 
				databaseNamed: 'Glamorous Toolkit Book'.
			startPage := database pageNamed: 'About this Version of Glamorous Toolkit'.
			GtWorldUtility 
				showSpaceWithTitle: startPage title
				inPagerWith: [ startPage
					asLepiterPagePhlowTool asElementDo: [ :e | e ] ] asStencil
				from: button ]
]

{ #category : #sections }
GtHome >> getStartedSection [
	<gtHomeSection>
	^ GtHomeGetStartedSection new
		priority: 15
]

{ #category : #ui }
GtHome >> gtViewHomeSectionsFor: aView [
	<gtView>
	^ aView list 
		title: 'Section Stencils';
		items: [ self collectHomeSectionStencils ]
]

{ #category : #initialization }
GtHome >> initialize [
	super initialize.
	self background: self theme default backdropColor.
	self
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	self layout: BlLinearLayout vertical.
	self initializePanes.
	self updateWidget
]

{ #category : #initialization }
GtHome >> initializePanes [
	| mainPane sectionsPane |
	notificationsElement := GtHomeNotifications new
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ].
	
	mainPane := BlElement new 
		layout: BlLinearLayout horizontal;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ];
		padding: (BlInsets top: 0 left: 0 bottom: 0 right: self spaceGap).
	sectionsPane := BlElement new 
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ].

	"feedElement := GtHomeFeed new.
	feedElement constraintsDo: [ :c |
			c horizontal fitContent.
			c vertical fitContent ]."
	
	sectionsHolder := self createSectionsHolder.
	sectionsPane addChild: notificationsElement.
	sectionsPane addChild: sectionsHolder.
	mainPane addChild: (self toolsSection create margin: (BlInsets top: self spaceGap left: self spaceGap bottom: self spaceGap * 2 right: self spaceGap * 2)).
	mainPane addChild: sectionsPane.
	"mainPane addChild: feedElement."
	
	self addChild: (BrScrollPane new
		aptitude: BrScrollPaneAptitude + BrGlamorousWithVerticalScrollbarAptitude;
		content: mainPane).
	self addChild: self createVersionLabel.
]

{ #category : #accessing }
GtHome >> knowledgeBase [
	^ knowledgeBase
]

{ #category : #accessing }
GtHome >> knowledgeBase: aKnowledgeBase [
	knowledgeBase := aKnowledgeBase
]

{ #category : #updating }
GtHome >> prepareForRelease [ 
	notificationsElement clearContent.
	"feedElement ifNotNil: #clearContent"
]

{ #category : #updating }
GtHome >> refreshNotifications [
	"Update the notifications and content of the home screen that can potentially changed 
	based on local user preferences."
	self updateNotifications.
	self updateFeed.
]

{ #category : #accessing }
GtHome >> spaceGap [
	^ 10
]

{ #category : #sections }
GtHome >> toolsSection [
"	<gtHomeSection>"
	^ GtHomeToolsSection new
		priority: 10;
		knowledgeBaseComputation: [ self knowledgeBase ]
]

{ #category : #updating }
GtHome >> update: anAnnouncement [
	anAnnouncement classAffected == self class
		ifFalse: [ ^ self ].

	self updateWidget.
]

{ #category : #updating }
GtHome >> updateFeed [
	feedElement ifNotNil: #updateWidget
]

{ #category : #updating }
GtHome >> updateNotifications [
	notificationsElement ifNotNil: [  
		notificationsElement updateWidget ]
]

{ #category : #updating }
GtHome >> updateSections [
	| sectionElements sectionStencils |
	sectionsHolder ifNil:  [ ^ self ].
	sectionsHolder removeChildren.
	sectionStencils := self collectHomeSectionStencils.
	sectionElements := sectionStencils collect: [ :eachStencil |
		self createSectionWrapperFor: eachStencil ].
	sectionsHolder addChildren: sectionElements.
]

{ #category : #updating }
GtHome >> updateWidget [
	self updateNotifications.
	self updateSections.
	self updateFeed.
]
