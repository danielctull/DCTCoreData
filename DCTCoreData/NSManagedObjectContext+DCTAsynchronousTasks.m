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
@end

@implementation NSManagedObjectContext (DCTAsynchronousTasks)

- (void)dct_asynchronousOperationWithBlock:(DCTManagedObjectContextBlock)block {
	
	if (![[NSThread currentThread] isEqual:[NSThread mainThread]])
		[[NSException exceptionWithName:@"DCTManagedObjectContextBackgroundingNotMainThreadException"
								 reason:@"Calling to perform a background operation on something which isn't the main thread." 
							   userInfo:nil] raise];
	
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

- (void)dctInternal_threadedContextDidSave:(NSNotification *)notification {
	[self setMergePolicy:NSMergeByPropertyStoreTrumpMergePolicy];
	[self mergeChangesFromContextDidSaveNotification:notification];
}

@end
