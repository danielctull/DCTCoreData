//
//  DCTCoreData.h
//  DCTFoursquare
//
//  Created by Daniel Tull on 21.01.2012.
//  Copyright (c) 2012 Daniel Tull Limited. All rights reserved.
//

#ifndef dctcoredata
#define dctcoredata_1_0     10000
#define dctcoredata_1_0_1   10001
#define dctcoredata_1_0_2   10002
#define dctcoredata_1_1     10100
#define dctcoredata_1_1_1   10101
#define dctcoredata_1_2     10200
#define dctcoredata_1_3     10300
#define dctcoredata_1_3_1   10301
#define dctcoredata_2_0     20000
#define dctcoredata_2_0_1	20001
#define dctcoredata_2_1	    20100
#define dctcoredata_2_2	    20200
#define dctcoredata         dctcoredata_2_2
#endif

#import <DCTCoreData/NSArray+DCTSortDescriptors.h>
#import <DCTCoreData/NSFetchedResultsController+DCTExtras.h>
#import <DCTCoreData/NSFetchRequest+DCTExtras.h>
#import <DCTCoreData/NSManagedObject+DCTExtras.h>
#import <DCTCoreData/NSManagedObject+DCTOrdering.h>
#import <DCTCoreData/NSManagedObject+DCTRelatedObjects.h>
#import <DCTCoreData/NSManagedObjectContext+DCTDataFetching.h>
#import <DCTCoreData/NSManagedObjectContext+DCTExtras.h>
#import <DCTCoreData/NSPredicate+DCTExtras.h>

// Automated Setup
#import "NSManagedObject+DCTAutomatedSetup.h"
#import "NSManagedObject+DCTAutomatedSync.h"

// Asynchronous
#import "NSManagedObjectContext+DCTAsynchronousDataFetching.h"
#import "NSManagedObjectContext+DCTAsynchronousTasks.h"