//
//  NSArray+DCTSortDescriptors.h
//  DCTCoreData
//
//  Created by Daniel Tull on 18.02.2010.
//  Copyright 2010 Daniel Tull. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSArray (DCTSortDescriptors)
+ (NSArray *)dct_sortDescriptorsArrayWithKey:(NSString *)key ascending:(BOOL)ascending;
@end
