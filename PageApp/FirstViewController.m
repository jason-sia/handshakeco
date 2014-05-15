    //
//  FirstViewController.m
//  LeveyTabBarDemo
//
//  Created by Jason Sia on 14-05-14.
//  Copyright (c) 2014 Handshake co. All rights reserved.
//
//

#import "FirstViewController.h"
#import "LeveyTabBarController.h"
#import "DBLocal.h"
#import "APPAppDelegate.h"

@implementation FirstViewController

- (void)viewDidLoad
{

    
    [super viewDidLoad];
    
    
    // Show progress
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Uploading";
    [hud show:YES];
        
	//self.view.backgroundColor = [UIColor yellowColor];
    UIImageView *img=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.png"]];
    [self.view addSubview:img];
    
    UIImageView *profilepic=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.png"]];
    [self.view addSubview:profilepic];
    
    UITextField *textFieldName = [[UITextField alloc] initWithFrame:CGRectMake(36, 148-50, 258, 30)];
    textFieldName.delegate = self;
    //textFieldName.edia
    //textField.text = string;
    
   // UITextField * lblName = [UITextField alloc]; // initWithImage:[UIImage imageNamed:@"bg.png"]];
    [self.view addSubview:textFieldName];

    UITextField *textFieldJob = [[UITextField alloc] initWithFrame:CGRectMake(36, 199-50, 258, 30)];
    textFieldJob.delegate = self;
    [self.view addSubview:textFieldJob];
    
    
    /*
    UILabel* lblDesc = [UILabel alloc]; // initWithImage:[UIImage imageNamed:@"bg.png"]];
    [self.view addSubview:lblDesc];
*/
   // UIImageView *highres=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.png"]];
   // [self.view addSubview:highres];
    
    
    DBLocal* db = [DBLocal alloc]; //)]
    [db findContact:0];

    PFQuery *query = [PFQuery queryWithClassName:@"ContactDB"];
    [query whereKey:@"uuid" equalTo:db.getUUID];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (!error) {
                    [HUD hide:YES];
        // The find succeeded. The first 100 objects are available in objects
        PFObject *object = [objects objectAtIndex:0];
        //Recipe *recipe = [[Recipe alloc] init];
        textFieldName.text = [object objectForKey:@"name"];
        textFieldJob.text = [object objectForKey:@"job"];
        
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
        
        
        /*
        recipe.prepTime = [object objectForKey:@"prepTime"];
        recipe.ingredients = [object objectForKey:@"ingredients"];
        lblName.text =*/
    } else {
                    [HUD hide:YES];
        // Log details of the failure
        NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    

   // PFUser *user = [query getObjectWithId:userID];

   // [img release];
}

- (IBAction) flip: (id) sender {
    UISwitch *onoff = (UISwitch *) sender;
    NSLog(@"%@", onoff.on ? @"On" : @"Off");
    
    //LeveyTabBarController* tab = (LeveyTabBarController *)self.parentViewController;
            APPAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
            //[appDelegate initMain];
    if (onoff.on){
        [appDelegate.leveyTabBarController BroadCastNameCardStart];
    }
    else {
        [appDelegate.leveyTabBarController BroadCastNameCardStop];
    
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    BOOL editable;
     editable = NO;
     /*
    if (textField == myReadOnlyTextField) {
        editable = NO;
    } else if (textField == myEditableTextField) {
        editable = YES;
    } else {
        // editable = YES/NO/Other Logic
    }*/
    return editable;
}

@end
