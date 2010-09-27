//
//  NSAttributeDescription+DCTObjectCheck.m
//  DCTCoreData
//
//  Created by Daniel Tull on 11.08.2010.
//  Copyright (c) 2010 Daniel Tull. All rights reserved.
//

#import "NSAttributeDescription+DCTObjectCheck.h"

@implementation NSAttributeDescription (DCTObjectCheck)

- (BOOL)dct_isObjectValid:(id)object {
	
	Class attributeClass = NSClassFromString([self attributeValueClassName]);
	
	return ([object isKindOfClass:attributeClass] || [self attributeType] == NSTransformableAttributeType);
}

@end
