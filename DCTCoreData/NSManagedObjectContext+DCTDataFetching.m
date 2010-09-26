//
//  NSManagedObjectContext+DCTDataFetching.m
//  DTCoreData
//
//  Created by Daniel Tull on 16.09.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "NSManagedObjectContext+DCTDataFetching.h"
#import "NSFetchRequest+DCTInitMethods.h"

@implementation NSManagedObjectContext (DCTDataFetching)

#pragma mark -
#pragma mark Fetching Multiple Objects

- (NSArray *)dct_objectsForEntityName:(NSString *)entityName {
	
	return [self dct_objectsForEntityName:entityName
							predicate:nil
					  sortDescriptors:nil
							batchSize:DCTFetchBatchSizeNil];
}

- (NSArray *)dct_objectsForEntityName:(NSString *)entityName
							predicate:(NSPredicate *)predicate {
	
	return [self dct_objectsForEntityName:entityName
								predicate:predicate
						  sortDescriptors:nil
								batchSize:DCTFetchBatchSizeNil];
}

- (NSArray *)dct_objectsForEntityName:(NSString *)entityName
							predicate:(NSPredicate *)predicate
					  sortDescriptors:(NSArray *)sortDescriptors {
	
	return [self dct_objectsForEntityName:entityName
								predicate:predicate
						  sortDescriptors:sortDescriptors
								batchSize:DCTFetchBatchSizeNil];
}

- (NSArray *)dct_objectsForEntityName:(NSString *)entityName
					  sortDescriptors:(NSArray *)sortDescriptors {
	
	return [self dct_objectsForEntityName:entityName
								predicate:nil
						  sortDescriptors:sortDescriptors
								batchSize:DCTFetchBatchSizeNil];
}

// The one method that does the heavy lifting:
- (NSArray *)dct_objectsForEntityName:(NSString *)entityName
							predicate:(NSPredicate *)predicate
					  sortDescriptors:(NSArray *)sortDescriptors
							batchSize:(NSUInteger)batchSize {
	
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] dct_initWithEntity:entity predicate:predicate sortDescriptors:sortDescriptors batchSize:batchSize];
	
	NSError *error = nil;
	
	NSArray *fetchResult = [self executeFetchRequest:request error:&error];
	[request release];
	
	if (error) {
		NSLog(@"DCTDataFetching: Error fetching objects. %@", error);
		return nil;
	}
	
	return fetchResult;
}

#pragma mark -
#pragma mark Fetching Single Objects

- (id)dct_objectForEntityName:(NSString *)entityName {

	return [self dct_objectForEntityName:entityName
							   predicate:nil
						 sortDescriptors:nil
							   batchSize:DCTFetchBatchSizeNil];
}

- (id)dct_objectForEntityName:(NSString *)entityName
					predicate:(NSPredicate *)predicate {
	
	return [self dct_objectForEntityName:entityName
							   predicate:predicate
						 sortDescriptors:nil
							   batchSize:DCTFetchBatchSizeNil];
}

- (id)dct_objectForEntityName:(NSString *)entityName
					predicate:(NSPredicate *)predicate
			  sortDescriptors:(NSArray *)sortDescriptors {
	
	return [self dct_objectForEntityName:entityName
							   predicate:predicate
						 sortDescriptors:sortDescriptors
							   batchSize:DCTFetchBatchSizeNil];
}

- (id)dct_objectForEntityName:(NSString *)entityName
			  sortDescriptors:(NSArray *)sortDescriptors {
	
	return [self dct_objectForEntityName:entityName
							   predicate:nil
						 sortDescriptors:sortDescriptors
							   batchSize:DCTFetchBatchSizeNil];
}

- (id)dct_objectForEntityName:(NSString *)entityName
					predicate:(NSPredicate *)predicate 
			  sortDescriptors:(NSArray *)sortDescriptors
					batchSize:(NSUInteger)batchSize {
	
	NSArray *results = [self dct_objectsForEntityName:entityName
											predicate:predicate
									  sortDescriptors:sortDescriptors
											batchSize:batchSize];
		
	if ([results count] < 1) return nil;
	
	return [results objectAtIndex:0];
}

#pragma mark -
#pragma mark Inserting New Objects

- (id)dct_insertNewObjectForEntityName:(NSString *)entityName {
	return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self];
}

@end
