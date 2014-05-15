//
//  SimpleTableCell.h
//  SimpleTable
//
//  Created by Simon Ng on 28/4/12.
//  Copyright (c) 2014 Shakehandco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *prepTimeLabel;
@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;

@end
