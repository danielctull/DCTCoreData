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

@interface NSManagedObject (DCTOrderingInternal)
- (BOOL)dctOrderingInternal_containsRelationshipForKey:(NSString *)key;
- (NSSet *)dctOrderingInternal_orderedObjectsSetForKey:(NSString *)key;
- (NSInteger)dctOrderingInternal_setCountForKey:(NSString *)key;

- (void)dctOrderingInternal_setNextOrderedObject:(NSManagedObject<DCTOrderedObject> *)nextObject;
- (NSManagedObject<DCTOrderedObject> *)dctOrderingInternal_nextOrderedObject;

- (void)dctOrderingInternal_setPreviousOrderedObject:(NSManagedObject<DCTOrderedObject> *)nextObject;
- (NSManagedObject<DCTOrderedObject> *)dctOrderingInternal_previousOrderedObject;
@end

@implementation NSManagedObject (DCTOrdering)


- (void)dct_addOrderedObject:(NSManagedObject<DCTOrderedObject> *)object
					  forKey:(NSString *)key {
	
	if (![self dctOrderingInternal_containsRelationshipForKey:key]) return;
	
	NSManagedObject<DCTOrderedObject> *lastObject = [self dct_lastOrderedObjectForKey:key];
	
	if ([lastObject dctOrderingInternal_nextOrderedObject]) return;
	
	[lastObject dctOrderingInternal_setNextOrderedObject:object];
	
	object.dctOrderedObjectIndex = [NSNumber numberWithInteger:[lastObject.dctOrderedObjectIndex integerValue]+1];
	
	[self dct_addRelatedObject:object forKey:key];
}



- (void)dct_addOrderedObject:(NSManagedObject<DCTOrderedObject> *)object
					  forKey:(NSString *)key
				  lastObject:(NSManagedObject<DCTOrderedObject> *)last {
	
	if (![self dctOrderingInternal_containsRelationshipForKey:key]) return;
	
	// if the afterObject has a next object set, it's not the end so call the proper insert method
	if ([last dctOrderingInternal_nextOrderedObject])
		return [self dct_addOrderedObject:object forKey:key];
	
	NSUInteger insertionIndex = [last.dctOrderedObjectIndex integerValue] + 1;
	
	// if the set count is larger than the new object's insertion point, it's not the end so call the proper insert method
	if ([[self valueForKey:key] count] > insertionIndex)
		return [self dct_addOrderedObject:object forKey:key];
	
	object.dctOrderedObjectIndex = [NSNumber numberWithInteger:insertionIndex];
	
	[object dctOrderingInternal_setNextOrderedObject:last];
	
	[self dct_addRelatedObject:object forKey:key];
}


- (void)dct_insertOrderedObject:(NSManagedObject<DCTOrderedObject> *)object 
						atIndex:(NSUInteger)insertionIndex 
						 forKey:(NSString *)key {
	
	if (![self dctOrderingInternal_containsRelationshipForKey:key]) return;
	
	NSSet *set = [self dctOrderingInternal_orderedObjectsSetForKey:key];
	
	if ([set count] > 0) {
		
		NSArray *orderedObjects = [self dct_orderedObjectsForKey:key];
		
		if ([orderedObjects count] > insertionIndex) {
			
			NSRange range = NSMakeRange(insertionIndex, [orderedObjects count] - insertionIndex);
			NSArray *objectsAfter = [orderedObjects subarrayWithRange:range];
			
			for (NSManagedObject<DCTOrderedObject> *o in objectsAfter)
				o.dctOrderedObjectIndex = [NSNumber numberWithInteger:[o.dctOrderedObjectIndex integerValue]+1];
			
			[object dctOrderingInternal_setNextOrderedObject:[orderedObjects objectAtIndex:insertionIndex]];
		} 
		
		// work out the object before insert
		[object dctOrderingInternal_setPreviousOrderedObject:[orderedObjects objectAtIndex:insertionIndex - 1]];
	}
	
	object.dctOrderedObjectIndex = [NSNumber numberWithInteger:insertionIndex];
	
	[self dct_addRelatedObject:object forKey:key];
}



- (void)dct_removeOrderedObjectAtIndex:(NSUInteger)theIndex 
								forKey:(NSString *)key {
	
	if (![self dctOrderingInternal_containsRelationshipForKey:key]) return;
	
	NSSet *set = [self dctOrderingInternal_orderedObjectsSetForKey:key];
	
	if ([set count] < theIndex) return;
	
	
	NSArray *orderedObjects = [self dct_orderedObjectsForKey:key];
	
	NSManagedObject<DCTOrderedObject> *previous = [orderedObjects objectAtIndex:theIndex - 1];
	
	[previous dctOrderingInternal_setNextOrderedObject:nil];
	
	NSManagedObject<DCTOrderedObject> *object = [orderedObjects objectAtIndex:theIndex];
	
	if ([orderedObjects count] > theIndex) {
		
		NSManagedObject<DCTOrderedObject> *next = [orderedObjects objectAtIndex:theIndex + 1];
		[previous dctOrderingInternal_setNextOrderedObject:next];
		
		NSRange range = NSMakeRange(theIndex, [orderedObjects count] - theIndex);
		NSArray *objectsAfter = [orderedObjects subarrayWithRange:range];
		
		for (NSManagedObject<DCTOrderedObject> *o in objectsAfter)
			o.dctOrderedObjectIndex = [NSNumber numberWithInteger:[o.dctOrderedObjectIndex integerValue] - 1];
	}
	
	[self dct_removeRelatedObject:object forKey:key];
}


