//
//  ViewController.m
//  Permissions
//
//  Created by Emil Izgin on 26/03/14.
//  Copyright (c) 2014 Emil Izgin. All rights reserved.
//

#import <Parse/Parse.h>
#import "FindIDViewController.h"
#import "APPAppDelegate.h"

@interface FindIDViewController ()

@end

@implementation FindIDViewController
@synthesize m_txtFindName;
@synthesize m_lblWelcomeTitle;
@synthesize m_txtYourEmail;
@synthesize m_txtYourName;
@synthesize m_tblApproved;

APPAppDelegate *appDelegate;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self initRegion];
    [self locationManager:self.locationManager didStartMonitoringForRegion:self.beaconRegion];
    appDelegate = [[UIApplication sharedApplication] delegate];
    m_aryApproved = [[NSMutableArray alloc] init];
    
}

#pragma --
#pragma TableView Delegates

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [m_aryApproved count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *strCellIdentifier = @"ApprovedCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strCellIdentifier];
    if(cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCellIdentifier];
    
    UILabel *lblName = (UILabel *)[cell viewWithTag:1];
    lblName.text = [m_aryApproved objectAtIndex:indexPath.row];
    
     return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    PFObject *myInfo = appDelegate.myInfo;
    m_lblWelcomeTitle.text = [NSString stringWithFormat:@"Welcome %@ %@",
                              [myInfo objectForKey:@"user_firstname"],
                              [myInfo objectForKey:@"user_lastname"]];
    
    m_txtFindName.text = @"";
    
    //search user info from tblMain table of Parse.com by using inputed user name
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"response_id = %@", appDelegate.myInfo.objectId];
    PFQuery *query = [PFQuery queryWithClassName:@"tblRelation" predicate:pred];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error)
     {
         if(error)
         {
             NSLog(@"%@", [error description]);
         }
         else
         {
             if(comments.count == 0)
             {
                 NSLog(@"No User");
             }
             else
             {
                 for(int nI = 0; nI < comments.count; nI++)
                 {
                     PFObject *yourInfo = (PFObject *)[comments objectAtIndex:nI];
                     if(![[yourInfo objectForKey:@"approval"] isEqualToString:@"1"]) continue;
                     
                     NSPredicate *pred = [NSPredicate predicateWithFormat:@"objectId = %@", [yourInfo objectForKey:@"request_id"]];
                     PFQuery *query = [PFQuery queryWithClassName:@"tblMain" predicate:pred];
                     
                     [query findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error)
                      {
                          if(error)
                          {
                              NSLog(@"%@", [error description]);
                          }
                          else
                          {
                              PFObject *approvedObj = (PFObject *)[comments objectAtIndex:0];
                              [m_aryApproved addObject:[NSString stringWithFormat:@"%@ %@", [approvedObj objectForKey:@"user_firstname"], [approvedObj objectForKey:@"user_lastname"]]];
                              [m_tblApproved reloadData];
                          }
                      }];
                     
                 }
             }
             
         }
     }];

}

- (IBAction)OnClickViewUserInfo:(id)sender {
    if([m_txtFindName.text isEqualToString:@""] || m_txtFindName == nil)
        return;
    
    //search user info from tblMain table of Parse.com by using inputed user name
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"user_id = %@", m_txtFindName.text];
    PFQuery *query = [PFQuery queryWithClassName:@"tblMain" predicate:pred];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error)
     {
         if(error)
         {
             NSLog(@"%@", [error description]);
         }
         else
         {
             if(comments.count == 0)
             {
                 NSLog(@"No User");
             }
             else
             {
                 PFObject *yourInfo = (PFObject *)[comments objectAtIndex:0];
                 appDelegate.yourInfo = yourInfo;
                 
                 m_txtYourName.text = [NSString stringWithFormat:@"%@ %@", [yourInfo objectForKey:@"user_firstname"], [yourInfo objectForKey:@"user_lastname"]];
                 m_txtYourEmail.text = [yourInfo objectForKey:@"user_email"];
             }
             
             //[self performSegueWithIdentifier:@"seg_GotoPush" sender:nil];
         }
     }];
}




