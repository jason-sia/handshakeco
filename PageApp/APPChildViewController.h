//
//  APPChildViewController.h
//  ShakeHandApp
//
//  Created by Jason Bandilla Sia 12/05/14.
//  Copyright (c) 2014 Handshake Co.. All rights reserved.

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#include <stdlib.h> // For math functions including arc4random (a number randomizer)

@interface APPChildViewController : UIViewController <UIImagePickerControllerDelegate, MBProgressHUDDelegate,UITextFieldDelegate>
{
    IBOutlet UIScrollView *photoScrollView;
    NSMutableArray *allImages;
    MBProgressHUD *HUD;
    MBProgressHUD *refreshHUD;
}
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) IBOutlet UILabel *screenNumber;
@property (strong, nonatomic) IBOutlet UILabel* labelName;
@property (strong, nonatomic) IBOutlet UITextField *textName;
@property (strong, nonatomic) IBOutlet UITextField *textDescription;
@property (strong, nonatomic) IBOutlet UIImageView *bgImage;
- (IBAction)keyboardDismissed:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel* labelTakePhoto;
@property (strong, nonatomic) IBOutlet UIButton *btnCamera;
- (IBAction)cameraButtonTapped:(id)sender;
- (IBAction)refresh:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel* labelPhotoC1;
@property (strong, nonatomic) IBOutlet UILabel* labelPhotoC2;
@property (strong, nonatomic) IBOutlet UIImageView *imgSmallCamera;

@end
