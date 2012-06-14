/*
 NSManagedObject+DCTAutomatedSetup.h
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

#import <CoreData/CoreData.h>

@interface NSManagedObject (DCTAutomatedSetup)


/**
 Setup method to get the managed object inserted into the given context, from the given dictionary.
 
 Call this on the managed object class you wish to setup. 
 
 This will recursively go through the dictionary, if a nested dictionary exists it will try to find
 a relationship for the key, and set up that as a core data object using the nested dictionary.
 
 Override this method to handle the setup manually if you wish.
 
 @param dictionary The dictionary used to represent the managed object's data.
 @param moc The managed object context the resulting managed object should be inserted to.
 
 @return A managed object or nil if the setup process fails.
 */

+ (id)dct_objectFromDictionary:(NSDictionary *)dictionary insertIntoManagedObjectContext:(NSManagedObjectContext *)moc;

/**
 Sets up the object from the given dictionary.
 
 If you already have an object that represents the dictionary,  you can call this to run through the same
 setup proceedure as the class method. 
 
 This will recursively go through the dictionary, if a nested dictionary exists it will try to find
 a relationship for the key, and set up that as a core data object using the nested dictionary. 
 
 @param dictionary The dictionary used to represent the managed object's data.
 
 @return YES if the setup suceeded, NO otherwise.
*/

- (BOOL)dct_setupFromDictionary:(NSDictionary *)dictionary;

/**
 You can override this method to manually store values from the dictionary for the key.
 
 By default this method does the following:
 
 1. Calls +dct_convertValue:toCorrectTypeForKey: to perform any conversion needed
 2. If the value is an array, it will loop through each object calling this method with the object and the key
 3. If key is a modelled attribute of the receiver, calls -setValue:forKey:
 4. If key is a modelled relationship it will get a managed object for that relationship
 5. If key is a modelled to-one it will set the created managed object for the relationship
 6. If key is a modelled to-many it will add the created managed object to the set for the relationship
 
 @param value The value for the given key in the setup dictionary
 @param key The key from the setup dictionary. This will be the mapped key, if there is a mapping.
 
 @return YES if setting the value succeeded, NO if it failed.
 */
- (BOOL)dct_setSerializedValue:(id)value forKey:(NSString *)key;

@end




/**
 Any object that wants the ability to have its setup automated MUST conform to 
 this protocol. It needn't implement any of the methods for it, but it must 
 declare that it conforms to this protocol.
 */
@protocol DCTManagedObjectAutomatedSetup <NSObject>
@optional


/**
 Add this method if the core data entity name differs to the class.
 
 If this method does not exist, the class name is used as the enity name.
 */
+ (NSString *)dct_entityName;

/**
 Give the keys for the attributes to check for equality showing two managed objects are the same.
 
 If not implemented, the setup will try to locate an attribute named like so:
 
 Last camel-cased word of entity name, lowercased, plus "ID" on the end. 
 Examples: 
 An entity "Person" will lead to an attribute of name "personID".
 An entity "DTPerson" will lead to an attribute of name "personID".
 An entity "DTTwitterPerson" will lead to an attribute of name "personID".
 
 Implement this method if the unique attribute(s) for the object are not named in this fashion.
 */
+ (NSArray *)dct_uniqueKeys;

/**
 Another option to convert the value in the dictionary to the correct type needed for the Core Data model.
 */
+ (id)dct_convertValue:(id)value toCorrectTypeForKey:(NSString *)key;

/**
 This is an important method that should probably be implemented. Yuo need to return a dictionary 
 of remote keys to local keys. For example if the remote key is "updated_at" and the key for in 
 the model is "updatedAt", you need to provide a dictionary like so:
 
 {
 "updated_at" => "updatedAt";
 }
 
 The automated setup will then do the neccessary conversion to make sure the remote keys and 
 local keys align. 
 
 **WARNING** It is sometimes necesary to convert the local name to remote name, thus it can in 
 certain cases look up a key using the value. Thus if you have two remote keys going to the same 
 local key, problems will likely occur. In most usage I doubt this can happen, but I may change 
 how I get this information in future.
 
 */
+ (NSDictionary *)dct_mappingFromRemoteNamesToLocalNames;
@end
