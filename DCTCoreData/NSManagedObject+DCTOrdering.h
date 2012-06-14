/*
 NSManagedObject+DCTOrdering.h
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

#import <CoreData/CoreData.h>

@protocol DCTOrderedObject;

@interface NSManagedObject (DCTOrdering)

- (void)dct_addOrderedObject:(NSManagedObject<DCTOrderedObject> *)object forKey:(NSString *)key;
- (void)dct_addOrderedObject:(NSManagedObject<DCTOrderedObject> *)object forKey:(NSString *)key lastObject:(NSManagedObject<DCTOrderedObject> *)last;

- (void)dct_insertOrderedObject:(NSManagedObject<DCTOrderedObject> *)object atIndex:(NSUInteger)index forKey:(NSString *)key;
- (void)dct_removeOrderedObjectAtIndex:(NSUInteger)index forKey:(NSString *)key;

- (NSManagedObject<DCTOrderedObject> *)dct_orderedObjectAtIndex:(NSUInteger)index forKey:(NSString *)key;
- (NSManagedObject<DCTOrderedObject> *)dct_lastOrderedObjectForKey:(NSString *)key;
- (NSManagedObject<DCTOrderedObject> *)dct_firstOrderedObjectForKey:(NSString *)key;

- (NSArray *)dct_orderedObjectsForKey:(NSString *)key;

@end


@protocol DCTOrderedObject

@required
@property (nonatomic, retain) NSNumber *dctOrderedObjectIndex;

@optional
@property (nonatomic, retain) NSManagedObject<DCTOrderedObject> *dctPreviousOrderedObject;
@property (nonatomic, retain) NSManagedObject<DCTOrderedObject> *dctNextOrderedObject;

@end