- (void)dct_replaceOrderedObjectAtIndex:(NSUInteger)theIndex 
							 withObject:(NSManagedObject<DCTOrderedObject> *)object 
								 forKey:(NSString *)key {
	
	if (![self dctOrderingInternal_containsRelationshipForKey:key]) return;
	
	NSManagedObject<DCTOrderedObject> *objectToReplace = [self dct_orderedObjectAtIndex:theIndex forKey:key];
	
	object.dctOrderedObjectIndex = objectToReplace.dctOrderedObjectIndex;
	
	NSManagedObject<DCTOrderedObject> *previous = [objectToReplace dctOrderingInternal_previousOrderedObject];
	NSManagedObject<DCTOrderedObject> *next = [objectToReplace dctOrderingInternal_nextOrderedObject];
	
	[objectToReplace dctOrderingInternal_setNextOrderedObject:nil];
	[objectToReplace dctOrderingInternal_setPreviousOrderedObject:nil];
	
	[object dctOrderingInternal_setPreviousOrderedObject:previous];
	[object dctOrderingInternal_setNextOrderedObject:next];
	
	[self dct_replaceRelatedObject:objectToReplace withRelatedObject:object forKey:key];	
}



- (NSManagedObject<DCTOrderedObject> *)dct_orderedObjectAtIndex:(NSUInteger)theIndex 
														 forKey:(NSString *)key {
	
	NSArray *orderedObjects = [self dct_orderedObjectsForKey:key];
	
	if (!orderedObjects || [orderedObjects count] < theIndex) return nil;
	
	NSManagedObject *mo = [orderedObjects objectAtIndex:theIndex];
	
	if (![mo conformsToProtocol:@protocol(DCTOrderedObject)]) return nil;
	
	return (NSManagedObject<DCTOrderedObject> *)mo;	
}



- (NSArray *)dct_orderedObjectsForKey:(NSString *)key {
	
	NSSet *set = [self dctOrderingInternal_orderedObjectsSetForKey:key];
	
	if (!set) return nil;
	
	return [[set allObjects] sortedArrayUsingComparator:compareOrderedObjects];
}




- (NSManagedObject<DCTOrderedObject> *)dct_lastOrderedObjectForKey:(NSString *)key {
	
	NSInteger count = [self dctOrderingInternal_setCountForKey:key];
	
	if (count == 0) return nil;
	
	return [self dct_orderedObjectAtIndex:count-1 forKey:key];
}



- (NSManagedObject<DCTOrderedObject> *)dct_firstOrderedObjectForKey:(NSString *)key {
	
	if ([self dctOrderingInternal_setCountForKey:key] == 0) return nil;
	
	return [self dct_orderedObjectAtIndex:0 forKey:key];
}

@end

@implementation NSManagedObject (DCTOrderingInternal)

- (BOOL)dctOrderingInternal_containsRelationshipForKey:(NSString *)key {
	return [[[[self entity] relationshipsByName] allKeys] containsObject:key];
}


- (NSSet *)dctOrderingInternal_orderedObjectsSetForKey:(NSString *)key {
	
	if (![self dctOrderingInternal_containsRelationshipForKey:key]) return nil;
	
	return [self valueForKey:key];
}

- (NSInteger)dctOrderingInternal_setCountForKey:(NSString *)key {	
	return [[self dctOrderingInternal_orderedObjectsSetForKey:key] count];
}

- (void)dctOrderingInternal_setNextOrderedObject:(NSManagedObject<DCTOrderedObject> *)next {
	
	if (![self conformsToProtocol:@protocol(DCTOrderedObject)] || ![self respondsToSelector:@selector(setDctNextOrderedObject:)]) return;
	
	((NSManagedObject<DCTOrderedObject> *)self).dctNextOrderedObject = next;
}

- (NSManagedObject<DCTOrderedObject> *)dctOrderingInternal_nextOrderedObject {
	
	if (![self conformsToProtocol:@protocol(DCTOrderedObject)] || ![self respondsToSelector:@selector(dctNextOrderedObject)]) return nil;
	
	return ((NSManagedObject<DCTOrderedObject> *)self).dctNextOrderedObject;
}

- (void)dctOrderingInternal_setPreviousOrderedObject:(NSManagedObject<DCTOrderedObject> *)previous {
	
	if (![self conformsToProtocol:@protocol(DCTOrderedObject)] || ![self respondsToSelector:@selector(setDctPreviousOrderedObject:)]) return;
	
	((NSManagedObject<DCTOrderedObject> *)self).dctPreviousOrderedObject = previous;
}

- (NSManagedObject<DCTOrderedObject> *)dctOrderingInternal_previousOrderedObject {
	
	if (![self conformsToProtocol:@protocol(DCTOrderedObject)] || ![self respondsToSelector:@selector(dctPreviousOrderedObject)]) return nil;
	
	return ((NSManagedObject<DCTOrderedObject> *)self).dctPreviousOrderedObject;
}


@end
