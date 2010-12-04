//
//  NSManagedObjectContext+DCTAsynchronousTasks.h
//  DCTCoreData
//
//  Created by Daniel Tull on 4.12.2010.
//  Copyright 2010 Daniel Tull. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DCTManagedObjectContextBlock) (NSManagedObjectContext *managedObjectContext);

@interface NSManagedObjectContext (DCTAsynchronousTasks)

- (void)dct_asynchronousOperationWithBlock:(DCTManagedObjectContextBlock)block;

- (void)dct_asynchronousOperationWithCallbackQueue:(dispatch_queue_t)queue
											 block:(DCTManagedObjectContextBlock)block;

@end
