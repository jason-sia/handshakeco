//
//  SimpleTableViewController.h
//  SimpleTable
//
//  Created by Jason Sia on 15/05/14.
//  Copyright (c) 2014 Shakehandco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
//
  //  NSMutableArray *tableData;
-(void)setTableData:(NSMutableArray*)tbl;
- (UITableView *)getTableView;

//- UITableView * TableView; //* mTabke;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
