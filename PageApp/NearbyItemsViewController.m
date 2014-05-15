//
//  NearbyItemsViewController.m
//  SimpleShare Demo
//
//  Created by Jason Sia on 15/05/14.
//  Copyright (c) 2014 Handshakeco. All rights reserved.
//

#import "NearbyItemsViewController.h"
#import "SimpleShare.h"

@interface NearbyItemsViewController ()
       @property (strong, nonatomic)  NSMutableArray *m_items;
@end

@implementation NearbyItemsViewController
@synthesize nearbyItemIDs = _nearbyItemIDs, delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    
}

-(void)getContactinParse:(NSString*) myUUID {
    PFQuery *query = [PFQuery queryWithClassName:@"ContactDB"];
    [query whereKey:@"uuid" equalTo:myUUID];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (!error) {
        //[HUD hide:YES];
        // The find succeeded. The first 100 objects are available in objects
        PFObject *object = [objects objectAtIndex:0];
        //Recipe *recipe = [[Recipe alloc] init];
        NSString* name = [object objectForKey:@"name"];
        NSString* job = [object objectForKey:@"job"];
        
        
        [self.m_items addObject:[NSString stringWithFormat:@"%@, %@", name,job]];
        
       // [  .view beginUpdates];
        //[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationBottom];
        //[self.tableView endUpdates];
        
        /*
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
        */
  //      [self.tableView setDataSource:self];
//          self.tableView.delegate = self;
     //      [self.tableView SetArrayData:self.m_items];
           if (self.m_items.count>0)
//                [self relo]
                [self.tableView reloadData];

        /*
        recipe.prepTime = [object objectForKey:@"prepTime"];
        recipe.ingredients = [object objectForKey:@"ingredients"];
        lblName.text =*/
    } else {
         //           [HUD hide:YES];
        // Log details of the failure
        NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

}

- (void)loadData:(NSMutableArray*)data
{
    //
    self.m_items = [[NSMutableArray alloc] initWithObjects: nil];
    for (id obj in data) {
        // Generic things that you do to objects of *any* class go here.

        if ([obj isKindOfClass:[NSString class]]) {
            // NSString-specific code.
            // check uuid in the cloud to get the name
            [self getContactinParse:obj];
            
        } else if ([obj isKindOfClass:[NSNumber class]]) {
            // NSNumber-specific code.
        }
    }
   //[m_items addObject:[NSString stringWithFormat:@"Item No. %d", num];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_nearbyItemIDs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   // UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nearbyItemCell"];
    
    //cell.textLabel.text = [_nearbyItemIDs objectAtIndex:indexPath.row];
    
    //Where we configure the cell in each row

    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell... setting the text of our cell's label
    cell.textLabel.text = [self.m_items objectAtIndex:indexPath.row];
    return cell;
    
//    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // add the item to my items
    [delegate nearbyItemsViewControllerAddedItem:[_nearbyItemIDs objectAtIndex:indexPath.row]];
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Added Item", nil) message:@"The item was added successfully." delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
    
    // remove the item from found items list
    [_nearbyItemIDs removeObjectAtIndex:indexPath.row];
    
    if ([_nearbyItemIDs count] == 0) {
        // dismiss the found items view since there are no more to add
        [self cancel:nil];
    } else {
        // reload the tableview to remove the item from the found list
        [self.tableView reloadData];
    }
    
}

#pragma mark - IBActions

-(IBAction)cancel:(id)sender
{
    [delegate nearbyItemsViewControllerDidCancel:self];
}

@end
