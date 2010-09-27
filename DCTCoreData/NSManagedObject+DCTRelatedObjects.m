//
//  NSManagedObject+DCTRelatedObjects.m
//  DCTCoreData
//
//  Created by Daniel Tull on 14.08.2010.
//  Copyright (c) 2010 Daniel Tull. All rights reserved.
//

#import "NSManagedObject+DCTRelatedObjects.h"


@implementation NSManagedObject (DCTRelatedObjects)

- (void)dct_addRelatedObject:(id)object forKey:(NSString *)key {
	NSSet *changedObjects = [[NSSet alloc] initWithObjects:&object count:1];
	
    [self willChangeValueForKey:key withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
	
    [[self primitiveValueForKey:key] addObject:object];
	
    [self didChangeValueForKey:key withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
	
    [changedObjects release];
}

- (void)dct_removeRelatedObject:(id)object forKey:(NSString *)key {
	NSSet *changedObjects = [[NSSet alloc] initWithObjects:&object count:1];
	
    [self willChangeValueForKey:key withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
	
    [[self primitiveValueForKey:key] removeObject:object];
	
    [self didChangeValueForKey:key withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
	
    [changedObjects release];
}

- (void)dct_replaceRelatedObject:(id)oldObject withRelatedObject:(id)newObject forKey:(NSString *)key {	
	NSSet *changedObjects = [[NSSet alloc] initWithObjects:&newObject count:1];
	
    [self willChangeValueForKey:key withSetMutation:NSKeyValueSetSetMutation usingObjects:changedObjects];
	
    [[self primitiveValueForKey:key] removeObject:oldObject];
	[[self primitiveValueForKey:key] addObject:newObject];
	
    [self didChangeValueForKey:key withSetMutation:NSKeyValueSetSetMutation usingObjects:changedObjects];
	
    [changedObjects release];
}

@end
