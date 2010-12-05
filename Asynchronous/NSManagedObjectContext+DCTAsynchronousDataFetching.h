//
//  NSManagedObjectContext+DCTAsynchronousDataFetching.h
//  DCTCoreData
//
//  Created by Daniel Tull on 4.12.2010.
//  Copyright 2010 Daniel Tull. All rights reserved.
//

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
