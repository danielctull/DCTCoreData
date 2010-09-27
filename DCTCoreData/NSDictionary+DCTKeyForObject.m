//
//  NSDictionary+DCTKeyForObject.m
//  DCTCoreData
//
//  Created by Daniel Tull on 12.08.2010.
//  Copyright (c) 2010 Daniel Tull. All rights reserved.
//

#import "NSDictionary+DCTKeyForObject.h"


@implementation NSDictionary (DCTKeyForObject)

- (id)dct_keyForObject:(id)object {
	
	for (id key in self) {
		id o = [self objectForKey:key];
		
		if (o == object) return key;			
	}
	
	return nil;
}

@end
