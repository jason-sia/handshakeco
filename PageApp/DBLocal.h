//
//  DBLocal.h
//  ShakeHandApp
//
//  Created by Jason B. Sia on 14/5/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBLocal : NSObject

- (NSString*)getName;
- (NSString*)getJob;
- (NSString*)getUUID;
- (NSString*)getImageLow;
- (NSString*)getImageHigh;
- (NSString*)getProfilePic;
- (void) findContact:(int)idx;

@end
