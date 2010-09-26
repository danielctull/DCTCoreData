//
//  NSFetchRequest+DCTInitMethods.m
//  DCTCoreData
//
//  Created by Daniel Tull on 18.02.2010.
//  Copyright 2010 Daniel Tull. All rights reserved.
//

#import "NSFetchRequest+DCTInitMethods.h"

NSUInteger const DTBatchSizeNil = 0;

@implementation NSFetchRequest (DCTInitMethods)

- (id)initWithEntity:(NSEntityDescription *)entity {
	
	return [self initWithEntity:entity predicate:nil sortDescriptors:nil batchSize:DTBatchSizeNil];
}

- (id)initWithEntity:(NSEntityDescription *)entity
		   predicate:(NSPredicate *)predicate {
	
	return [self initWithEntity:entity predicate:predicate sortDescriptors:nil batchSize:DTBatchSizeNil];
}

- (id)initWithEntity:(NSEntityDescription *)entity
		   predicate:(NSPredicate *)predicate
	 sortDescriptors:(NSArray *)sortDescriptors {
	
	return [self initWithEntity:entity predicate:predicate sortDescriptors:sortDescriptors batchSize:DTBatchSizeNil];
}


- (id)initWithEntity:(NSEntityDescription *)entity
		   predicate:(NSPredicate *)predicate
	 sortDescriptors:(NSArray *)sortDescriptors
		   batchSize:(NSUInteger)batchSize {
	
	if (!(self = [self init])) return nil;
	
	[self setEntity:entity];
	
	if (predicate) [self setPredicate:predicate];
	
	if (sortDescriptors) [self setSortDescriptors:sortDescriptors];
	
	if (batchSize != DTBatchSizeNil) [self setFetchBatchSize:batchSize];
	
	return self;
}

@end
