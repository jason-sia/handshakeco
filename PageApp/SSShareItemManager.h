//
//  SSShareItemManager.h
//  SimpleShare Demo
//
//  Created by Jason Sia on 15/05/14.
//  Copyright (c) 2014 Handshakeco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@class AppDelegate;
@class SSShareItemManager;


@protocol SSShareItemManagerDelegate <NSObject>
- (void)shareItemManagerDidFailWithMessage:(NSString *)failMessage;
@end

@interface SSShareItemManager : NSObject <CBPeripheralManagerDelegate>

@property (nonatomic, assign) id <SSShareItemManagerDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *myItemIDs;
@property (nonatomic, assign) BOOL isReadyToAdvertise;

- (void)startAdvertisingItems:(id)sender;
- (void)stopAdvertisingItems:(id)sender;
-(BOOL)isPeripheralAdvertising:(id)sender;

@end
