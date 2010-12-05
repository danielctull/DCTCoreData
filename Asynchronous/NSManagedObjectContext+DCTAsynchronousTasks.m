//
//  NSManagedObjectContext+DCTAsynchronousTasks.m
//  DCTCoreData
//
//  Created by Daniel Tull on 4.12.2010.
//  Copyright 2010 Daniel Tull. All rights reserved.
//

#import "NSManagedObjectContext+DCTAsynchronousTasks.h"
#import "NSManagedObjectContext+DCTExtras.h"

@interface NSManagedObjectContext ()
- (void)dctInternal_threadedContextDidSave:(NSNotification *)notification;
- (BOOL)dctInternal_raiseExceptionIfNotMainThread;
@end

@implementation NSManagedObjectContext (DCTAsynchronousTasks)

#pragma mark -
#pragma mark Modification methods

- (void)dct_asynchronousOperationWithBlock:(DCTManagedObjectContextBlock)block {
	
	if ([self dctInternal_raiseExceptionIfNotMainThread]) return;
	
	[self dct_asynchronousOperationWithCallbackQueue:dispatch_get_main_queue() block:block];
}

- (void)dct_asynchronousOperationWithCallbackQueue:(dispatch_queue_t)queue
											 block:(DCTManagedObjectContextBlock)block {
	
	NSManagedObjectContext *threadedContext = [[NSManagedObjectContext alloc] init];
	[threadedContext setPersistentStoreCoordinator:[self persistentStoreCoordinator]];
	
	dispatch_queue_t asyncQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	
	dispatch_async(asyncQueue, ^{
		
		block(threadedContext);
		
		dispatch_async(queue, ^{
			
			NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
			
			[defaultCenter addObserver:self 
							  selector:@selector(dctInternal_threadedContextDidSave:)
								  name:NSManagedObjectContextDidSaveNotification
								object:threadedContext];
			
			if ([threadedContext hasChanges]) [threadedContext save];
			
			[defaultCenter removeObserver:self
									 name:NSManagedObjectContextDidSaveNotification
								   object:threadedContext];
			
			[threadedContext release];
		});		
	});
}

#pragma mark -
#pragma mark Fetch methods

- (void)dct_asynchronousFetch:(NSFetchRequest *)fetchRequest
			WithCallbackBlock:(DCTFetchRequestCallbackBlock)callbackBlock {
	
	if ([self dctInternal_raiseExceptionIfNotMainThread]) return;
	
	[self dct_asynchronousFetchRequest:fetchRequest 
					 withCallbackQueue:dispatch_get_main_queue()
								 block:callbackBlock];
}

- (void)dct_asynchronousFetchRequest:(NSFetchRequest *)fetchRequest
				   withCallbackQueue:(dispatch_queue_t)callbackQueue
							   block:(DCTFetchRequestCallbackBlock)callbackBlock {
	
	NSManagedObjectContext *threadedContext = [[NSManagedObjectContext alloc] init];
	[threadedContext setPersistentStoreCoordinator:[self persistentStoreCoordinator]];
	
	dispatch_queue_t asyncQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	
	dispatch_async(asyncQueue, ^{
		
		NSError *error = nil;
		NSArray *array = [threadedContext executeFetchRequest:fetchRequest error:&error];
		
		NSMutableArray *objectIDs = [NSMutableArray arrayWithCapacity:[array count]];
		
		for (NSManagedObject *mo in array)
			[objectIDs addObject:[mo objectID]];
		
		
		dispatch_async(callbackQueue, ^{
			
			NSMutableArray *returnedObjects = [NSMutableArray arrayWithCapacity:[objectIDs count]];
			
			for (NSManagedObjectID *objectID in array)		
				[returnedObjects addObject:[self objectWithID:objectID]];
			
			callbackBlock([NSArray arrayWithArray:returnedObjects], error);
		});
			
	});	
	
}

#pragma mark -
#pragma mark Internal methods

- (BOOL)dctInternal_raiseExceptionIfNotMainThread {
	if (![[NSThread currentThread] isEqual:[NSThread mainThread]]) {
		[[NSException exceptionWithName:@"DCTManagedObjectContextBackgroundingNotMainThreadException"
								 reason:@"Calling to perform a background operation on something which isn't the main thread." 
							   userInfo:nil] raise];
		return YES;
	}
	
	return NO;	
}

- (void)dctInternal_threadedContextDidSave:(NSNotification *)notification {
	[self setMergePolicy:NSMergeByPropertyStoreTrumpMergePolicy];
	[self mergeChangesFromContextDidSaveNotification:notification];
}

@end
