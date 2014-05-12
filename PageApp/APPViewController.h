//
//  APPViewController.h
//  ShakeHandApp
//
//  Created by Jason Bandilla Sia 12/05/14.
//  Copyright (c) 2014 Handshake Co.. All rights reserved.

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface APPViewController : UIViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageController;

@end
