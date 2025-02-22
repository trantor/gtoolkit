Extension { #name : #TAsyncStream }

{ #category : #'*GToolkit-Extensions' }
TAsyncStream >> gtCompositionChildren [

	^ #(  )
]

{ #category : #'*GToolkit-Extensions' }
TAsyncStream >> gtCompositionDescription [
	^ self printString
]

{ #category : #'*GToolkit-Extensions' }
TAsyncStream >> gtCompositionFor: aView [
	<gtView>

	^ aView columnedTree
		  title: 'Composition';
		  items: [ { self } ];
		  children: #gtCompositionChildren; 
		  expandAll;
		  column: 'Name' text: #gtCompositionDescription;
		  actionUpdateButtonTooltip: 'Update composition tree'
]

{ #category : #'*GToolkit-Extensions' }
TAsyncStream >> gtExecuteActionFor: anAction [
	<gtAction>
	
	^ anAction button
		icon: BrGlamorousVectorIcons playinspect;
		tooltip: 'Collect all values and inspect';
		priority: 10;
		action: [ :aButton | aButton phlow spawnObject: self asyncSimilarCopy toArray asAsyncPromise ]
]

{ #category : #'*GToolkit-Extensions' }
TAsyncStream >> gtLiveFor: aView [
	<gtView>

	^ aView columnedList
		title: 'Items';
		priority: 5;
		items: [ self asyncSimilarCopy ];
		column: 'Number' text: [ :_ :anIndex | anIndex ] width: 50;
		column: 'Name' text: #yourself;
		actionUpdateButton
]
