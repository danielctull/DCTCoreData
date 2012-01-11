/*
 NSManagedObject+DCTAutomatedSetup.m
 DCTCoreData
 
 Created by Daniel Tull on 11.08.2010.
 
 
 
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

#import "NSManagedObject+DCTAutomatedSetup.h"
#import "NSManagedObjectContext+DCTDataFetching.h"
#import "NSManagedObject+DCTOrdering.h"
#import "NSEntityDescription+DCTObjectCheck.h"
#import "NSAttributeDescription+DCTObjectCheck.h"
#import "NSManagedObject+DCTRelatedObjects.h"
#import "NSDictionary+DCTKeyForObject.h"
#import "NSPredicate+DCTExtras.h"

/* Define these for logging problems:
 
 DCTManagedObjectAutomatedSetupLogStorageFailures
 DCTManagedObjectAutomatedSetupLogAutomaticPrimaryKeyUse
 DCTManagedObjectAutomatedSetupLogExtremeFailures
*/


@interface NSManagedObject (DCTAutomatedSetupInternal)

+ (id)dctAutomatedSetupInternal_fetchObjectMatchingDictionary:(NSDictionary *)dictionary
                                         entity:(NSEntityDescription *)entity
                           managedObjectContext:(NSManagedObjectContext *)moc;

@end

@implementation NSManagedObject (DCTAutomatedSetup)

+ (id)dct_objectFromDictionary:(NSDictionary *)dictionary 
		insertIntoManagedObjectContext:(NSManagedObjectContext *)moc {
	
	if (![self conformsToProtocol:@protocol(DCTManagedObjectAutomatedSetup)])
		return nil;
	
	Class<DCTManagedObjectAutomatedSetup> myself = (Class<DCTManagedObjectAutomatedSetup>)self;
	
	NSManagedObject *object = nil;
	
	NSString *entityName = nil;
	if ([self respondsToSelector:@selector(dct_entityName)])
		entityName = [myself dct_entityName];
	
	if (!entityName)
		entityName = NSStringFromClass(myself);
	
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:moc];
	
	if (!object)
		object = [self dctAutomatedSetupInternal_fetchObjectMatchingDictionary:dictionary entity:entity managedObjectContext:moc];
	
	if (!object)
		object = [moc dct_insertNewObjectForEntityName:entityName];
	
	
	[object dct_setupFromDictionary:dictionary];	
	
	return object;
}

- (BOOL)dct_setupFromDictionary:(NSDictionary *)dictionary {
	
	if (![self conformsToProtocol:@protocol(DCTManagedObjectAutomatedSetup)])
		return NO;
	
	Class<DCTManagedObjectAutomatedSetup> selfclass = [self class];
	
	NSDictionary *mapping = nil;
	
	if ([[self class] respondsToSelector:@selector(dct_mappingFromRemoteNamesToLocalNames)])
		mapping = [selfclass dct_mappingFromRemoteNamesToLocalNames];
	
	for (__strong NSString *key in dictionary) {
		
		id object = [dictionary objectForKey:key];
		
		// convert the key to our local storage using the provide mapping
		if ([[mapping allKeys] containsObject:key])
			key = [mapping objectForKey:key];
		
		if (![self dct_setSerializedValue:object forKey:key]) {
			
#if defined(DCTManagedObjectAutomatedSetupLogStorageFailures)
			NSLog(@"%@ (DCTManagedObjectAutomatedSetup): Didn't store key:%@ object:%@", NSStringFromClass([self class]), key, object);
#endif
			
		}
		
	}
	
	return YES;
	
}

- (BOOL)dct_setSerializedValue:(id)object forKey:(NSString *)key {
	
	Class<DCTManagedObjectAutomatedSetup> selfclass = [self class];
	
	// give the class a chance to convert the object
	if ([[self class] respondsToSelector:@selector(dct_convertValue:toCorrectTypeForKey:)] && ![object isKindOfClass:[NSNull class]]) {
		id returnedObject = [selfclass dct_convertValue:object toCorrectTypeForKey:key];
		if (returnedObject) object = returnedObject;
	}
	
	
	if ([object isKindOfClass:[NSArray class]]) {
		BOOL returnBool = NO;
		
		for (id o in (NSArray *)object) {
			if ([self dct_setSerializedValue:o forKey:key])
				returnBool = YES;
		}
		return returnBool;
	}
	
	
	NSEntityDescription *entity = [self entity];
	NSDictionary *attributesByName = [entity attributesByName];
	
	if ([[attributesByName allKeys] containsObject:key]) {
		
		NSAttributeDescription *attribute = [attributesByName objectForKey:key];
		
		if ([attribute dct_isObjectValid:object]) {
			[self setValue:object forKey:key];
			return YES;
		}
	}
	
	
	NSDictionary *relationshipsByName = [entity relationshipsByName];
	
	if ([[relationshipsByName allKeys] containsObject:key]) {
		
		NSRelationshipDescription *relationship = [relationshipsByName objectForKey:key];
		NSEntityDescription *destinationEntity = [relationship destinationEntity];
		
		// if it's a dictionary at this point, we'll try to create a managed object of the right class using the dictionary
		if ([object isKindOfClass:[NSDictionary class]]) {
			NSString *destinationClassName = [destinationEntity managedObjectClassName];
			Class destinationClass = NSClassFromString(destinationClassName);
			object = [destinationClass dct_objectFromDictionary:object insertIntoManagedObjectContext:[self managedObjectContext]];
		}
		
		BOOL isValid = [destinationEntity dct_isObjectValid:object];
		
		if (isValid) {
			
			if ([relationship isToMany]) {
				
				if ([object conformsToProtocol:@protocol(DCTOrderedObject)])
					[self dct_addOrderedObject:object forKey:key];
				else
					[self dct_addRelatedObject:object forKey:key];
				
			} else if (isValid)
				[self setValue:object forKey:key];
			
			return YES;			
		}
	}
	
	return NO;
}

