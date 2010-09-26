//
//  NSFetchRequest+DCTInitMethods.h
//  DCTCoreData
//
//  Created by Daniel Tull on 18.02.2010.
//  Copyright 2010 Daniel Tull. All rights reserved.
//

#import <CoreData/CoreData.h>

extern NSUInteger const DCTFetchBatchSizeNil;

@interface NSFetchRequest (DCTInitMethods)

- (id)dct_initWithEntity:(NSEntityDescription *)entity;

- (id)dct_initWithEntity:(NSEntityDescription *)entity
			   predicate:(NSPredicate *)predicate;

- (id)dct_initWithEntity:(NSEntityDescription *)entity
			   predicate:(NSPredicate *)predicate
		 sortDescriptors:(NSArray *)sortDescriptors;

- (id)dct_initWithEntity:(NSEntityDescription *)entity
			   predicate:(NSPredicate *)predicate
		 sortDescriptors:(NSArray *)sortDescriptors
			   batchSize:(NSUInteger)batchSize;

@end
