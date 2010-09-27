//
//  NSAttributeDescription+DCTObjectCheck.h
//  DCTCoreData
//
//  Created by Daniel Tull on 11.08.2010.
//  Copyright (c) 2010 Daniel Tull. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSAttributeDescription (DCTObjectCheck)

- (BOOL)dct_isObjectValid:(id)object;

@end
