Class {
	#name : #GtPharoExampleSuiteMediatorSignal,
	#superclass : #BeaconSignal,
	#instVars : [
		'medator'
	],
	#category : #'GToolkit-Extensions-Examples'
}

{ #category : #accessing }
GtPharoExampleSuiteMediatorSignal >> id [
	^ self mediator ifNotNil: #identityHash
]

{ #category : #accessing }
GtPharoExampleSuiteMediatorSignal >> mediator [

	^ medator
]

{ #category : #accessing }
GtPharoExampleSuiteMediatorSignal >> mediator: anObject [

	medator := anObject
]

{ #category : #accessing }
GtPharoExampleSuiteMediatorSignal >> mediatorLabel [
	^ self mediator ifNil: [ '' ] ifNotNil: [ self mediator mediatorLabel ]
]

{ #category : #printing }
GtPharoExampleSuiteMediatorSignal >> printOneLineCommunicatorId: aStream [
	self mediator ifNil: [ ^ self ].
	aStream
		nextPutAll: self mediatorLabel;
		nextPutAll: '-ID: ';
		print: self id
]
