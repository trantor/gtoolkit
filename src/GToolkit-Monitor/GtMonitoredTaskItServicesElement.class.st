Class {
	#name : #GtMonitoredTaskItServicesElement,
	#superclass : #GtMonitoredServicesElement,
	#category : 'GToolkit-Monitor'
}

{ #category : #'instance creation' }
GtMonitoredTaskItServicesElement class >> open [
	<script: 'self open'>
	GtInspector openOn: self new
]

{ #category : #initialization }
GtMonitoredTaskItServicesElement >> initializeServiceListDefinition [

	servicesList column
		title: 'Service';
		weight: 1;
		stencil: [ :aMonitoredService |
			| aTitle |
			
			aTitle := aMonitoredService title.
			aTitle ifEmpty: [ aTitle := '[No name]' asRopedText italic ].
			
			BrLabel new
				aptitude: BrGlamorousLabelAptitude;
				text: aTitle;
				fitContent ].

	servicesList column
		title: 'Running';
		width: 100;
		stencil: [ :aMonitoredService |
			| isOpened |

			isOpened := aMonitoredService exists
				ifTrue: [ aMonitoredService isRunning
					ifTrue: [ 'Running' asRopedText bold ]
					ifFalse: [ 'Inactive' asRopedText ] ]
				ifFalse: [ '~Garbage collected~' asRopedText italic foreground: Color gray ].
			
			BrLabel new
				aptitude: BrGlamorousLabelAptitude;
				text: isOpened;
				fitContent ].
			
	servicesList column
		title: 'Queue';
		width: 30;
		stencil: [ :aMonitoredService |
			| aQueueSize |
			aQueueSize := aMonitoredService queueSize.
			aQueueSize := aQueueSize isZero 
				ifTrue: [ '0' asRopedText foreground: Color gray ]
				ifFalse: [ aQueueSize asString asRopedText ].
			
			BrLabel new
				aptitude: BrGlamorousLabelAptitude;
				text: aQueueSize;
				fitContent ].
			
	servicesList column
		title: 'Errors';
		width: 30;
		stencil: [ :aMonitoredService |
			| aNumberOfFailedTasks |
			aNumberOfFailedTasks := aMonitoredService numberOfFailedTasks.
			aNumberOfFailedTasks := aNumberOfFailedTasks isZero 
				ifTrue: [ '' asRopedText ]
				ifFalse: [ 
					(aNumberOfFailedTasks asString, 
						(' failure' asPluralBasedOn: aNumberOfFailedTasks))
					 		asRopedText foreground: Color red ].
			
			BrLabel new
				aptitude: BrGlamorousLabelAptitude;
				text: aNumberOfFailedTasks;
				fitContent ].
]

{ #category : #initialization }
GtMonitoredTaskItServicesElement >> onClickTransformation [
	^ [ :aMonitoredService | aMonitoredService service ifNil: [ aMonitoredService ] ]
]

{ #category : #updating }
GtMonitoredTaskItServicesElement >> retreiveNewServiceList [
	| allServices |
	allServices := TKTConfiguration serviceManager services copy.
	allServices := allServices collect: [ :eachService | GtMonitoredTaskItService new service: eachService ].
	allServices := allServices sorted: [ :a :b | a title < b title ].
	^ allServices 
]

{ #category : #updating }
GtMonitoredTaskItServicesElement >> updateTaskName [
	^ '[Monitor] TaskIt Services Update Task'
]
