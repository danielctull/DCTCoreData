//
//  DCTCDItem.h
//  DCTCoreData
//
//  Created by Daniel Tull on 28.09.2010.
//  Copyright 2010 Daniel Tull. All rights reserved.
//

#import <CoreData/CoreData.h>

@class DCTCDGroup;

@interface DCTCDItem :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * theID;
@property (nonatomic, retain) NSString * itemDescription;
@property (nonatomic, retain) DCTCDGroup * group;

@end



