//
//  NSArray+DCTSortDescriptors.m
//  DCTCoreData
//
//  Created by Daniel Tull on 18.02.2010.
//  Copyright 2010 Daniel Tull. All rights reserved.
//

#import "NSArray+DCTSortDescriptors.h"


@implementation NSArray (DCTSortDescriptors)

+ (NSArray *)dct_sortDescriptorsArrayWithKey:(NSString *)key ascending:(BOOL)ascending {
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:ascending];
	NSArray *descriptors = [NSArray arrayWithObject:sortDescriptor];
	[sortDescriptor release];
	return descriptors;
}

@end
