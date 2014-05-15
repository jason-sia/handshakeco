//
//  LeveyTabBarControllerViewController.m
//  LeveyTabBarController
//
//  Created by Jason Sia on 14-05-14.
//  Copyright (c) 2014 Handshake co. All rights reserved.
//
//

#import "LeveyTabBarController.h"
#import "LeveyTabBar.h"
#import "APPAppDelegate.h"
#import "DBLocal.h"
#import "SimpleTableViewController.h"

#define kTabBarHeight 49.0f

static LeveyTabBarController *leveyTabBarController;

@implementation UIViewController (LeveyTabBarControllerSupport) 

APPAppDelegate *appDelegate;

- (LeveyTabBarController *)leveyTabBarController
{
	return leveyTabBarController;
}

@end

CBUUID *myCustomServiceUUID;

@interface LeveyTabBarController (private)
- (void)displayViewAtIndex:(NSUInteger)index;

@end

@implementation LeveyTabBarController
@synthesize myItemIDs = _myItemIDs;

@synthesize delegate = _delegate;
@synthesize selectedViewController = _selectedViewController;
@synthesize viewControllers = _viewControllers;
@synthesize selectedIndex = _selectedIndex;
@synthesize tabBarHidden = _tabBarHidden;
@synthesize animateDriect;

#pragma mark -
#pragma mark lifecycle
- (id)initWithViewControllers:(NSArray *)vcs imageArray:(NSArray *)arr
{
	self = [super init];
	if (self != nil)
	{
		_viewControllers = [NSMutableArray arrayWithArray:vcs];
		
		_containerView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
		
		_transitionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.0f, _containerView.frame.size.height - kTabBarHeight)];
		_transitionView.backgroundColor =  [UIColor groupTableViewBackgroundColor];
		
		_tabBar = [[LeveyTabBar alloc] initWithFrame:CGRectMake(0, _containerView.frame.size.height - kTabBarHeight, 320.0f, kTabBarHeight) buttonImages:arr];
		_tabBar.delegate = self;
		
        leveyTabBarController = self;
        animateDriect = 0;
	}
    
       // [self initBeacon];
    
	return self;
}

- (void)initBeacon {
    DBLocal* db = [DBLocal alloc]; //)]
    [db findContact:0];
    
      PFObject *myInfo = appDelegate.myInfo;
  //  NSString *MajorID = [myInfo objectForKey:@"user_id"];
    NSInteger MajorID = [[myInfo objectForKey:@"user_id"] integerValue];
//    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:db.getUUID ] ;
       NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"16C44370-4252-48BD-8C07-C74B0AFCDF6C"];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                major:MajorID
                                                                minor:1
                                                           identifier:@"com.shakehandco.BizCardXchange"];
}

-(void) BroadCastNameCardStart {
    [[SimpleShare sharedInstance] shareMyItems:self];
    
    /*
    self.peripheralManager =
        [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
*/
//- (IBAction)transmitBeacon:(UIButton *)sender {
    /*self.beaconPeripheralData = [self.beaconRegion peripheralDataWithMeasuredPower:nil];
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self
                                                                     queue:nil
                                                                   options:nil];
*/
}

-(void) BroadCastNameCardStop
{
    [[SimpleShare sharedInstance] stopSharingMyItems:self];
    
 //[self.peripheralManager stopAdvertising];
 //           options:nil];

}

