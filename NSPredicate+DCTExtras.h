/*
 NSPredicate+DCTExtras.h
 DCTCoreData
 
 Created by Daniel Tull on 16.06.2010.
 
 
 
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

@interface NSPredicate (DCTExtras)

/** Returns a predictate where the given name or keypath equals the given object.
 
 @param nameOrKeyPath This can be the property name, a keypath as an NSString or an NSArray
 @param object The object to compare
 */
+ (NSPredicate *)dct_predicateWhereProperty:(id)nameOrKeyPath equals:(id)object;

/** Returns a predictate where the given name or keypath is greater than the given object.
 
 @param nameOrKeyPath This can be the property name, a keypath as an NSString or an NSArray
 @param object The object to compare
 */
+ (NSPredicate *)dct_predicateWhereProperty:(id)nameOrKeyPath isGreaterThan:(id)object;

/** Returns a predictate where the given name or keypath is less than the given object.
 
 @param nameOrKeyPath This can be the property name, a keypath as an NSString or an NSArray
 @param object The object to compare
 */
+ (NSPredicate *)dct_predicateWhereProperty:(id)nameOrKeyPath isLessThan:(id)object;

/** Returns a predictate where the given name or keypath does not equal the given object.
 
 @param nameOrKeyPath This can be the property name, a keypath as an NSString or an NSArray
 @param object The object to compare
 */
+ (NSPredicate *)dct_predicateWhereProperty:(id)nameOrKeyPath doesNotEqual:(id)object;

/** Returns a predictate where the given name or keypath is tested for nil.
 
 @param nameOrKeyPath This can be the property name, a keypath as an NSString or an NSArray
 */
+ (NSPredicate *)dct_predicateWherePropertyIsNil:(NSString *)name;

/** Returns a predictate where the given name or keypath is tested for not nil.
 
 @param nameOrKeyPath This can be the property name, a keypath as an NSString or an NSArray
 */
+ (NSPredicate *)dct_predicateWherePropertyIsNotNil:(NSString *)name;

/** Returns a predictate where the given name or keypath is tested for not nil and not empty.
 
 @param nameOrKeyPath This can be the property name, a keypath as an NSString or an NSArray
 */
+ (NSPredicate *)dct_predicateWhereStringPropertyIsNotNilAndNotEmpty:(NSString *)name;

@end
