//
//  NSManagedObject+DCTDataFetching.h
//  DCTCoreData
//
//  Created by Daniel Tull on 16.03.2011.
//  Copyright 2011 Daniel Tull. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (DCTDataFetching)

+ (NSEntityDescription *)dct_entityInManagedObjectContext:(NSManagedObjectContext *)moc;

+ (NSArray *)dct_fetchObjectsInManagedObjectContext:(NSManagedObjectContext *)moc;

+ (id)dct_insertNewObjectInManagedObjectContext:(NSManagedObjectContext *)moc;

@end
