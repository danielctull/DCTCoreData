/*
 NSManagedObjectContext+DCTAsynchronousTasks.m
 DCTCoreData
 
 Created by Daniel Tull on 4.12.2010.
 
 
 
 Copyright (C) 2010 Daniel Tull. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 * Neither the name of the author nor the names of its contributors may be used
 to endorse or promote products derived from this software without specific
 prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "NSManagedObjectContext+DCTAsynchronousTasks.h"
#import "NSManagedObjectContext+DCTExtras.h"

@interface NSManagedObjectContext ()
- (void)dctInternal_threadedContextDidSave:(NSNotification *)notification;
- (BOOL)dctInternal_raiseExceptionIfNotMainThread;
@end

@implementation NSManagedObjectContext (DCTAsynchronousTasks)

#pragma mark -
#pragma mark Modification methods


- (void)dct_asynchronousTaskWithWorkBlock:(DCTManagedObjectContextBlock)workBlock {
	[self dct_asynchronousTaskWithWorkBlock:workBlock completionBlock:nil];
}




- (void)dct_asynchronousTaskWithWorkBlock:(DCTManagedObjectContextBlock)workBlock
						  completionBlock:(DCTManagedObjectContextBlock)completionBlock {
	
	if ([self dctInternal_raiseExceptionIfNotMainThread]) return;
	
	[self dct_asynchronousTaskWithCallbackQueue:dispatch_get_main_queue() workBlock:workBlock completionBlock:completionBlock];
}




- (void)dct_asynchronousTaskWithCallbackQueue:(dispatch_queue_t)queue
									workBlock:(DCTManagedObjectContextBlock)workBlock {
	
	[self dct_asynchronousTaskWithCallbackQueue:queue workBlock:workBlock completionBlock:nil];
}




- (void)dct_asynchronousTaskWithCallbackQueue:(dispatch_queue_t)queue
									workBlock:(DCTManagedObjectContextBlock)workBlock
							  completionBlock:(DCTManagedObjectContextBlock)completionBlock {
	
	[self dct_asynchronousTaskWithObject:nil
						   callbackQueue:queue
							   workBlock:^(NSManagedObjectContext *moc, id mo) {
								   workBlock(moc);
								   
							   } completionBlock:^{
								   completionBlock(self);
							   }];
}

#pragma mark -
#pragma mark Modification methods with object

- (void)dct_asynchronousTaskWithObject:(NSManagedObject *)object
							 workBlock:(DCTManagedObjectContextObjectBlock)workBlock {
	
	[self dct_asynchronousTaskWithObject:object
							   workBlock:workBlock
						 completionBlock:nil];
}

- (void)dct_asynchronousTaskWithObject:(NSManagedObject *)object
							 workBlock:(DCTManagedObjectContextObjectBlock)workBlock
					   completionBlock:(DCTManagedObjectContextCompletionBlock)completionBlock {
	
	if ([self dctInternal_raiseExceptionIfNotMainThread]) return;
	
	[self dct_asynchronousTaskWithObject:object
						   callbackQueue:dispatch_get_main_queue()
							   workBlock:workBlock
						 completionBlock:completionBlock];
}

- (void)dct_asynchronousTaskWithObject:(NSManagedObject *)object
						 callbackQueue:(dispatch_queue_t)queue
							 workBlock:(DCTManagedObjectContextObjectBlock)workBlock {
	
	[self dct_asynchronousTaskWithObject:object
						   callbackQueue:queue
							   workBlock:workBlock
						 completionBlock:nil];
}

- (void)dct_asynchronousTaskWithObject:(NSManagedObject *)object
						 callbackQueue:(dispatch_queue_t)queue
							 workBlock:(DCTManagedObjectContextObjectBlock)workBlock
					   completionBlock:(DCTManagedObjectContextCompletionBlock)completionBlock {
	
	
	NSArray *array = nil;
	if (object) array = [NSArray arrayWithObject:object];
	
	[self dct_asynchronousTaskWithObjects:array
							callbackQueue:queue
								workBlock:^(NSManagedObjectContext *managedObjectContext, NSArray *managedObjects) {
									
									workBlock(managedObjectContext, [managedObjects objectAtIndex:0]);
									
								} completionBlock:completionBlock];
}



#pragma mark - 
#pragma mark Modification methods with objects


- (void)dct_asynchronousTaskWithObjects:(NSArray *)objects
							  workBlock:(DCTManagedObjectContextObjectsBlock)workBlock {
	
	[self dct_asynchronousTaskWithObjects:objects
								workBlock:workBlock
						  completionBlock:nil];
}

- (void)dct_asynchronousTaskWithObjects:(NSArray *)objects
							  workBlock:(DCTManagedObjectContextObjectsBlock)workBlock
						completionBlock:(DCTManagedObjectContextCompletionBlock)completionBlock {
	
	if ([self dctInternal_raiseExceptionIfNotMainThread]) return;
	
	[self dct_asynchronousTaskWithObjects:objects
							callbackQueue:dispatch_get_main_queue()
								workBlock:workBlock
						  completionBlock:completionBlock];
}

- (void)dct_asynchronousTaskWithObjects:(NSArray *)objects
						  callbackQueue:(dispatch_queue_t)queue
							  workBlock:(DCTManagedObjectContextObjectsBlock)workBlock {
	
	[self dct_asynchronousTaskWithObjects:objects
							callbackQueue:queue
								workBlock:workBlock
						  completionBlock:nil];
}

- (void)dct_asynchronousTaskWithObjects:(NSArray *)objects
						  callbackQueue:(dispatch_queue_t)queue
							  workBlock:(DCTManagedObjectContextObjectsBlock)workBlock
						completionBlock:(DCTManagedObjectContextCompletionBlock)completionBlock {
	
	NSMutableArray *objectIDs = nil;
	
	if (objects) {
		objectIDs = [NSMutableArray arrayWithCapacity:[objects count]];
		for (NSManagedObject *mo in objects)
			[objectIDs addObject:[mo objectID]];
	}
	
	NSManagedObjectContext *threadedContext = [[NSManagedObjectContext alloc] init];
	[threadedContext setPersistentStoreCoordinator:[self persistentStoreCoordinator]];
	
	dispatch_queue_t asyncQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	
	dispatch_async(asyncQueue, ^{
		
		NSArray *threadedObjects = nil;
		if (objectIDs) {
			NSMutableArray *array = [NSMutableArray arrayWithCapacity:[objectIDs count]];
			for (NSManagedObjectID *objectID in objectIDs)			
				[array addObject:[threadedContext objectWithID:objectID]];
			
			threadedObjects = [NSArray arrayWithArray:array];
		}
		
		workBlock(threadedContext, threadedObjects);
		
		dispatch_async(queue, ^{
			
			NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
			
			[defaultCenter addObserver:self 
							  selector:@selector(dctInternal_threadedContextDidSave:)
								  name:NSManagedObjectContextDidSaveNotification
								object:threadedContext];
			
			if ([threadedContext hasChanges]) [threadedContext save:NULL];
			
			[defaultCenter removeObserver:self
									 name:NSManagedObjectContextDidSaveNotification
								   object:threadedContext];
			
			
			completionBlock();
		});		
	});	
	
}

#pragma mark -
#pragma mark Fetch methods

- (void)dct_asynchronousFetchRequest:(NSFetchRequest *)fetchRequest
				   withCallbackBlock:(DCTFetchRequestCallbackBlock)callbackBlock {
	
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
			
			for (NSManagedObjectID *objectID in objectIDs)		
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
