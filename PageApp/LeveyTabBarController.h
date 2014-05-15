//
//  LeveyTabBarControllerViewController.h
//  LeveyTabBarController
//
//  Created by Jason Sia on 14-05-14.
//  Copyright (c) 2014 Handshake co. All rights reserved.
//
//

#import <UIKit/UIKit.h>
#import "LeveyTabBar.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "SimpleShare.h"
#import "NearbyItemsViewController.h"
#import "MBProgressHUD.h"

@class UITabBarController;
@protocol LeveyTabBarControllerDelegate;
@interface LeveyTabBarController : UIViewController <LeveyTabBarDelegate,CBPeripheralManagerDelegate, SimpleShareDelegate,NearbyItemsViewControllerDelegate>
{
    MBProgressHUD *HUD;
	LeveyTabBar *_tabBar;
	UIView      *_containerView;
	UIView		*_transitionView;
	__unsafe_unretained id<LeveyTabBarControllerDelegate> _delegate;
	NSMutableArray *_viewControllers;
	NSUInteger _selectedIndex;
	
	BOOL _tabBarTransparent;
	BOOL _tabBarHidden;
    
    NSInteger animateDriect;
        UIBarButtonItem *_findingItemsActivityIndicator;
    
        NSMutableArray *_nearbyItems;
}

// ibeacon properties start
@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (weak, nonatomic) IBOutlet UILabel *uuidLabel;
@property (weak, nonatomic) IBOutlet UILabel *majorLabel;
@property (weak, nonatomic) IBOutlet UILabel *minorLabel;
@property (weak, nonatomic) IBOutlet UILabel *identityLabel;
@property (strong, nonatomic) NSDictionary *beaconPeripheralData;
@property (strong, nonatomic) CBPeripheralManager *peripheralManager;
-(void) BroadCastNameCardStart;
-(void) BroadCastNameCardStop;
// ibeacon properties end

 @property (strong, nonatomic)  NSMutableArray *m_items;


@property (nonatomic, retain) NSMutableArray *myItemIDs;

@property(nonatomic, copy) NSMutableArray *viewControllers;

@property(nonatomic, readonly) UIViewController *selectedViewController;
@property(nonatomic) NSUInteger selectedIndex;

// Apple is readonly
@property (nonatomic, readonly) LeveyTabBar *tabBar;
@property(nonatomic,assign) id<LeveyTabBarControllerDelegate> delegate;


// Default is NO, if set to YES, content will under tabbar
@property (nonatomic) BOOL tabBarTransparent;
@property (nonatomic) BOOL tabBarHidden;

@property(nonatomic,assign) NSInteger animateDriect;

- (id)initWithViewControllers:(NSArray *)vcs imageArray:(NSArray *)arr;

- (void)hidesTabBar:(BOOL)yesOrNO animated:(BOOL)animated;
- (void)hidesTabBar:(BOOL)yesOrNO animated:(BOOL)animated driect:(NSInteger)driect;

// Remove the viewcontroller at index of viewControllers.
- (void)removeViewControllerAtIndex:(NSUInteger)index;

// Insert an viewcontroller at index of viewControllers.
- (void)insertViewController:(UIViewController *)vc withImageDic:(NSDictionary *)dict atIndex:(NSUInteger)index;

@end


@protocol LeveyTabBarControllerDelegate <NSObject>
@optional
- (BOOL)tabBarController:(LeveyTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController;
- (void)tabBarController:(LeveyTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;
@end

@interface UIViewController (LeveyTabBarControllerSupport)
@property(nonatomic, readonly) LeveyTabBarController *leveyTabBarController;
@end

