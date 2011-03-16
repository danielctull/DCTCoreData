//
//  NSManagedObject+DCTDataFetching.m
//  DCTCoreData
//
//  Created by Daniel Tull on 16.03.2011.
//  Copyright 2011 Daniel Tull. All rights reserved.
//

#import "NSManagedObject+DCTDataFetching.h"
#import "NSManagedObjectContext+DCTDataFetching.h"
#import "NSFetchRequest+DCTExtras.h"

@implementation NSManagedObject (DCTDataFetching)

+ (NSEntityDescription *)dct_entityInManagedObjectContext:(NSManagedObjectContext *)moc {
	
	// mogenerator method that gives the 
	if ([self respondsToSelector:@selector(entityInManagedObjectContext:)])
		return [self performSelector:@selector(entityInManagedObjectContext:)
						  withObject:moc];
	
	return [NSEntityDescription entityForName:NSStringFromClass(self)
					   inManagedObjectContext:moc];
}

+ (NSArray *)dct_fetchObjectsInManagedObjectContext:(NSManagedObjectContext *)moc {
	
	return [moc dct_fetchObjectsForEntity:[self dct_entityInManagedObjectContext:moc]
								predicate:nil
						  sortDescriptors:nil
								batchSize:DCTFetchBatchSizeNil];
}

+ (id)dct_insertNewObjectInManagedObjectContext:(NSManagedObjectContext *)moc {
	NSEntityDescription *entity = [self dct_entityInManagedObjectContext:moc];
	return [moc dct_insertNewObjectForEntityName:[entity name]];
}

@end
