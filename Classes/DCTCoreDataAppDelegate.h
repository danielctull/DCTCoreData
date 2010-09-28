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
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

- (NSManagedObjectContext *)managedObjectContext;

@end
