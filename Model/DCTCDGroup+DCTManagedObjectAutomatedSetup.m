//
//  DCTCDGroup+DCTManagedObjectAutomatedSetup.m
//  DCTCoreData
//
//  Created by Daniel Tull on 28.09.2010.
//  Copyright 2010 Daniel Tull. All rights reserved.
//

#import "DCTCDGroup+DCTManagedObjectAutomatedSetup.h"

@implementation DCTCDGroup (DCTManagedObjectAutomatedSetup)

+ (NSDictionary *)dct_mappingFromRemoteNamesToLocalNames {
	NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
	[d setObject:@"groupID" forKey:@"id"];
	[d setObject:@"groupDescription" forKey:@"description"];
	return [d autorelease];	
}

+ (id)dct_convertValue:(id)value toCorrectTypeForKey:(NSString *)key {
	
	if ([key isEqualToString:@"date"])
		return [NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
	
	return nil;
}

@end
