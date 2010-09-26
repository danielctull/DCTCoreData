//
//  NSManagedObjectContext+DCTDataFetching.h
//  DCTCoreData
//
//  Created by Daniel Tull on 16.09.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (DCTDataFetching)

#pragma mark -
#pragma mark Fetching Multiple Objects

- (NSArray *)dct_objectsForEntityName:(NSString *)entityName;

- (NSArray *)dct_objectsForEntityName:(NSString *)entityName
							predicate:(NSPredicate *)predicate;

- (NSArray *)dct_objectsForEntityName:(NSString *)entityName
							predicate:(NSPredicate *)predicate
					  sortDescriptors:(NSArray *)sortDescriptors;
	
- (NSArray *)dct_objectsForEntityName:(NSString *)entityName
					  sortDescriptors:(NSArray *)sortDescriptors;

- (NSArray *)dct_objectsForEntityName:(NSString *)entityName
							predicate:(NSPredicate *)predicate
					  sortDescriptors:(NSArray *)sortDescriptors
							batchSize:(NSUInteger)batchSize;

#pragma mark -
#pragma mark Fetching Single Objects

- (id)dct_objectForEntityName:(NSString *)entityName;

- (id)dct_objectForEntityName:(NSString *)entityName
					predicate:(NSPredicate *)predicate;

- (id)dct_objectForEntityName:(NSString *)entityName
					predicate:(NSPredicate *)predicate
			  sortDescriptors:(NSArray *)sortDescriptors;

- (id)dct_objectForEntityName:(NSString *)entityName
			  sortDescriptors:(NSArray *)sortDescriptors;

- (id)dct_objectForEntityName:(NSString *)entityName
					predicate:(NSPredicate *)predicate 
			  sortDescriptors:(NSArray *)sortDescriptors
					batchSize:(NSUInteger)batchSize;

#pragma mark -
#pragma mark Inserting New Objects

- (id)dct_insertNewObjectForEntityName:(NSString *)entityName;
@end
