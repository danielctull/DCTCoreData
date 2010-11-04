//
//  NSManagedObjectContext+DCTExtras.m
//  DCTCoreData
//
//  Created by Daniel Tull on 4.11.2010.
//  Copyright (c) 2010 Daniel Tull. All rights reserved.
//

#import "NSManagedObjectContext+DCTExtras.h"


@implementation NSManagedObjectContext (DCTExtras)

- (NSManagedObjectModel *)dct_managedObjectModel {
	return [[self persistentStoreCoordinator] managedObjectModel];
}

@end
