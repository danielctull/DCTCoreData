/*
 NSManagedObjectContext+DCTAsynchronousDataFetching.h
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

#import <CoreData/CoreData.h>
#import "NSManagedObjectContext+DCTAsynchronousTasks.h"

@interface NSManagedObjectContext (DCTAsynchronousDataFetching)

#pragma mark -
#pragma mark Fetching Multiple Objects

- (void)dct_asynchronousObjectsForEntityName:(NSString *)entityName
							   callbackBlock:(DCTFetchRequestCallbackBlock)callbackBlock;

- (void)dct_asynchronousObjectsForEntityName:(NSString *)entityName
								   predicate:(NSPredicate *)predicate
							   callbackBlock:(DCTFetchRequestCallbackBlock)callbackBlock;

- (void)dct_asynchronousObjectsForEntityName:(NSString *)entityName
								   predicate:(NSPredicate *)predicate
							 sortDescriptors:(NSArray *)sortDescriptors
							   callbackBlock:(DCTFetchRequestCallbackBlock)callbackBlock;

- (void)dct_asynchronousObjectsForEntityName:(NSString *)entityName
							 sortDescriptors:(NSArray *)sortDescriptors
							   callbackBlock:(DCTFetchRequestCallbackBlock)callbackBlock;

- (void)dct_asynchronousObjectsForEntityName:(NSString *)entityName
								   predicate:(NSPredicate *)predicate
							 sortDescriptors:(NSArray *)sortDescriptors
								   batchSize:(NSUInteger)batchSize
							   callbackBlock:(DCTFetchRequestCallbackBlock)callbackBlock;

#pragma mark -
#pragma mark Fetching Single Objects

- (void)dct_asynchronousObjectForEntityName:(NSString *)entityName
							  callbackBlock:(DCTFetchRequestObjectCallbackBlock)callbackBlock;

- (void)dct_asynchronousObjectForEntityName:(NSString *)entityName
								  predicate:(NSPredicate *)predicate
							  callbackBlock:(DCTFetchRequestObjectCallbackBlock)callbackBlock;

- (void)dct_asynchronousObjectForEntityName:(NSString *)entityName
								  predicate:(NSPredicate *)predicate
							sortDescriptors:(NSArray *)sortDescriptors
							  callbackBlock:(DCTFetchRequestObjectCallbackBlock)callbackBlock;

- (void)dct_asynchronousObjectForEntityName:(NSString *)entityName
							sortDescriptors:(NSArray *)sortDescriptors
							  callbackBlock:(DCTFetchRequestObjectCallbackBlock)callbackBlock;

- (void)dct_asynchronousObjectForEntityName:(NSString *)entityName
								  predicate:(NSPredicate *)predicate 
							sortDescriptors:(NSArray *)sortDescriptors
								  batchSize:(NSUInteger)batchSize
							  callbackBlock:(DCTFetchRequestObjectCallbackBlock)callbackBlock;

@end