@end

@implementation NSManagedObject (DCTAutomatedSetupInternal)

+ (id)dctAutomatedSetupInternal_fetchObjectMatchingDictionary:(NSDictionary *)dictionary
													   entity:(NSEntityDescription *)entity
										 managedObjectContext:(NSManagedObjectContext *)moc {
	
	Class<DCTManagedObjectAutomatedSetup> myself = (Class<DCTManagedObjectAutomatedSetup>)self;
	
	NSArray *localPrimaryKeys = nil;
	
	if ([self respondsToSelector:@selector(dct_uniqueKeys)])
		localPrimaryKeys = [myself dct_uniqueKeys];
		
	if (!localPrimaryKeys) {
		NSRange range = [[entity name] rangeOfCharacterFromSet:[NSCharacterSet uppercaseLetterCharacterSet] options:NSBackwardsSearch];
		NSString *localPrimaryKey = [[[[entity name] substringFromIndex:range.location] lowercaseString] stringByAppendingString:@"ID"];
		localPrimaryKeys = [NSArray arrayWithObject:localPrimaryKey];
		
#if defined (DCTManagedObjectAutomatedSetupLogAutomaticPrimaryKeyUse)
			NSLog(@"%@ (DCTManagedObjectAutomatedSetup): Cannot determine primary keys, using '%@\'", NSStringFromClass([self class]), localPrimaryKey);
#endif
		
	}
	
	for (NSString *localPrimaryKey in localPrimaryKeys) {
		if (![[[entity propertiesByName] allKeys] containsObject:localPrimaryKey]) {
			
#if defined (DCTManagedObjectAutomatedSetupLogExtremeFailures)
				NSLog(@"!!!!! DCTManagedObjectAutomatedSetup: Cannot resolve a primary key for %@, so duplicate objects will not be found.", [entity name]);
#endif
			
			return nil;	
		}
	}
	
	NSMutableArray *predicates = [[NSMutableArray alloc] initWithCapacity:[localPrimaryKeys count]];
		
	for (NSString *localPrimaryKey in localPrimaryKeys) {
		
		NSString *remotePrimaryKey = nil;
		
		if ([[dictionary allKeys] containsObject:localPrimaryKey])
			remotePrimaryKey = localPrimaryKey;
		
		if ([self respondsToSelector:@selector(dct_mappingFromRemoteNamesToLocalNames)]) {
			NSDictionary *mapping = [myself dct_mappingFromRemoteNamesToLocalNames];
			
			if ([[mapping allValues] containsObject:localPrimaryKey]) {
				NSString *pKey = [mapping dct_keyForObject:localPrimaryKey];
				if (pKey) remotePrimaryKey = pKey;
			}
		}
		
		if (!remotePrimaryKey)
			remotePrimaryKey = @"id";
		
		id primaryKeyValue = [dictionary objectForKey:remotePrimaryKey];
		
		NSDictionary *attributesByName = [entity attributesByName];
		NSDictionary *relationshipsByName = [entity relationshipsByName];
		
		BOOL objectIsValid = NO;
		
		if ([[attributesByName allKeys] containsObject:localPrimaryKey]) {
			NSAttributeDescription *attribute = [attributesByName objectForKey:localPrimaryKey];
			objectIsValid = [attribute dct_isObjectValid:primaryKeyValue];
			
		} else if ([[relationshipsByName allKeys] containsObject:localPrimaryKey]) {
			NSRelationshipDescription *relationship = [relationshipsByName objectForKey:localPrimaryKey];
			NSEntityDescription *destinationEntity = [relationship destinationEntity];
			objectIsValid = [destinationEntity dct_isObjectValid:primaryKeyValue];				
		}
		
		if (!objectIsValid && [self respondsToSelector:@selector(dct_convertValue:toCorrectTypeForKey:)])
			primaryKeyValue = [myself dct_convertValue:primaryKeyValue toCorrectTypeForKey:localPrimaryKey];
		
		if ([primaryKeyValue isKindOfClass:[NSString class]])
			primaryKeyValue = [primaryKeyValue stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"];
		
		[predicates addObject:[NSPredicate dct_predicateWhereProperty:localPrimaryKey equals:primaryKeyValue]];
	}
	
	NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
	
	return [moc dct_fetchAnyObjectForEntityName:[entity name] predicate:predicate];
	
}

@end
