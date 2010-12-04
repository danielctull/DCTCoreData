//
//  NSManagedObjectContext+DCTAsynchronousTasks.h
//  DCTCoreData
//
//  Created by Daniel Tull on 4.12.2010.
//  Copyright 2010 Daniel Tull. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DCTManagedObjectContextBlock) (NSManagedObjectContext *managedObjectContext);
typedef void (^DCTFetchRequestCallbackBlock) (NSArray *fetchedObjects, NSError *error);

@interface NSManagedObjectContext (DCTAsynchronousTasks)

- (void)dct_asynchronousOperationWithBlock:(DCTManagedObjectContextBlock)block;
- (void)dct_asynchronousOperationWithCallbackQueue:(dispatch_queue_t)queue
											 block:(DCTManagedObjectContextBlock)block;

- (void)dct_asynchronousFetch:(NSFetchRequest *)fetchRequest
			WithCallbackBlock:(DCTFetchRequestCallbackBlock)callbackBlock;

- (void)dct_asynchronousFetchRequest:(NSFetchRequest *)fetchRequest
				   withCallbackQueue:(dispatch_queue_t)callbackQueue
							   block:(DCTFetchRequestCallbackBlock)callbackBlock;

@end