- (IBAction)OnClickSendRequest:(id)sender {
    PFObject *myInfo = appDelegate.myInfo;
    PFObject *yourInfo = appDelegate.yourInfo;
    
    //save a record to tblRelation table of Parse.com
    PFObject *relation = [PFObject objectWithClassName:@"tblRelation"];
    
    //save request_id and response_id
    [relation setObject:myInfo.objectId forKey:@"request_id"];
    [relation setObject:yourInfo.objectId forKey:@"response_id"];
    
    NSString *alertMsg = [NSString stringWithFormat:@"%@ requested for your profile", [myInfo objectForKey:@"user_firstname"]];
    [relation setObject:alertMsg forKey:@"request_content"];
    
    [relation saveInBackgroundWithBlock:^(BOOL successed, NSError *error)
     {
         if (error) {
             NSLog(@"%@", error);
         }
         else {
             
             NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                                   alertMsg, @"alert",
                                   @"Increment", @"badge",
                                   nil];
             
             //send push notification with response's channel
             PFPush *push = [[PFPush alloc] init];
             [push setData:data];
             [push setChannel:[yourInfo objectForKey:@"channel"]];
             [push sendPushInBackground];
            
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                             message:@"Your request sent successfully"
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil, nil];
             [alert show];
         }
     }];

}

#pragma mark TextFielDelegate

-(BOOL)textFieldShouldReturn:(UITextField*) textField
{
    [textField resignFirstResponder];
    
    return TRUE;
}


- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

- (void)initRegion {
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"11112222-3333-4444-5555-666677778888"];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"com.shakehandco.BizCardXchange"];
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
     [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"Beacon Found");
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"Left Region");
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
    self.beaconFoundLabel.text = @"No";
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    CLBeacon *beacon = [[CLBeacon alloc] init];
    beacon = [beacons lastObject];
    
    self.beaconFoundLabel.text = @"Yes";
    self.proximityUUIDLabel.text = beacon.proximityUUID.UUIDString;
    self.majorLabel.text = [NSString stringWithFormat:@"%@", beacon.major];
    m_txtFindName.text =[NSString stringWithFormat:@"%@", beacon.major];
    self.minorLabel.text = [NSString stringWithFormat:@"%@", beacon.minor];
    self.accuracyLabel.text = [NSString stringWithFormat:@"%f", beacon.accuracy];
    if (beacon.proximity == CLProximityUnknown) {
        self.distanceLabel.text = @"Unknown Proximity";
    } else if (beacon.proximity == CLProximityImmediate) {
        self.distanceLabel.text = @"Immediate";
        //
        //        //search user info from tblMain table of Parse.com by using inputed user name
        //        NSPredicate *pred = [NSPredicate predicateWithFormat:@"user_id = %@",   m_txtFindName.text];
        //
        //        PFQuery *query = [PFQuery queryWithClassName:@"tblMain" predicate:pred];
        //
        //        [query findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error)
        //         {
        //             if(error)
        //             {
        //                 NSLog(@"%@", [error description]);
        //             }
        //             else
        //             {
        //                 PFObject *yourInfo = (PFObject *)[comments objectAtIndex:0];
        //                 appDelegate.yourInfo = yourInfo;
        //                 NSLog(@"B4 button");
        //                 [self performSegueWithIdentifier:@"seg_GotoPush" sender:nil];
        //             }
        //         }];
        
        
    } else if (beacon.proximity == CLProximityNear) {
        self.distanceLabel.text = @"Near";
    } else if (beacon.proximity == CLProximityFar) {
        self.distanceLabel.text = @"Far";
    }
    self.rssiLabel.text = [NSString stringWithFormat:@"%li", (long)beacon.rssi];
}





@end
