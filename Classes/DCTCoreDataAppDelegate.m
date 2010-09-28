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

@implementation DCTCoreDataAppDelegate

@synthesize window;

- (void)dealloc {
	[window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

	NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
	
	// SETTING UP THE DICTIONARY TO IMPORT:
	
	NSMutableDictionary *itemDict1 = [[NSMutableDictionary alloc] init];
	[itemDict1 setObject:@"Item 19's description." forKey:@"itemDescription"];
	[itemDict1 setObject:@"19" forKey:@"remoteID"];
	
	NSMutableDictionary *itemDict2 = [[NSMutableDictionary alloc] init];
	[itemDict2 setObject:@"Item 20's description." forKey:@"itemDescription"];
	[itemDict2 setObject:@"20" forKey:@"remoteID"];
	
	NSMutableDictionary *itemDict3 = [[NSMutableDictionary alloc] init];
	[itemDict3 setObject:@"This is item 19's description." forKey:@"itemDescription"];
	[itemDict3 setObject:@"19" forKey:@"remoteID"];
	
	
	NSMutableDictionary *groupDict = [[NSMutableDictionary alloc] init];
	[groupDict setObject:[NSNumber numberWithInteger:12] forKey:@"id"];
	[groupDict setObject:@"This is the description string for the group." forKey:@"description"];
	[groupDict setObject:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] forKey:@"date"];
	[groupDict setObject:[NSArray arrayWithObjects:itemDict1, itemDict2, itemDict3, nil] forKey:@"items"];
	
	NSLog(@"%@", groupDict);
	
	// CREATE THE INITIAL GROUP:
	
	DCTCDGroup *group = [DCTCDGroup dct_objectForDictionary:groupDict managedObjectContext:managedObjectContext];
	NSLog(@"%@", group);
	
	// THE FOLLOWING SHOULD LOG OUT AS THE SAME OBJECT BECAUSE THE UNIQUE KEYS MATCHED:
	
	DCTCDGroup *group2 = [DCTCDGroup dct_objectForDictionary:groupDict managedObjectContext:managedObjectContext];
	NSLog(@"%@", group2);
	
	// LOG EACH ITEM DICTIONARY:
	
	NSLog(@"%@", itemDict1);
	NSLog(@"%@", itemDict2);
	NSLog(@"%@", itemDict3);
	
	// LOG ALL OF THE GROUP'S ITEMS:
	
	for (DCTCDItem *item in group.items)
		NSLog(@"%@", item);
		
    [window makeKeyAndVisible];
	
	return YES;
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
