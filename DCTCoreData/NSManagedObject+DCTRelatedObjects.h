//
//  NSManagedObject+DCTRelatedObjects.h
//  DCTCoreData
//
//  Created by Daniel Tull on 14.08.2010.
//  Copyright (c) 2010 Daniel Tull. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (DCTRelatedObjects)

- (void)dct_addRelatedObject:(id)value forKey:(NSString *)key;
- (void)dct_removeRelatedObject:(id)value forKey:(NSString *)key;
- (void)dct_replaceRelatedObject:(id)oldObject withRelatedObject:(id)newObject forKey:(NSString *)key;

@end
