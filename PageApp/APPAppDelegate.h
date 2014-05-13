//
//  APPAppDelegate.h
//  ShakeHandApp
//
//  Created by Jason Bandilla Sia 12/05/14.
//  Copyright (c) 2014 Handshake Co.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeveyTabBarController.h"

@class APPViewController;

@interface APPAppDelegate : UIResponder <UIApplicationDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) APPViewController *viewController;
@property (nonatomic, retain) IBOutlet LeveyTabBarController *leveyTabBarController;

@property (nonatomic) int startUpFlag;

- (void)initMain;

@end
