/*
 NSManagedObject+DCTAutomatedSync.m
 DCTCoreData
 
 Created by Daniel Tull on 20.09.2010.
 
 
 
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

#import "NSManagedObject+DCTAutomatedSync.h"
#import "NSManagedObject+DCTExtras.h"
#import "NSAttributeDescription+DCTObjectCheck.h"
#import "NSDictionary+DCTKeyForObject.h"

BOOL const DCTManagedObjectAutomatedSyncLogInformationMessages = YES;
BOOL const DCTManagedObjectAutomatedSyncLogWarningMessages = YES;
BOOL const DCTManagedObjectAutomatedSyncLogErrorMessages = YES;


@interface NSManagedObject (DCTAutomatedSyncInternal)
- (NSDate *)dctAutomatedSyncInternal_localUpdatedDate;
- (NSDate *)dctAutomatedSyncInternal_updatedDateInDictionary:(NSDictionary *)dictionary;
- (NSString *)dctAutomatedSyncInternal_lastUpdatedDateKey;
@end

@implementation NSManagedObject (DCTAutomatedSync)

- (void)dct_syncWithDictionary:(NSDictionary *)dictionary {
	
	if (![self conformsToProtocol:@protocol(DCTManagedObjectAutomatedSync)]) {
		if (DCTManagedObjectAutomatedSyncLogErrorMessages)
			NSLog(@"DCTAutomatedSync !!!!! (%@) Does not conform to DCTManagedObjectAutomatedSync.", NSStringFromClass([self class]));
		return;
	}
	
	NSManagedObject<DCTManagedObjectAutomatedSync> *syncSelf = (NSManagedObject<DCTManagedObjectAutomatedSync> *)self;
	
	DCTManagedObjectAutomatedSyncStatus syncStatus = DCTManagedObjectAutomatedSyncStatusNil;
	
	if ([syncSelf respondsToSelector:@selector(dct_syncStatusForDictionary:)])
		syncStatus = [syncSelf dct_syncStatusForDictionary:dictionary];
	
	if (syncStatus == DCTManagedObjectAutomatedSyncStatusNil) {
		
		NSDate *localUpdatedDate = [self dctAutomatedSyncInternal_localUpdatedDate];
		NSDate *remoteUpdatedDate = [self dctAutomatedSyncInternal_updatedDateInDictionary:dictionary];
		
		if (!localUpdatedDate || !remoteUpdatedDate) {
			if (DCTManagedObjectAutomatedSyncLogErrorMessages)
				NSLog(@"DCTAutomatedSync !!!!! (%@) Cannot determine sync status.", NSStringFromClass([self class]));
			return;
		}
		
		NSComparisonResult comparisonResult = [localUpdatedDate compare:remoteUpdatedDate];
		
		if (comparisonResult == NSOrderedSame)
			syncStatus = DCTManagedObjectAutomatedSyncStatusNone;

		else if (comparisonResult == NSOrderedAscending)
			syncStatus = DCTManagedObjectAutomatedSyncStatusDown;
		
		else if (comparisonResult == NSOrderedDescending)
			syncStatus = DCTManagedObjectAutomatedSyncStatusUp;
		
	}	
	
	if (syncStatus == DCTManagedObjectAutomatedSyncStatusUp) {
		
		if (DCTManagedObjectAutomatedSyncLogInformationMessages)
			NSLog(@"DCTAutomatedSync (%@) Sync status up", NSStringFromClass([self class]));
		
		if ([syncSelf respondsToSelector:@selector(dct_synchroniseToSource)]) 
			[syncSelf dct_synchroniseToSource];
		return;
	}
	
	if (syncStatus == DCTManagedObjectAutomatedSyncStatusDown) {
		
		if (DCTManagedObjectAutomatedSyncLogInformationMessages)
			NSLog(@"DCTAutomatedSync (%@) Sync status down", NSStringFromClass([self class]));
		
		[self dct_setupFromDictionary:dictionary];
		return;
	}
	
	if (DCTManagedObjectAutomatedSyncLogInformationMessages)
		NSLog(@"DCTAutomatedSync (%@) Sync status same", NSStringFromClass([self class]));
	
}

@end

@implementation NSManagedObject (DCTAutomatedSyncInternal)

- (NSDate *)dctAutomatedSyncInternal_localUpdatedDate {
	
	NSString *key = [self dctAutomatedSyncInternal_lastUpdatedDateKey];
	
	if (!key) return nil;
	
	NSAttributeDescription *attribute = [self dct_attributeDescriptionForKey:key];
	
	if (!attribute || ![attribute dct_isClassValid:[NSDate class]]) return nil;
	
	return [self valueForKey:key];
}

- (NSDate *)dctAutomatedSyncInternal_updatedDateInDictionary:(NSDictionary *)dictionary {
	
	NSString *key = [self dctAutomatedSyncInternal_lastUpdatedDateKey];
	
	if (!key) return nil;
	
	NSDate *date = [dictionary objectForKey:key];
	
	Class syncClass = [(id<DCTManagedObjectAutomatedSync>)self class];
	
	if (!date && [syncClass respondsToSelector:@selector(dct_mappingFromRemoteNamesToLocalNames)]) {
		
		NSDictionary *mapping = [syncClass dct_mappingFromRemoteNamesToLocalNames];
			
		key = [mapping dct_keyForObject:key];
			
		date = [dictionary objectForKey:key];
			
		if (!date) return nil;
	}
	
	if (![date isKindOfClass:[NSDate class]]) {
		
		if (![syncClass respondsToSelector:@selector(dct_convertValue:toCorrectTypeForKey:)]) return nil;
		
		date = [syncClass dct_convertValue:date toCorrectTypeForKey:key];
		
		if (![date isKindOfClass:[NSDate class]]) return nil;
	}
	
	return date;	
}


- (NSString *)dctAutomatedSyncInternal_lastUpdatedDateKey {
	
	if ([self respondsToSelector:@selector(dct_lastUpdatedDateKey)])
		return [(id<DCTManagedObjectAutomatedSync>)self dct_lastUpdatedDateKey];

	return nil;
}

@end
