/*
 NSPredicate+DCTExtras.m
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

#import "NSPredicate+DCTExtras.h"

@interface NSPredicate (DCTExtrasInternal)
+ (NSString *)dctExtrasInternal_keyPathFromObject:(id)object;
@end

@implementation NSPredicate (DCTExtras)

+ (NSPredicate *)dct_predicateWhereProperty:(id)nameOrKeyPath equals:(id)object {
	nameOrKeyPath = [self dctExtrasInternal_keyPathFromObject:nameOrKeyPath];
	return [NSPredicate predicateWithFormat:@"%K == %@", nameOrKeyPath, object];
}

+ (NSPredicate *)dct_predicateWhereProperty:(id)nameOrKeyPath isGreaterThan:(id)object {
	nameOrKeyPath = [self dctExtrasInternal_keyPathFromObject:nameOrKeyPath];
	return [NSPredicate predicateWithFormat:@"%K > %@", nameOrKeyPath, object];
	
}

+ (NSPredicate *)dct_predicateWhereProperty:(id)nameOrKeyPath isLessThan:(id)object {
	nameOrKeyPath = [self dctExtrasInternal_keyPathFromObject:nameOrKeyPath];
	return [NSPredicate predicateWithFormat:@"%K < %@", nameOrKeyPath, object];
}

+ (NSPredicate *)dct_predicateWhereProperty:(id)nameOrKeyPath doesNotEqual:(id)object {
	nameOrKeyPath = [self dctExtrasInternal_keyPathFromObject:nameOrKeyPath];
	return [NSPredicate predicateWithFormat:@"%K != %@", nameOrKeyPath, object];
}

+ (NSPredicate *)dct_predicateWherePropertyIsNil:(id)nameOrKeyPath {
	nameOrKeyPath = [self dctExtrasInternal_keyPathFromObject:nameOrKeyPath];
	return [NSPredicate predicateWithFormat:@"%K == nil", nameOrKeyPath];
}

+ (NSPredicate *)dct_predicateWherePropertyIsNotNil:(id)nameOrKeyPath {
	nameOrKeyPath = [self dctExtrasInternal_keyPathFromObject:nameOrKeyPath];
	return [NSPredicate predicateWithFormat:@"%K != nil", nameOrKeyPath];
}

+ (NSPredicate *)dct_predicateWhereStringPropertyIsNotNilAndNotEmpty:(id)nameOrKeyPath {
	nameOrKeyPath = [self dctExtrasInternal_keyPathFromObject:nameOrKeyPath];
	return [NSPredicate predicateWithFormat:@"%K != nil && %K != ''", nameOrKeyPath, nameOrKeyPath];
}

@end

@implementation NSPredicate (DCTExtrasInternal)

+ (NSString *)dctExtrasInternal_keyPathFromObject:(id)object {
	
	if ([object isKindOfClass:[NSString class]])
		return object;
	
	if ([object isKindOfClass:[NSArray class]])
		return [object componentsJoinedByString:@"."];
	
	[NSException raise:@"Invalid parameter" format:@"%@ should be of class NSString or NSArray", object];
	return nil;
}

+ (NSPredicate *)dct_predicateWhereProperty:(NSString *)name contains:(id)object {
	return [NSPredicate predicateWithFormat:@"%K CONTAINS %@", name, object];
}

@end