-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        NSLog(@"Powered On");
        myCustomServiceUUID =
            [CBUUID UUIDWithString:@"16C44370-4252-48BD-8C07-C74B0AFCDF6C"];
        CBMutableService * myService = [[CBMutableService alloc] initWithType:myCustomServiceUUID primary:YES];
        [self.peripheralManager addService:myService];
        
        NSDictionary *advData =
        @{CBAdvertisementDataLocalNameKey:@"Custom Name",
          CBAdvertisementDataServiceUUIDsKey:myCustomServiceUUID};
        
        NSString * baconName = [[UIDevice currentDevice] name];
        [self.peripheralManager startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey :
            @[myCustomServiceUUID],CBAdvertisementDataLocalNameKey:baconName }];
        
        //[self.peripheralManager startAdvertising:self.beaconPeripheralData];
    } else if (peripheral.state == CBPeripheralManagerStatePoweredOff) {
        NSLog(@"Powered Off");
        [self.peripheralManager stopAdvertising];
    }
}
- (void)loadView 
{
	[super loadView];
	
	[_containerView addSubview:_transitionView];
	[_containerView addSubview:_tabBar];
	self.view = _containerView;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
    self.selectedIndex = 0;
    
    DBLocal* db = [DBLocal alloc]; //)]
    [db findContact:0];
    
//    self.myItemIDs = [[NSMutableArray alloc] initWithObjects:[[NSUUID UUID] UUIDString], [[NSUUID UUID] UUIDString], [[NSUUID UUID] UUIDString], [[NSUUID UUID] UUIDString], [[NSUUID UUID] UUIDString], nil];
    self.myItemIDs = [[NSMutableArray alloc] initWithObjects:[db getUUID], nil];
    
    // Tell SimpleShare the item IDs we are sharing
    [SimpleShare sharedInstance].delegate = self;
    [SimpleShare sharedInstance].myItemIDs = _myItemIDs;    
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	
	_tabBar = nil;
	_viewControllers = nil;
}

- (void)dealloc 
{
    _tabBar.delegate = nil;
	//[_tabBar release];
   // [_containerView release];
   // [_transitionView release];
//	[_viewControllers release];
  //  [super dealloc];
}

#pragma mark - instant methods

- (LeveyTabBar *)tabBar
{
	return _tabBar;
}

- (BOOL)tabBarTransparent
{
	return _tabBarTransparent;
}

- (void)setTabBarTransparent:(BOOL)yesOrNo
{
	if (yesOrNo == YES)
	{
		_transitionView.frame = _containerView.bounds;
	}
	else
	{
		_transitionView.frame = CGRectMake(0, 0, 320.0f, _containerView.frame.size.height - kTabBarHeight);
	}
}




- (void)hidesTabBar:(BOOL)yesOrNO animated:(BOOL)animated
{
	if (yesOrNO == YES)
	{
		if (self.tabBar.frame.origin.y == self.view.frame.size.height)
		{
			return;
		}
	}
	else 
	{
		if (self.tabBar.frame.origin.y == self.view.frame.size.height - kTabBarHeight)
		{
			return;
		}
	}
	
	if (animated == YES)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3f];
		if (yesOrNO == YES)
		{
			self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y + kTabBarHeight, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
		}
		else 
		{
			self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y - kTabBarHeight, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
		}
		[UIView commitAnimations];
	}
	else 
	{
		if (yesOrNO == YES)
		{
			self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y + kTabBarHeight, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
		}
		else 
		{
			self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y - kTabBarHeight, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
		}
	}
}


