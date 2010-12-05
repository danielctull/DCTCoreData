/*
 NSManagedObjectContext+DCTAsynchronousTasks.h
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

#import <Foundation/Foundation.h>

typedef void (^DCTManagedObjectContextBlock) (NSManagedObjectContext *managedObjectContext);
typedef void (^DCTFetchRequestCallbackBlock) (NSArray *fetchedObjects, NSError *error);
typedef void (^DCTFetchRequestObjectCallbackBlock) (id fetchedObject, NSError *error);

@interface NSManagedObjectContext (DCTAsynchronousTasks)

- (void)dct_asynchronousTaskWithWorkBlock:(DCTManagedObjectContextBlock)workBlock;

- (void)dct_asynchronousTaskWithWorkBlock:(DCTManagedObjectContextBlock)workBlock
						  completionBlock:(DCTManagedObjectContextBlock)completionBlock;

- (void)dct_asynchronousTaskWithCallbackQueue:(dispatch_queue_t)queue
									workBlock:(DCTManagedObjectContextBlock)workBlock;

- (void)dct_asynchronousTaskWithCallbackQueue:(dispatch_queue_t)queue
									workBlock:(DCTManagedObjectContextBlock)workBlock
							  completionBlock:(DCTManagedObjectContextBlock)completionBlock;

- (void)dct_asynchronousFetchRequest:(NSFetchRequest *)fetchRequest
				   withCallbackBlock:(DCTFetchRequestCallbackBlock)callbackBlock;

- (void)dct_asynchronousFetchRequest:(NSFetchRequest *)fetchRequest
				   withCallbackQueue:(dispatch_queue_t)callbackQueue
							   block:(DCTFetchRequestCallbackBlock)callbackBlock;

@end
