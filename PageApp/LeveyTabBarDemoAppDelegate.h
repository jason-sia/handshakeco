//
//  LeveyTabBarDemoAppDelegate.h
//  LeveyTabBarDemo
//
//  Created by Jason Sia on 14-05-14.
//  Copyright (c) 2014 Handshake co. All rights reserved.
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