//- (void)hidesTabBar:(BOOL)yesOrNO animated:(BOOL)animated
//{
//    [self hidesTabBar:yesOrNO animated:animated driect:animateDriect];
//}
//
//- (void)hidesTabBar:(BOOL)yesOrNO animated:(BOOL)animated driect:(NSInteger)driect
//{
//    // driect: 0 -- 上下  1 -- 左右
//    
//    NSInteger kTabBarWidth = [[UIScreen mainScreen] applicationFrame].size.width;
//    
//	if (yesOrNO == YES)
//	{
//        if (driect == 0)
//        {
//            if (self.tabBar.frame.origin.y == self.view.frame.size.height)
//            {
//                return;
//            }
//        }
//        else
//        {
//            if (self.tabBar.frame.origin.x == 0 - kTabBarWidth)
//            {
//                return;
//            }
//        }
//	}
//	else 
//	{
//        if (driect == 0)
//        {
//            if (self.tabBar.frame.origin.y == self.view.frame.size.height - kTabBarHeight)
//            {
//                return;
//            }
//        }
//        else
//        {
//            if (self.tabBar.frame.origin.x == 0)
//            {
//                return;
//            }
//        }
//	}
//	
//	if (animated == YES)
//	{
//		[UIView beginAnimations:nil context:NULL];
//		[UIView setAnimationDuration:0.3f];
//		if (yesOrNO == YES)
//		{
//            if (driect == 0)
//            {
//                self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y + kTabBarHeight, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
//            }
//            else
//            {
//                self.tabBar.frame = CGRectMake(0 - kTabBarWidth, self.tabBar.frame.origin.y, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
//            }
//		}
//		else 
//		{
//            if (driect == 0)
//            {
//                self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y - kTabBarHeight, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
//            }
//            else
//            {
//                self.tabBar.frame = CGRectMake(0, self.tabBar.frame.origin.y, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
//            }
//		}
//		[UIView commitAnimations];
//	}
//	else 
//	{
//		if (yesOrNO == YES)
//		{
//            if (driect == 0)
//            {
//                self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y + kTabBarHeight, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
//            }
//            else
//            {
//                self.tabBar.frame = CGRectMake(0 - kTabBarWidth, self.tabBar.frame.origin.y, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
//            }
//		}
//		else 
//		{
//            if (driect == 0)
//            {
//                self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y - kTabBarHeight, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
//            }
//            else
//            {
//                self.tabBar.frame = CGRectMake(0, self.tabBar.frame.origin.y, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
//            }
//		}
//	}
//}
//
- (NSUInteger)selectedIndex
{
	return _selectedIndex;
}
- (UIViewController *)selectedViewController
{
    return [_viewControllers objectAtIndex:_selectedIndex];
}

-(void)setSelectedIndex:(NSUInteger)index
{
    [self displayViewAtIndex:index];
    [_tabBar selectTabAtIndex:index];
}

- (void)removeViewControllerAtIndex:(NSUInteger)index
{
    if (index >= [_viewControllers count])
    {
        return;
    }
    // Remove view from superview.
    [[(UIViewController *)[_viewControllers objectAtIndex:index] view] removeFromSuperview];
    // Remove viewcontroller in array.
    [_viewControllers removeObjectAtIndex:index];
    // Remove tab from tabbar.
    [_tabBar removeTabAtIndex:index];
}

- (void)insertViewController:(UIViewController *)vc withImageDic:(NSDictionary *)dict atIndex:(NSUInteger)index
{
    [_viewControllers insertObject:vc atIndex:index];
    [_tabBar insertTabWithImageDic:dict atIndex:index];
}

-(IBAction)findNearbyItems:(id)sender
{
    [[SimpleShare sharedInstance] findNearbyItems:self];
    
    // update UI to indicate it is looking for items
    if (_findingItemsActivityIndicator == nil) {
        UIActivityIndicatorView * activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [activityView sizeToFit];
        [activityView setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin)];
        [activityView startAnimating];
        _findingItemsActivityIndicator = [[UIBarButtonItem alloc] initWithCustomView:activityView];
        activityView = nil;
    }
    
    [self.navigationItem setRightBarButtonItem:_findingItemsActivityIndicator];

}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"addNearbyItems"]) {
        NearbyItemsViewController *_nearbyItemsController = (NearbyItemsViewController*)[self.viewControllers objectAtIndex:1];
    
        UINavigationController *navController = (UINavigationController *)[segue destinationViewController];
        _nearbyItemsController = (NearbyItemsViewController *)[navController topViewController];
        [_nearbyItemsController setDelegate:self];
        [_nearbyItemsController setNearbyItemIDs:_nearbyItems];
      }
}
#pragma mark - SimpleShare Delegate

