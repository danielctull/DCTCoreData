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

@interface NSManagedObject ()
- (NSDate *)dct_localUpdatedDate;
- (NSDate *)dct_remoteUpdatedDate;
@end

@implementation NSManagedObject (DCTAutomatedSync)

- (void)dct_syncWithDictionary:(NSDictionary *)dictionary {
	
	if (![self conformsToProtocol:@protocol(DCTManagedObjectAutomatedSync)]) {
		NSLog(@"%@:%@ !!! Object does not conform to DCTManagedObjectAutomatedSync.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
		return;
	}
	
	NSManagedObject<DCTManagedObjectAutomatedSync> *syncSelf = self;
	
	DCTManagedObjectAutomatedSyncStatus syncStatus = DCTManagedObjectAutomatedSyncStatusNil;
	
	if ([syncSelf respondsToSelector:@selector(dct_syncTypeForDictionary:)])
		syncStatus = [syncSelf dct_syncStatusForDictionary:dictionary];
	
	if (syncStatus == DCTManagedObjectAutomatedSyncStatusNil && [syncSelf respondsToSelector:@selector(dct_lastUpdatedDateKey:)]) {
		
		NSString *lastUpdatedKey = [syncSelf dct_lastUpdatedDateKey];
		
		NSEntityDescription *entity = [self entity];
		NSDictionary *attributesByName = [entity attributesByName];
		
		NSDate *selfLastUpdated = nil;
		
		if ([[attributesByName allKeys] containsObject:lastUpdatedKey]) {
			NSDate *date = [self valueForKey:lastUpdatedKey];
			if ([date isKindOfClass:[NSDate class]])
				selfLastUpdated = date;
		}
		
		
	}
	
	
	if (syncStatus == DCTManagedObjectAutomatedSyncStatusNil) {
		NSLog(@"%@:%@ CANNOT DETERMINE SYNC STATUS", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
		return;
	}
	
	
	if (syncStatus == DCTManagedObjectAutomatedSyncStatusUp) {
		[syncSelf dct_synchroniseToSource];
		return;
	}
	
	if (syncStatus == DCTManagedObjectAutomatedSyncStatusDown) {
		[self dct_setupFromDictionary:dictionary];
		return;
	}
	
	NSLog(@"%@:%@ Sync Status Same", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
	
}

@end
