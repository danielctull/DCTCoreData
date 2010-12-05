//
//  DCTCoreDataAppDelegate.m
//  DCTCoreData
//
//  Created by Daniel Tull on 26.09.2010.
//  Copyright (c) 2010 Daniel Tull. All rights reserved.
//

#import "DCTCoreDataAppDelegate.h"
#import "DCTCDGroup+DCTManagedObjectAutomatedSetup.h"
#import "DCTCDItem+DCTManagedObjectAutomatedSetup.h"
#import"NSManagedObjectContext+DCTExtras.h"
#import "NSManagedObjectContext+DCTAsynchronousDataFetching.h"

@interface DCTCoreDataAppDelegate ()
- (NSDictionary *)dctInternal_initialDictionary;
- (NSDictionary *)dctInternal_updatedDictionary;
- (void)dctInternal_logGroup:(DCTCDGroup *)group;
@end

@implementation DCTCoreDataAppDelegate

@synthesize window;

- (void)dealloc {
	[window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

	NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
	
	// SETTING UP THE DICTIONARY TO IMPORT:
	
	NSDictionary *initialGroupDict = [self dctInternal_initialDictionary];
	
	NSLog(@"%@", initialGroupDict);
	
	// CREATE THE INITIAL GROUP:
	
	DCTCDGroup *group = [DCTCDGroup dct_objectForDictionary:initialGroupDict managedObjectContext:managedObjectContext];
	[self dctInternal_logGroup:group];
	
	
	// THE FOLLOWING SHOULD LOG OUT AS THE SAME OBJECT BECAUSE THE UNIQUE KEYS MATCHED:
	
	DCTCDGroup *group2 = [DCTCDGroup dct_objectForDictionary:initialGroupDict managedObjectContext:managedObjectContext];
	[self dctInternal_logGroup:group2];
	
	
	// GET AN UPDATED DICTIONARY AND SYNC SHOULD SYNC DOWN:
	
	NSDictionary *updatedGroupDict = [self dctInternal_updatedDictionary];
	[group dct_syncWithDictionary:updatedGroupDict];
	[self dctInternal_logGroup:group];
	
	
	// TRY TO SYNC THE INITIAL DICTIONARY, IT'S OLD, SO SHOULD CAUSE A SYNC TO SOURCE:
	
	[group dct_syncWithDictionary:initialGroupDict];
	
	// Make sure the context saves so we can call async methods - these make new MOCs with the persistent store from the origin MOC
	
	[managedObjectContext dct_save];
	
	// CALL THE EASY ASYNC METHODS::
	
	[managedObjectContext dct_asynchronousObjectsForEntityName:@"DCTCDItem" callbackBlock:^(NSArray *fetchedObjects, NSError *error) {
		
		if (fetchedObjects) NSLog(@"fetchedObjects: %@", fetchedObjects);

		if (error) NSLog(@"error: %@", error);
		
		if ([fetchedObjects count] > 0) {
			NSManagedObjectContext *returnedObjectsContext = [[fetchedObjects objectAtIndex:0] managedObjectContext];
			NSAssert([returnedObjectsContext isEqual:managedObjectContext], @"The returned obect's context is not the we called on.");
		}
		
	}];
	
	[managedObjectContext dct_asynchronousObjectsForEntityName:@"DCTCDGroup" callbackBlock:^(NSArray *fetchedObjects, NSError *error) {

		if (fetchedObjects) NSLog(@"fetchedObjects: %@", fetchedObjects);

		if (error) NSLog(@"error: %@", error);
		
		if ([fetchedObjects count] > 0) {
			NSManagedObjectContext *returnedObjectsContext = [[fetchedObjects objectAtIndex:0] managedObjectContext];
			NSAssert([returnedObjectsContext isEqual:managedObjectContext], @"The returned obect's context is not the we called on.");
		}
	}];
	
    [window makeKeyAndVisible];
	
	return YES;
}

- (void)dctInternal_logGroup:(DCTCDGroup *)group {
	
	NSLog(@"%@", group);
		
	for (DCTCDItem *item in group.items)
		NSLog(@"%@", item);
	
}

- (NSDictionary *)dctInternal_initialDictionary {
	NSMutableDictionary *itemDict1 = [[NSMutableDictionary alloc] init];
	[itemDict1 setObject:@"Item 19's description." forKey:@"itemDescription"];
	[itemDict1 setObject:@"19" forKey:@"remoteID"];
	
	NSMutableDictionary *itemDict2 = [[NSMutableDictionary alloc] init];
	[itemDict2 setObject:@"Item 20's description." forKey:@"itemDescription"];
	[itemDict2 setObject:@"20" forKey:@"remoteID"];
	
	
	NSMutableDictionary *groupDict = [[NSMutableDictionary alloc] init];
	[groupDict setObject:[NSNumber numberWithInteger:12] forKey:@"id"];
	[groupDict setObject:@"This is the description string for the group." forKey:@"description"];
	[groupDict setObject:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] forKey:@"date"];
	[groupDict setObject:[NSArray arrayWithObjects:itemDict1, itemDict2, nil] forKey:@"items"];
	
	[itemDict1 release];
	[itemDict2 release];
	
	return [groupDict autorelease];
}

- (NSDictionary *)dctInternal_updatedDictionary {
	NSMutableDictionary *itemDict1 = [[NSMutableDictionary alloc] init];
	[itemDict1 setObject:@"Item 19's updated description." forKey:@"itemDescription"];
	[itemDict1 setObject:@"19" forKey:@"remoteID"];
	
	NSMutableDictionary *itemDict2 = [[NSMutableDictionary alloc] init];
	[itemDict2 setObject:@"Item 20's updated description." forKey:@"itemDescription"];
	[itemDict2 setObject:@"20" forKey:@"remoteID"];
		
	NSMutableDictionary *groupDict = [[NSMutableDictionary alloc] init];
	[groupDict setObject:[NSNumber numberWithInteger:12] forKey:@"id"];
	[groupDict setObject:@"This is the updated description string for the group." forKey:@"description"];
	[groupDict setObject:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] forKey:@"date"];
	[groupDict setObject:[NSArray arrayWithObjects:itemDict1, itemDict2, nil] forKey:@"items"];
	
	[itemDict1 release];
	[itemDict2 release];
	
	return [groupDict autorelease];
}


- (NSManagedObjectContext *)managedObjectContext {
	
	NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles: nil];
	NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
	
    [persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType
											 configuration:nil
													   URL:nil
												   options:nil 
													 error:NULL];
	
	NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] init];
    [managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];
	[persistentStoreCoordinator release];
	
	return [managedObjectContext autorelease];	
}

@end
