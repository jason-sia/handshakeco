//
//  ViewController.h
//  Permissions
//
//  Created by Emil Izgin on 26/03/14.
//  Copyright (c) 2014 Emil Izgin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface FindIDViewController : UITableViewController<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *m_aryApproved;
}

@property (strong, nonatomic) IBOutlet UITextField *m_txtFindName;
@property (strong, nonatomic) IBOutlet UILabel *m_lblWelcomeTitle;
@property (strong, nonatomic) IBOutlet UITextField *m_txtYourName;
@property (strong, nonatomic) IBOutlet UITextField *m_txtYourEmail;
@property (strong, nonatomic) IBOutlet UITableView *m_tblApproved;


@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (weak, nonatomic) IBOutlet UILabel *uuidLabel;
@property (weak, nonatomic) IBOutlet UILabel *majorLabel;
@property (weak, nonatomic) IBOutlet UILabel *minorLabel;
@property (weak, nonatomic) IBOutlet UILabel *identityLabel;
@property (strong, nonatomic) NSDictionary *beaconPeripheralData;
@property (strong, nonatomic) CBPeripheralManager *peripheralManager;



@property (weak, nonatomic) IBOutlet UILabel *beaconFoundLabel;
@property (weak, nonatomic) IBOutlet UILabel *proximityUUIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *accuracyLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *rssiLabel;


@property (strong, nonatomic) CLLocationManager *locationManager;



- (IBAction)OnClickViewUserInfo:(id)sender;
- (IBAction)OnClickSendRequest:(id)sender;

@end
