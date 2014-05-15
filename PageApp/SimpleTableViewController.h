//
//  SimpleTableViewController.h
//  SimpleTable
//
//  Created by Simon Ng on 16/4/12.
//  Copyright (c) 2012 AppCoda. All rights reserved.
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
