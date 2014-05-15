//
//  NearbyItemsViewController.h
//  SimpleShare Demo
//
//  Created by Jason Sia on 15/05/14.
//  Copyright (c) 2014 Handshakeco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@class  NearbyItemsViewController;

@protocol NearbyItemsViewControllerDelegate <NSObject>
- (void)nearbyItemsViewControllerAddedItem:(NSString *)itemID;
- (void)nearbyItemsViewControllerDidCancel:(NearbyItemsViewController *)controller;
@end

@interface NearbyItemsViewController : UITableViewController 

@property (nonatomic, assign) id <NearbyItemsViewControllerDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *nearbyItemIDs;

-(IBAction)cancel:(id)sender;
- (void)loadData:(NSMutableArray*)data;

@end
