//
//  LeveyTabBarDemoAppDelegate.h
//  LeveyTabBarDemo
//
//  Created by zhang on 12-10-10.
//  Copyright (c) 2012年 jclt. All rights reserved.
//
//

#import <UIKit/UIKit.h>

@class LeveyTabBarController;

@interface LeveyTabBarDemoAppDelegate : NSObject <UIApplicationDelegate, UINavigationControllerDelegate> {
    UIWindow *window;
    LeveyTabBarController *leveyTabBarController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet LeveyTabBarController *leveyTabBarController;

@end

