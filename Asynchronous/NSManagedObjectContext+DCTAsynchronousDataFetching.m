//
//  NSManagedObjectContext+DCTAsynchronousDataFetching.m
//  DCTCoreData
//
//  Created by Daniel Tull on 4.12.2010.
//  Copyright 2010 Daniel Tull. All rights reserved.
//

#import "NSManagedObjectContext+DCTAsynchronousDataFetching.h"
#import "NSFetchRequest+DCTInitMethods.h"

@implementation NSManagedObjectContext (DCTAsynchronousDataFetching)

#pragma mark -
#pragma mark Fetching Multiple Objects

- (void)dct_asynchronousObjectsForEntityName:(NSString *)entityName
							   callbackBlock:(DCTFetchRequestCallbackBlock)callbackBlock {

	[self dct_asynchronousObjectsForEntityName:entityName
									 predicate:nil
							   sortDescriptors:nil
									 batchSize:DCTFetchBatchSizeNil
								 callbackBlock:callbackBlock];
}

- (void)dct_asynchronousObjectsForEntityName:(NSString *)entityName
								   predicate:(NSPredicate *)predicate
							   callbackBlock:(DCTFetchRequestCallbackBlock)callbackBlock {
	
	[self dct_asynchronousObjectsForEntityName:entityName
									 predicate:predicate
							   sortDescriptors:nil
									 batchSize:DCTFetchBatchSizeNil
								 callbackBlock:callbackBlock];
}

- (void)dct_asynchronousObjectsForEntityName:(NSString *)entityName
								   predicate:(NSPredicate *)predicate
							 sortDescriptors:(NSArray *)sortDescriptors
							   callbackBlock:(DCTFetchRequestCallbackBlock)callbackBlock {

	[self dct_asynchronousObjectsForEntityName:entityName
									 predicate:predicate
							   sortDescriptors:sortDescriptors
									 batchSize:DCTFetchBatchSizeNil
								 callbackBlock:callbackBlock];
}

- (void)dct_asynchronousObjectsForEntityName:(NSString *)entityName
							 sortDescriptors:(NSArray *)sortDescriptors
							   callbackBlock:(DCTFetchRequestCallbackBlock)callbackBlock {
	
	[self dct_asynchronousObjectsForEntityName:entityName
									 predicate:nil
							   sortDescriptors:sortDescriptors
									 batchSize:DCTFetchBatchSizeNil
								 callbackBlock:callbackBlock];	
}

- (void)dct_asynchronousObjectsForEntityName:(NSString *)entityName
								   predicate:(NSPredicate *)predicate
							 sortDescriptors:(NSArray *)sortDescriptors
								   batchSize:(NSUInteger)batchSize
							   callbackBlock:(DCTFetchRequestCallbackBlock)callbackBlock {
	
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] dct_initWithEntity:entity
															   predicate:predicate
														 sortDescriptors:sortDescriptors
															   batchSize:batchSize];
	
	[self dct_asynchronousFetch:request
			  WithCallbackBlock:callbackBlock];
	
	[request release];	
}

#pragma mark -
#pragma mark Fetching Single Objects

- (void)dct_asynchronousObjectForEntityName:(NSString *)entityName
							  callbackBlock:(DCTFetchRequestObjectCallbackBlock)callbackBlock {
	
	[self dct_asynchronousObjectForEntityName:entityName
									predicate:nil 
							  sortDescriptors:nil
									batchSize:DCTFetchBatchSizeNil
								callbackBlock:callbackBlock];	
}

- (void)dct_asynchronousObjectForEntityName:(NSString *)entityName
								  predicate:(NSPredicate *)predicate
							  callbackBlock:(DCTFetchRequestObjectCallbackBlock)callbackBlock {
	
	[self dct_asynchronousObjectForEntityName:entityName
									predicate:predicate 
							  sortDescriptors:nil
									batchSize:DCTFetchBatchSizeNil
								callbackBlock:callbackBlock];
}

- (void)dct_asynchronousObjectForEntityName:(NSString *)entityName
								  predicate:(NSPredicate *)predicate
							sortDescriptors:(NSArray *)sortDescriptors
							  callbackBlock:(DCTFetchRequestObjectCallbackBlock)callbackBlock {
	
	[self dct_asynchronousObjectForEntityName:entityName
									predicate:predicate 
							  sortDescriptors:sortDescriptors
									batchSize:DCTFetchBatchSizeNil
								callbackBlock:callbackBlock];
}

- (void)dct_asynchronousObjectForEntityName:(NSString *)entityName
							sortDescriptors:(NSArray *)sortDescriptors
							  callbackBlock:(DCTFetchRequestObjectCallbackBlock)callbackBlock {
	
	[self dct_asynchronousObjectForEntityName:entityName
									predicate:nil 
							  sortDescriptors:sortDescriptors
									batchSize:DCTFetchBatchSizeNil
								callbackBlock:callbackBlock];
}

- (void)dct_asynchronousObjectForEntityName:(NSString *)entityName
								  predicate:(NSPredicate *)predicate 
							sortDescriptors:(NSArray *)sortDescriptors
								  batchSize:(NSUInteger)batchSize
							  callbackBlock:(DCTFetchRequestObjectCallbackBlock)callbackBlock {
	
	DCTFetchRequestCallbackBlock block = ^(NSArray *fetchedObjects, NSError *error) {
		
		id object = nil;
		if ([fetchedObjects count] > 0) object = [fetchedObjects objectAtIndex:0];
		
		callbackBlock(object, error);		
	};
	
	[self dct_asynchronousObjectsForEntityName:entityName
									 predicate:predicate 
							   sortDescriptors:sortDescriptors
									 batchSize:batchSize
								 callbackBlock:block];
}

@end
