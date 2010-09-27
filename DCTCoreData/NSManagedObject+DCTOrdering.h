//
//  NSManagedObject+DCTOrdering.h
//  DCTCoreData
//
//  Created by Daniel Tull on 14.08.2010.
//  Copyright (c) 2010 Daniel Tull. All rights reserved.
//

#import <CoreData/CoreData.h>

@protocol DCTOrderedObject;

@interface NSManagedObject (DCTOrdering)

- (void)dct_addOrderedObject:(NSManagedObject<DCTOrderedObject> *)object forKey:(NSString *)key;
- (void)dct_addOrderedObject:(NSManagedObject<DCTOrderedObject> *)object forKey:(NSString *)key lastObject:(NSManagedObject<DCTOrderedObject> *)last;

- (void)dct_insertOrderedObject:(NSManagedObject<DCTOrderedObject> *)object atIndex:(NSInteger)index forKey:(NSString *)key;
- (void)dct_removeOrderedObjectAtIndex:(NSInteger)index forKey:(NSString *)key;

- (NSManagedObject<DCTOrderedObject> *)dct_orderedObjectAtIndex:(NSInteger)index forKey:(NSString *)key;
- (NSManagedObject<DCTOrderedObject> *)dct_lastOrderedObjectForKey:(NSString *)key;
- (NSManagedObject<DCTOrderedObject> *)dct_firstOrderedObjectForKey:(NSString *)key;

- (NSArray *)dct_orderedObjectsForKey:(NSString *)key;

@end


@protocol DCTOrderedObject

@required
@property (nonatomic, retain) NSNumber *dctOrderedObjectIndex;

@optional
@property (nonatomic, retain) NSManagedObject<DCTOrderedObject> *dctPreviousOrderedObject;
@property (nonatomic, retain) NSManagedObject<DCTOrderedObject> *dctNextOrderedObject;

@end
