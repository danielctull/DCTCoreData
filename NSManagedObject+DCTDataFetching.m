//
//  NSManagedObject+DCTDataFetching.m
//  DCTCoreData
//
//  Created by Daniel Tull on 16.03.2011.
//  Copyright 2011 Daniel Tull. All rights reserved.
//

#import "NSManagedObject+DCTDataFetching.h"
#import "NSManagedObjectContext+DCTDataFetching.h"

@implementation NSManagedObject (DCTDataFetching)

+ (NSEntityDescription *)dct_entityInManagedObjectContext:(NSManagedObjectContext *)moc {
	
	return [NSEntityDescription entityForName:NSStringFromClass(self)
					   inManagedObjectContext:moc];
}

+ (NSArray *)dct_fetchAllObjectsInManagedObjectContext:(NSManagedObjectContext *)moc {
	return [moc dct_fetchObjectsForEntityName:];
}

+ (id)dct_insertNewObjectInManagedObjectContext:(NSManagedObjectContext *)moc {
	return [moc dct_insertNewObjectForEntityName:NSStringFromClass(self)];
}

@end
