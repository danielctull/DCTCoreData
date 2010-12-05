//
//  DCTCDGroup.h
//  DCTCoreData
//
//  Created by Daniel Tull on 28.09.2010.
//  Copyright 2010 Daniel Tull. All rights reserved.
//

#import <CoreData/CoreData.h>

@class DCTCDItem;

@interface DCTCDGroup :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * groupDescription;
@property (nonatomic, retain) NSNumber * groupID;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSSet* items;

@end


@interface DCTCDGroup (CoreDataGeneratedAccessors)
- (void)addItemsObject:(DCTCDItem *)value;
- (void)removeItemsObject:(DCTCDItem *)value;
- (void)addItems:(NSSet *)value;
- (void)removeItems:(NSSet *)value;

@end

