/*
 NSManagedObjectContext+DCTDataFetching.h
 DCTCoreData
 
 Created by Daniel Tull on 16.09.2009.
 
 
 
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

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (DCTDataFetching)

#pragma mark -
#pragma mark Fetching Multiple Objects

/*  If the fetch fails, the error will be logged
 */

- (NSArray *)dct_fetchObjectsForEntityName:(NSString *)entityName;

- (NSArray *)dct_fetchObjectsForEntityName:(NSString *)entityName
								 predicate:(NSPredicate *)predicate;

- (NSArray *)dct_fetchObjectsForEntityName:(NSString *)entityName
								 predicate:(NSPredicate *)predicate
						   sortDescriptors:(NSArray *)sortDescriptors;
	
- (NSArray *)dct_fetchObjectsForEntityName:(NSString *)entityName
						   sortDescriptors:(NSArray *)sortDescriptors;

- (NSArray *)dct_fetchObjectsForEntityName:(NSString *)entityName
                                 predicate:(NSPredicate *)predicate
                           sortDescriptors:(NSArray *)sortDescriptors
                                 batchSize:(NSUInteger)batchSize;

#pragma mark -
#pragma mark Fetching Single Objects

- (id)dct_fetchAnyObjectForEntityName:(NSString *)entityName;

- (id)dct_fetchAnyObjectForEntityName:(NSString *)entityName
                            predicate:(NSPredicate *)predicate;

- (id)dct_fetchFirstObjectForEntityName:(NSString *)entityName
                        sortDescriptors:(NSArray *)sortDescriptors;

- (id)dct_fetchFirstObjectForEntityName:(NSString *)entityName
                              predicate:(NSPredicate *)predicate
                        sortDescriptors:(NSArray *)sortDescriptors;

#pragma mark -
#pragma mark Inserting New Objects

- (id)dct_insertNewObjectForEntityName:(NSString *)entityName;
@end
