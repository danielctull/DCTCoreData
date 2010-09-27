//
//  NSManagedObject+DCTAutomatedSetup.h
//  DCTCoreData
//
//  Created by Daniel Tull on 11.08.2010.
//  Copyright (c) 2010 Daniel Tull. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (DCTAutomatedSetup)


/*
 Call this on the managed object class you wish to setup.  
 */

+ (id)dct_objectForDictionary:(NSDictionary *)dictionary managedObjectContext:(NSManagedObjectContext *)moc;

/*
 If you already have an object that represents the dictionary, 
 you can call this to run through the same setup proceedure.
*/

- (BOOL)dct_setupFromDictionary:(NSDictionary *)dictionary;

@end




/*
 Any object that wants the ability to have its setup automated MUST conform to 
 this protocol. It needn't implement any of the methods for it, but it must 
 declare that it conforms to this protocol.
 */
@protocol DCTManagedObjectAutomatedSetup <NSObject>
@optional


/*
 Add this method if the core data entity name differs to the class.
 
 If this method does not exist, the class name is used as the enity name.
 */
+ (NSString *)dct_entityName;

/*
 Override this method to handle the setup manually, returning the setup object.
 
 If this method returns nil, the automated setup will continue to run.
 */
+ (id)dct_handleObjectForDictionary:(NSDictionary *)dictionary;

/*
 Give the key for the attribute to check for equality showing two managed objects are the same.
 
 If not implemented, the setup will try to locate an attribute named like so:
 
 Last camel-cased word of entity name, lowercased, plus "ID" on the end. 
 Examples: 
 An entity "Person" will lead to an attribute of name "personID".
 An entity "DTPerson" will lead to an attribute of name "personID".
 An entity "DTTwitterPerson" will lead to an attribute of name "personID".
 
 Implement this method if the unique attribute for the object is not named in this fashion.
 
 */
+ (NSString *)dct_uniqueKey;

/*
 Give the keys for the attributes to check for equality showing two managed objects are the same.
 */
+ (NSMutableArray *)dct_uniqueKeys;

/*
 Some key/value pairs in the given dictionary 
 */
- (BOOL)dct_handleKey:(NSString *)key value:(id)value;

/*
 Another option to convert the value in the dictionary to the correct type needed for the Core Data model.
 */
+ (id)dct_convertValue:(id)value toCorrectTypeForKey:(NSString *)key;

/*
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