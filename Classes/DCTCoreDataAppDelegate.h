//
//  DCTCoreDataAppDelegate.h
//  DCTCoreData
//
//  Created by Daniel Tull on 26.09.2010.
//  Copyright (c) 2010 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCTCoreDataAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow *window;
	NSManagedObjectContext *managedObjectContext;
	NSManagedObjectModel *managedObjectModel;
	NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSString *)applicationDocumentsDirectory;

@end
