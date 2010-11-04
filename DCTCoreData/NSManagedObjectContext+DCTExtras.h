//
//  NSManagedObjectContext+DCTExtras.h
//  DCTCoreData
//
//  Created by Daniel Tull on 4.11.2010.
//  Copyright (c) 2010 Daniel Tull. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (DCTExtras)

- (NSManagedObjectModel *)dct_managedObjectModel;

@end
