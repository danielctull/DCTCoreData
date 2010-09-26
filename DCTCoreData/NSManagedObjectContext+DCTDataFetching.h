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

- (NSArray *)objectsForEntityName:(NSString *)entityName;

- (NSArray *)objectsForEntityName:(NSString *)entityName
						predicate:(NSPredicate *)predicate;

- (NSArray *)objectsForEntityName:(NSString *)entityName
						predicate:(NSPredicate *)predicate
				  sortDescriptors:(NSArray *)sortDescriptors;
	
- (NSArray *)objectsForEntityName:(NSString *)entityName
				  sortDescriptors:(NSArray *)sortDescriptors;

- (NSArray *)objectsForEntityName:(NSString *)entityName
						predicate:(NSPredicate *)predicate
				  sortDescriptors:(NSArray *)sortDescriptors
						batchSize:(NSUInteger)batchSize;

#pragma mark -
#pragma mark Fetching Single Objects

- (id)objectForEntityName:(NSString *)entityName;

- (id)objectForEntityName:(NSString *)entityName
				predicate:(NSPredicate *)predicate;

- (id)objectForEntityName:(NSString *)entityName
				predicate:(NSPredicate *)predicate
		  sortDescriptors:(NSArray *)sortDescriptors;

- (id)objectForEntityName:(NSString *)entityName
		  sortDescriptors:(NSArray *)sortDescriptors;

- (id)objectForEntityName:(NSString *)entityName
				predicate:(NSPredicate *)predicate 
		  sortDescriptors:(NSArray *)sortDescriptors
				batchSize:(NSUInteger)batchSize;

#pragma mark -
#pragma mark Inserting New Objects

- (id)insertNewObjectForEntityName:(NSString *)entityName;
@end
