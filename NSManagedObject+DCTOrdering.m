/*
 NSManagedObject+DCTOrdering.m
 DCTCoreData
 
 Created by Daniel Tull on 14.08.2010.
 
 
 
 Copyright (C) 2010 Daniel Tull. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 * Neither the name of the author nor the names of its contributors may be used
 to endorse or promote products derived from this software without specific
 prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "NSManagedObject+DCTOrdering.h"
#import "NSManagedObject+DCTRelatedObjects.h"

NSComparisonResult (^compareOrderedObjects)(id obj1, id obj2) = ^(id obj1, id obj2) {
	
	if (![obj1 isKindOfClass:[NSManagedObject class]] 
		|| ![obj2 isKindOfClass:[NSManagedObject class]]
		|| ![obj1 conformsToProtocol:@protocol(DCTOrderedObject)]
		|| ![obj2 conformsToProtocol:@protocol(DCTOrderedObject)]) 
		return (NSComparisonResult)NSOrderedSame;
	
	NSManagedObject<DCTOrderedObject> *man1 = (NSManagedObject<DCTOrderedObject> *)obj1;
	NSManagedObject<DCTOrderedObject> *man2 = (NSManagedObject<DCTOrderedObject> *)obj2;
	
	return [man1.dctOrderedObjectIndex compare:man2.dctOrderedObjectIndex];
};

@interface NSManagedObject ()
- (BOOL)dctInternal_containsRelationshipForKey:(NSString *)key;
- (NSSet *)dctInternal_orderedObjectsSetForKey:(NSString *)key;
- (NSInteger)dctInternal_setCountForKey:(NSString *)key;

- (void)dctInternal_setNextOrderedObject:(NSManagedObject<DCTOrderedObject> *)nextObject;
- (NSManagedObject<DCTOrderedObject> *)dctInternal_nextOrderedObject;

- (void)dctInternal_setPreviousOrderedObject:(NSManagedObject<DCTOrderedObject> *)nextObject;
- (NSManagedObject<DCTOrderedObject> *)dctInternal_previousOrderedObject;
@end

@implementation NSManagedObject (DCTOrdering)


- (void)dct_addOrderedObject:(NSManagedObject<DCTOrderedObject> *)object
					  forKey:(NSString *)key {
	
	if (![self dctInternal_containsRelationshipForKey:key]) return;
	
	NSManagedObject<DCTOrderedObject> *lastObject = [self dct_lastOrderedObjectForKey:key];
	
	if ([lastObject dctInternal_nextOrderedObject]) return;
	
	[lastObject dctInternal_setNextOrderedObject:object];
	
	object.dctOrderedObjectIndex = [NSNumber numberWithInteger:[lastObject.dctOrderedObjectIndex integerValue]+1];
	
	[self dct_addRelatedObject:object forKey:key];
}



- (void)dct_addOrderedObject:(NSManagedObject<DCTOrderedObject> *)object
					  forKey:(NSString *)key
				  lastObject:(NSManagedObject<DCTOrderedObject> *)last {
	
	if (![self dctInternal_containsRelationshipForKey:key]) return;
	
	// if the afterObject has a next object set, it's not the end so call the proper insert method
	if ([last dctInternal_nextOrderedObject])
		return [self dct_addOrderedObject:object forKey:key];
	
	NSInteger index = [last.dctOrderedObjectIndex integerValue] + 1;
	
	// if the set count is larger than the new object's insertion point, it's not the end so call the proper insert method
	if ([[self valueForKey:key] count] > index)
		return [self dct_addOrderedObject:object forKey:key];
	
	object.dctOrderedObjectIndex = [NSNumber numberWithInteger:index];
	
	[object dctInternal_setNextOrderedObject:last];
	
	[self dct_addRelatedObject:object forKey:key];
}


- (void)dct_insertOrderedObject:(NSManagedObject<DCTOrderedObject> *)object 
						atIndex:(NSInteger)index 
						 forKey:(NSString *)key {
	
	if (![self dctInternal_containsRelationshipForKey:key]) return;
	
	NSSet *set = [self dctInternal_orderedObjectsSetForKey:key];
	
	if ([set count] > 0) {
		
		NSArray *orderedObjects = [self dct_orderedObjectsForKey:key];
		
		if ([orderedObjects count] > index) {
			
			NSRange range = NSMakeRange(index, [orderedObjects count]-index);
			NSArray *objectsAfter = [orderedObjects subarrayWithRange:range];
			
			for (NSManagedObject<DCTOrderedObject> *o in objectsAfter)
				o.dctOrderedObjectIndex = [NSNumber numberWithInteger:[o.dctOrderedObjectIndex integerValue]+1];
			
			[object dctInternal_setNextOrderedObject:[orderedObjects objectAtIndex:index]];
		} 
		
		// work out the object before insert
		[object dctInternal_setPreviousOrderedObject:[orderedObjects objectAtIndex:index-1]];
	}
	
	object.dctOrderedObjectIndex = [NSNumber numberWithInteger:index];
	
	[self dct_addRelatedObject:object forKey:key];
}



- (void)dct_removeOrderedObjectAtIndex:(NSInteger)index 
								forKey:(NSString *)key {
	
	if (![self dctInternal_containsRelationshipForKey:key]) return;
	
	NSSet *set = [self dctInternal_orderedObjectsSetForKey:key];
	
	if ([set count] < index) return;
	
	
	NSArray *orderedObjects = [self dct_orderedObjectsForKey:key];
	
	NSManagedObject<DCTOrderedObject> *previous = [orderedObjects objectAtIndex:index-1];
	
	[previous dctInternal_setNextOrderedObject:nil];
	
	NSManagedObject<DCTOrderedObject> *object = [orderedObjects objectAtIndex:index];
	
	if ([orderedObjects count] > index) {
		
		NSManagedObject<DCTOrderedObject> *next = [orderedObjects objectAtIndex:index+1];
		[previous dctInternal_setNextOrderedObject:next];
		
		NSRange range = NSMakeRange(index, [orderedObjects count]-index);
		NSArray *objectsAfter = [orderedObjects subarrayWithRange:range];
		
		for (NSManagedObject<DCTOrderedObject> *o in objectsAfter)
			o.dctOrderedObjectIndex = [NSNumber numberWithInteger:[o.dctOrderedObjectIndex integerValue]-1];
	}
	
	[self dct_removeRelatedObject:object forKey:key];
}


- (void)dct_replaceOrderedObjectAtIndex:(NSInteger)index 
							 withObject:(NSManagedObject<DCTOrderedObject> *)object 
								 forKey:(NSString *)key {
	
	if (![self dctInternal_containsRelationshipForKey:key]) return;
	
	NSManagedObject<DCTOrderedObject> *objectToReplace = [self dct_orderedObjectAtIndex:index forKey:key];
	
	object.dctOrderedObjectIndex = objectToReplace.dctOrderedObjectIndex;
	
	NSManagedObject<DCTOrderedObject> *previous = [objectToReplace dctInternal_previousOrderedObject];
	NSManagedObject<DCTOrderedObject> *next = [objectToReplace dctInternal_nextOrderedObject];
	
	[objectToReplace dctInternal_setNextOrderedObject:nil];
	[objectToReplace dctInternal_setPreviousOrderedObject:nil];
	
	[object dctInternal_setPreviousOrderedObject:previous];
	[object dctInternal_setNextOrderedObject:next];
	
	[self dct_replaceRelatedObject:objectToReplace withRelatedObject:object forKey:key];	
}



- (NSManagedObject<DCTOrderedObject> *)dct_orderedObjectAtIndex:(NSInteger)index 
														 forKey:(NSString *)key {
	
	NSArray *orderedObjects = [self dct_orderedObjectsForKey:key];
	
	if (!orderedObjects || [orderedObjects count] < index) return nil;
	
	NSManagedObject *mo = [orderedObjects objectAtIndex:index];
	
	if (![mo conformsToProtocol:@protocol(DCTOrderedObject)]) return nil;
	
	return (NSManagedObject<DCTOrderedObject> *)mo;	
}



- (NSArray *)dct_orderedObjectsForKey:(NSString *)key {
	
	NSSet *set = [self dctInternal_orderedObjectsSetForKey:key];
	
	if (!set) return nil;
	
	return [[set allObjects] sortedArrayUsingComparator:compareOrderedObjects];
}




- (NSManagedObject<DCTOrderedObject> *)dct_lastOrderedObjectForKey:(NSString *)key {
	
	NSInteger count = [self dctInternal_setCountForKey:key];
	
	if (count == 0) return nil;
	
	return [self dct_orderedObjectAtIndex:count-1 forKey:key];
}



- (NSManagedObject<DCTOrderedObject> *)dct_firstOrderedObjectForKey:(NSString *)key {
	
	if ([self dctInternal_setCountForKey:key] == 0) return nil;
	
	return [self dct_orderedObjectAtIndex:0 forKey:key];
}




#pragma mark -
#pragma mark Internal methods

- (BOOL)dctInternal_containsRelationshipForKey:(NSString *)key {
	return [[[[self entity] relationshipsByName] allKeys] containsObject:key];
}


- (NSSet *)dctInternal_orderedObjectsSetForKey:(NSString *)key {
	
	if (![self dctInternal_containsRelationshipForKey:key]) return nil;
	
	return [self valueForKey:key];
}

- (NSInteger)dctInternal_setCountForKey:(NSString *)key {	
	return [[self dctInternal_orderedObjectsSetForKey:key] count];
}

- (void)dctInternal_setNextOrderedObject:(NSManagedObject<DCTOrderedObject> *)next {
	
	if (![self conformsToProtocol:@protocol(DCTOrderedObject)] || ![self respondsToSelector:@selector(setDctNextOrderedObject:)]) return;
	
	((NSManagedObject<DCTOrderedObject> *)self).dctNextOrderedObject = next;
}

- (NSManagedObject<DCTOrderedObject> *)dctInternal_nextOrderedObject {
	
	if (![self conformsToProtocol:@protocol(DCTOrderedObject)] || ![self respondsToSelector:@selector(dctNextOrderedObject)]) return nil;
	
	return ((NSManagedObject<DCTOrderedObject> *)self).dctNextOrderedObject;
}

- (void)dctInternal_setPreviousOrderedObject:(NSManagedObject<DCTOrderedObject> *)previous {
	
	if (![self conformsToProtocol:@protocol(DCTOrderedObject)] || ![self respondsToSelector:@selector(setDctPreviousOrderedObject:)]) return;
	
	((NSManagedObject<DCTOrderedObject> *)self).dctPreviousOrderedObject = previous;
}

- (NSManagedObject<DCTOrderedObject> *)dctInternal_previousOrderedObject {
	
	if (![self conformsToProtocol:@protocol(DCTOrderedObject)] || ![self respondsToSelector:@selector(dctPreviousOrderedObject)]) return nil;
	
	return ((NSManagedObject<DCTOrderedObject> *)self).dctPreviousOrderedObject;
}


@end