-(void)getContactinParse:(NSString*) myUUID {
    PFQuery *query = [PFQuery queryWithClassName:@"ContactDB"];
    [query whereKey:@"uuid" equalTo:myUUID];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (!error) {
        //[HUD hide:YES];
        // The find succeeded. The first 100 objects are available in objects
        PFObject *object = [objects objectAtIndex:0];
        //Recipe *recipe = [[Recipe alloc] init];
        NSString* name = [object objectForKey:@"name"];
        NSString* job = [object objectForKey:@"job"];
        
        
        [self.m_items addObject:[NSString stringWithFormat:@"%@, %@", name,job]];
        
       // [  .view beginUpdates];
        //[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationBottom];
        //[self.tableView endUpdates];
        
        /*
        PFFile *imageFile = [object objectForKey:@"imghigh"];
          [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
              if (!error) {
                  UIImage *image = [UIImage imageWithData:data];
                    UIImageView *highres=[[UIImageView alloc] initWithImage:image ];
                    //highres
                    [highres setFrame:CGRectMake(36, 250-60, 188, 99)];
                    [self.view addSubview:highres];
                  
                // share your namecard
                UITextField *textFieldShare = [[UITextField alloc] initWithFrame:CGRectMake(36, 310, 258, 30)];
                textFieldShare.delegate = self;
                textFieldShare.text = @"Share your name card";
                [self.view addSubview:textFieldShare];
    
                //
                UISwitch *onoff = [[UISwitch alloc] initWithFrame:CGRectMake(36, 340, 60, 30)];
                [onoff addTarget: self action: @selector(flip:) forControlEvents: UIControlEventValueChanged];
                [self.view addSubview:onoff];

              }
          }];
        */
  //      [self.tableView setDataSource:self];
//          self.tableView.delegate = self;
     //      [self.tableView SetArrayData:self.m_items];
           //if (self.m_items.count>0)
//                [self relo]
                //[self.tableView reloadData];
	SimpleTableViewController *_nearbyItemsController = (SimpleTableViewController*)[self.viewControllers objectAtIndex:1];
    
    [_nearbyItemsController setTableData:self.m_items];
    [_nearbyItemsController.tableView reloadData];
        /*
        recipe.prepTime = [object objectForKey:@"prepTime"];
        recipe.ingredients = [object objectForKey:@"ingredients"];
        lblName.text =*/
    } else {
         //           [HUD hide:YES];
        // Log details of the failure
        NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

}

- (void)loadData:(NSMutableArray*)data
{
    //

    for (id obj in data) {
        // Generic things that you do to objects of *any* class go here.

        if ([obj isKindOfClass:[NSString class]]) {
            // NSString-specific code.
            // check uuid in the cloud to get the name
            [self getContactinParse:obj];
            
        } else if ([obj isKindOfClass:[NSNumber class]]) {
            // NSNumber-specific code.
        }
    }
   //[m_items addObject:[NSString stringWithFormat:@"Item No. %d", num];
}


- (void)simpleShareFoundFirstItems:(NSArray *)itemIDs
{
    // get rid of old found nearby items
    _nearbyItems = nil;
    
    _nearbyItems = [[NSMutableArray alloc] init];
    
    // add the first item to the array
    [_nearbyItems addObjectsFromArray:itemIDs];
    
    // pop up nearby items controller to show found item
    //[self performSegueWithIdentifier:@"addNearbyItems" sender:self];
   // update nearby items controller
	//NearbyItemsViewController *_nearbyItemsController = (NearbyItemsViewController*)[self.viewControllers objectAtIndex:1];
	//SimpleTableViewController *_nearbyItemsController = (SimpleTableViewController*)[self.viewControllers objectAtIndex:1];
        self.m_items = [[NSMutableArray alloc] initWithObjects: nil];
   // [_nearbyItemsController setTableData:_nearbyItems];
    //[_nearbyItemsController.tableView reloadData];
    //[_nearbyItemsController.tab
    [self loadData:_nearbyItems];
//    [_nearbyItemsController
   // [self loadData:_nearbyItems];
    
    //[_nearbyItemsController setNearbyItemIDs:_nearbyItems];
    //[_nearbyItemsController.tableView reloadData];
}

- (void)simpleShareFoundMoreItems:(NSArray *)itemIDs
{
    // add the new item to the array
    [_nearbyItems addObjectsFromArray:itemIDs];
    
	//NearbyItemsViewController *_nearbyItemsController = (NearbyItemsViewController*)[self.viewControllers objectAtIndex:1];
    
    // update nearby items controller
    //[_nearbyItemsController setNearbyItemIDs:_nearbyItems];
    [self loadData:_nearbyItems];
    
    
    //[_nearbyItemsController.tableView reloadData];
}

- (void)simpleShareFoundNoItems:(SimpleShare *)simpleShare
{
    // update UI to show it is done looking for items
    //[self.navigationItem setRightBarButtonItem:_findItemsButton];

}

- (void)simpleShareDidFailWithMessage:(NSString *)failMessage
{
    // update UI to show it is not looking for items
    //[self.navigationItem setRightBarButtonItem:_findItemsButton];
    
    // update UI to indicate it is not sharing items
   // _shareItemsButton.title = @"Share";
    //_shareItemsButton.action = @selector(shareMyItems:);

}



#pragma mark - Private methods
- (void)displayViewAtIndex:(NSUInteger)index
{
    // Before change index, ask the delegate should change the index.
    if ([_delegate respondsToSelector:@selector(tabBarController:shouldSelectViewController:)]) 
    {
        if (![_delegate tabBarController:self shouldSelectViewController:[self.viewControllers objectAtIndex:index]])
        {
            return;
        }
    }
    // If target index if equal to current index, do nothing.
    if (_selectedIndex == index && [[_transitionView subviews] count] != 0) 
    {
        return;
    }
    NSLog(@"Display View.");
    _selectedIndex = index;
    
    if (_selectedIndex==1)
    {
        [self findNearbyItems:nil];
    }
    
	UIViewController *selectedVC = [self.viewControllers objectAtIndex:index];
	
	selectedVC.view.frame = _transitionView.frame;
	if ([selectedVC.view isDescendantOfView:_transitionView]) 
	{
		[_transitionView bringSubviewToFront:selectedVC.view];
	}
	else
	{
		[_transitionView addSubview:selectedVC.view];
	}
    
    // Notify the delegate, the viewcontroller has been changed.
    if ([_delegate respondsToSelector:@selector(tabBarController:didSelectViewController::)]) 
    {
        [_delegate tabBarController:self didSelectViewController:selectedVC];
    }

}

#pragma mark -
#pragma mark tabBar delegates
- (void)tabBar:(LeveyTabBar *)tabBar didSelectIndex:(NSInteger)index
{
	if (self.selectedIndex == index) {
        UINavigationController *nav = [self.viewControllers objectAtIndex:index];
        [nav popToRootViewControllerAnimated:YES];
    }else {
        [self displayViewAtIndex:index];
    }
}

#pragma mark - NearbyItemsViewController Delegate

- (void)nearbyItemsViewControllerAddedItem:(NSString *)itemID
{
    [_myItemIDs addObject:itemID];
    
    //[self.tableView reloadData];
    
    // Update SimpleShare with the item IDs we are sharing
    [SimpleShare sharedInstance].myItemIDs = _myItemIDs;
}

- (void)nearbyItemsViewControllerDidCancel:(NearbyItemsViewController *)controller
{
    // update UI to show it is done looking for items
    //[self.navigationItem setRightBarButtonItem:_findItemsButton];
    
    // dismiss the nearby items view controller
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // stop finding nearby items
    [[SimpleShare sharedInstance] stopFindingNearbyItems:nil];

}

@end
