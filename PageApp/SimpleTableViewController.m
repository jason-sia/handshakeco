//
//  SimpleTableViewController.m
//  SimpleTable
//
//  Created by Jason Sia on 15/05/14.
//  Copyright (c) 2014 Shakehandco. All rights reserved.
//

#import "SimpleTableViewController.h"
#import "SimpleTableCell.h"

@interface SimpleTableViewController ()

@end

@implementation SimpleTableViewController
{
    NSMutableArray *tableData;
}

-(void)setTableData:(NSMutableArray*)tbl
{
    tableData = tbl;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Initialize table data
//    tableData = [NSMutableArray arrayWithObjects:@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];
    tableData = [NSMutableArray arrayWithObjects: nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"creme_brelee.jpg"];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];

/*
    [button addTarget:self 
               action:@selector(aMethod:)
     forControlEvents:UIControlEventTouchDown];
    [button setTitle:@"Show View" forState:UIControlStateNormal];
    button.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    [cell.contentView addSubview:button];
*/

    return cell;
}

-(void) aMethod {
    //
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove the row from data model
    [tableData removeObjectAtIndex:indexPath.row];
    
    // Request table view to reload
    [tableView reloadData];
}

- (UITableView *)getTableView {
    //return self.;
   // self.tableVi
}

@end

