//
//  NSEntityDescription+DCTObjectCheck.m
//  DCTCoreData
//
//  Created by Daniel Tull on 11.08.2010.
//  Copyright (c) 2010 Daniel Tull. All rights reserved.
//

#import "NSEntityDescription+DCTObjectCheck.h"

@implementation NSEntityDescription (DCTObjectCheck)

- (BOOL)dct_isObjectValid:(id)object {
	return [[self managedObjectClassName] isEqualToString:NSStringFromClass([object class])];
}

@end
