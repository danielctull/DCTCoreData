/*
 NSManagedObjectContext+DCTDataFetching.m
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

#import "NSManagedObjectContext+DCTDataFetching.h"
#import "NSFetchRequest+DCTExtras.h"

@implementation NSManagedObjectContext (DCTDataFetching)

#pragma mark -
#pragma mark Fetching Multiple Objects

- (NSArray *)dct_fetchObjectsForEntityName:(NSString *)entityName {
	
	return [self dct_fetchObjectsForEntityName:entityName
									 predicate:nil
							   sortDescriptors:nil
									 batchSize:DCTFetchBatchSizeNil];
}

- (NSArray *)dct_fetchObjectsForEntityName:(NSString *)entityName
								 predicate:(NSPredicate *)predicate {
	
	return [self dct_fetchObjectsForEntityName:entityName
								predicate:predicate
						  sortDescriptors:nil
								batchSize:DCTFetchBatchSizeNil];
}

- (NSArray *)dct_fetchObjectsForEntityName:(NSString *)entityName
								 predicate:(NSPredicate *)predicate
						   sortDescriptors:(NSArray *)sortDescriptors {
	
	return [self dct_fetchObjectsForEntityName:entityName
								predicate:predicate
						  sortDescriptors:sortDescriptors
								batchSize:DCTFetchBatchSizeNil];
}

- (NSArray *)dct_fetchObjectsForEntityName:(NSString *)entityName
						   sortDescriptors:(NSArray *)sortDescriptors {
	
	return [self dct_fetchObjectsForEntityName:entityName
								predicate:nil
						  sortDescriptors:sortDescriptors
								batchSize:DCTFetchBatchSizeNil];
}

// The one method that does the heavy lifting:
- (NSArray *)dct_fetchObjectsForEntityName:(NSString *)entityName
								 predicate:(NSPredicate *)predicate
						   sortDescriptors:(NSArray *)sortDescriptors
								 batchSize:(NSUInteger)batchSize {
	
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] dct_initWithEntity:entity 
															   predicate:predicate
														 sortDescriptors:sortDescriptors
															   batchSize:batchSize];
	
	NSError *error = nil;
	
	NSArray *fetchResult = [self executeFetchRequest:request error:&error];
	
	if (error) {
		NSLog(@"DCTDataFetching: Error fetching objects. %@", error);
		return nil;
	}
	
	return fetchResult;
}

#pragma mark -
#pragma mark Fetching Single Objects

- (id)dct_fetchAnyObjectForEntityName:(NSString *)entityName {

	return [self dct_fetchFirstObjectForEntityName:entityName
										 predicate:nil
								   sortDescriptors:nil];
}

- (id)dct_fetchAnyObjectForEntityName:(NSString *)entityName
                            predicate:(NSPredicate *)predicate {
	
	return [self dct_fetchFirstObjectForEntityName:entityName
										 predicate:predicate
								   sortDescriptors:nil];
}

- (id)dct_fetchFirstObjectForEntityName:(NSString *)entityName
                        sortDescriptors:(NSArray *)sortDescriptors {
	
	return [self dct_fetchFirstObjectForEntityName:entityName
										 predicate:nil
								   sortDescriptors:sortDescriptors];
}

- (id)dct_fetchFirstObjectForEntityName:(NSString *)entityName
                              predicate:(NSPredicate *)predicate
                        sortDescriptors:(NSArray *)sortDescriptors {
	
	NSArray *results = [self dct_fetchObjectsForEntityName:entityName
                                                 predicate:predicate
                                           sortDescriptors:sortDescriptors
                                                 batchSize:DCTFetchBatchSizeNil];
    
	if ([results count] < 1) return nil;
	
	return [results objectAtIndex:0];
}

#pragma mark -
#pragma mark Inserting New Objects

- (id)dct_insertNewObjectForEntityName:(NSString *)entityName {
	return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self];
}

@end
