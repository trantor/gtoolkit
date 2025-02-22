Extension { #name : #Announcer }

{ #category : #'*GToolkit-Extensions' }
Announcer >> gtSubscriptionsPerSubscriberFor: aView [
	<gtView>
	self subscriptions ifNil: [ ^ aView empty ].
	^ aView columnedTree
		title: 'Per Subscriber';
		priority: 51;
		items: [ GtSubscriptionSubscriber fromAnnouncer: self ];
		children: [ :each | 
			(each isKindOf: GtSubscriptionSubscriber)
				ifTrue: [ each subscriptions ]
				ifFalse: [ Array empty ] ];
		actionUpdateButtonTooltip: 'Update subscription list';
		column: 'Subscriber' text: [ :aSubscription | 
			(aSubscription isKindOf: GtSubscriptionSubscriber)
				ifTrue: [ aSubscription subscriber ]
				ifFalse: [ '' ] ];
		column: 'Announcement' text: [ :aSubscription |
			(aSubscription isKindOf: GtSubscriptionSubscriber)
				ifTrue: [ '' ]
				ifFalse: [ aSubscription announcementClass ] ];
		column: 'Kind' text: [ :aSubscription | 
			(aSubscription isKindOf: GtSubscriptionSubscriber)
				ifTrue: [ '' ]
				ifFalse: [ aSubscription class ] ];
		send: [ :aSubscription | 
			(aSubscription isKindOf: GtSubscriptionSubscriber)
				ifTrue: [ aSubscription subscriber ]
				ifFalse: [ aSubscription ] ]
]
