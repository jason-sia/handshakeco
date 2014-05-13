//
//  APPChildViewController.m
//  ShakeHandApp
//
//  Created by Jason Bandilla Sia 12/05/14.
//  Copyright (c) 2014 Handshake Co.. All rights reserved.

#import "APPChildViewController.h"
#import "PhotoDetailViewController.h"
#import <sqlite3.h>
#import "APPAppDelegate.h"

#define PADDING_TOP 0 // For placing the images nicely in the grid
#define PADDING 4
#define THUMBNAIL_COLS 4
#define THUMBNAIL_WIDTH 75
#define THUMBNAIL_HEIGHT 75

@interface APPChildViewController ()
    @property (strong, nonatomic) NSString *databasePath;
    @property (nonatomic) sqlite3 *contactDB;
    @property (strong, nonatomic) IBOutlet UILabel *status;
    @property (strong, nonatomic) NSString* m_filePathLow;
    @property (strong, nonatomic) NSString* m_filePathHigh;
@end

@implementation APPChildViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
        
    }
    
    return self;
    
}

- (void) findContact:(int)idx
{
     const char *dbpath = [_databasePath UTF8String];
     sqlite3_stmt    *statement;

     if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
     {
             NSString *querySQL = [NSString stringWithFormat:
               @"SELECT name, job, imglow, imghigh FROM contacts WHERE id=%d",
               idx];

             const char *query_stmt = [querySQL UTF8String];

            int nSqlStat = sqlite3_prepare_v2(_contactDB,
                 query_stmt, -1, &statement, NULL);
             if (nSqlStat == SQLITE_OK)
             {
                     if (sqlite3_step(statement) == SQLITE_ROW)
                     {
                             NSString *name = [[NSString alloc]
                                initWithUTF8String:
                                (const char *) sqlite3_column_text(
                                  statement, 0)];
                             [self.textName setText: name];
                             NSString *job = [[NSString alloc]
                                 initWithUTF8String:(const char *)
                                 sqlite3_column_text(statement, 1)];
                             [self.textDescription setText: job];
                         
                             _m_filePathLow = [[NSString alloc]
                                 initWithUTF8String:(const char *)
                                 sqlite3_column_text(statement, 2)];

                             _m_filePathHigh = [[NSString alloc]
                                 initWithUTF8String:(const char *)
                                 sqlite3_column_text(statement, 3)];

                            if (_m_filePathHigh.length>0)
                            {
                                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,       NSUserDomainMask, YES);
                                NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
                                //NSString *filePath = [documentsPath stringByAppendingPathComponent:@"imagehigh.png"]; //Add the file name

                                NSData *pngData = [NSData dataWithContentsOfFile:_m_filePathHigh];
                                UIImage *imageHigh = [UIImage imageWithData:pngData];
                                [self.imgSmallCamera setImage:imageHigh];
                                //[self showCameraTaken];
                            }
                             _status.text = @"Match found";
                     } else {
                             _status.text = @"Match not found";
                             [self.textName setText: @""];
                             [self.textDescription setText: @""];
                     }
                     sqlite3_finalize(statement);
             }
             sqlite3_close(_contactDB);
     }
}

- (void) updateContact:(int)idx
{
     const char *dbpath = [_databasePath UTF8String];
     sqlite3_stmt    *statement;

     if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
     {
             NSString *querySQL = [NSString stringWithFormat:
               @"UPDATE contacts SET name=\"%@\", job=\"%@\" WHERE id=%d",
               [self.textName text],[self.textDescription text],  idx];

             const char *query_stmt = [querySQL UTF8String];

             if (sqlite3_prepare_v2(_contactDB,
                 query_stmt, -1, &statement, NULL) == SQLITE_OK)
             {
                     if (sqlite3_step(statement) == SQLITE_ROW)
                     {
                         
                             _status.text = @"Match found";
                     } else {
                             _status.text = @"Match not found";
                     }
                     sqlite3_finalize(statement);
             }
             sqlite3_close(_contactDB);
     }
}

- (void) updateImageContact:(int)idx
{
     const char *dbpath = [_databasePath UTF8String];
     sqlite3_stmt    *statement;

     if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
     {
             NSString *querySQL = [NSString stringWithFormat:
               @"UPDATE contacts SET imglow=\"%@\", imghigh=\"%@\" WHERE id=%d",
               _m_filePathLow,_m_filePathHigh,  idx];

             const char *query_stmt = [querySQL UTF8String];

             if (sqlite3_prepare_v2(_contactDB,
                 query_stmt, -1, &statement, NULL) == SQLITE_OK)
             {
                     if (sqlite3_step(statement) == SQLITE_ROW)
                     {
                         
                             _status.text = @"Match found";
                     } else {
                             _status.text = @"Match not found";
                     }
                     sqlite3_finalize(statement);
             }
             sqlite3_close(_contactDB);
     }
}


- (void)showCameraTaken {
        [self.labelName setHidden:YES];
        [self.textName setHidden:YES];
        [self.textDescription setHidden:YES];
        
        [self.labelTakePhoto setHidden:YES];
        //[self.btnCamera setHidden:YES];
        [self.labelPhotoC1 setHidden:NO];
        [self.labelPhotoC2 setHidden:NO];
        [self.imgSmallCamera setHidden:NO];
        //[photoScrollView setHidden:NO];

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *docsDir;
    NSArray *dirPaths;

    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(
      NSDocumentDirectory, NSUserDomainMask, YES);

    docsDir = dirPaths[0];

    // Build the path to the database file
    _databasePath = [[NSString alloc]
       initWithString: [docsDir stringByAppendingPathComponent:
       @"contacts.db"]];
    
    self.screenNumber.text = [NSString stringWithFormat:@"Screen #%d", self.index];
    
    if (self.index==0)
    {
        [self.labelName setHidden:NO];
        [self.textName setHidden:NO];
        [self.textDescription setHidden:NO];
        
        [self.labelTakePhoto setHidden:YES];
        [self.btnCamera setHidden:YES];
        [self.labelPhotoC1 setHidden:YES];
        [self.labelPhotoC2 setHidden:YES];
        [self.imgSmallCamera setHidden:YES];
        [photoScrollView setHidden:YES];
        
        [self.labelReadyC1 setHidden:YES];
        [self.labelReadyC2 setHidden:YES];
        [self.btnReady setHidden:YES];
        
        [self findContact:0];

    }
    else if (self.index==1)
    {
        [self findContact:0];
        [self.labelName setHidden:YES];
        [self.textName setHidden:YES];
        [self.textDescription setHidden:YES];
        
        [self.labelTakePhoto setHidden:NO];
        [self.btnCamera setHidden:NO];
        [self.labelPhotoC1 setHidden:YES];
        [self.labelPhotoC2 setHidden:YES];
        [self.imgSmallCamera setHidden:YES];
        [photoScrollView setHidden:YES];
        
        [self.labelReadyC1 setHidden:YES];
        [self.labelReadyC2 setHidden:YES];
        [self.btnReady setHidden:YES];
        
        if (_m_filePathHigh.length>0)
        {
            [self showCameraTaken];
        }
    }
    else if (self.index==2)
    {
        [self.labelName setHidden:YES];
        [self.textName setHidden:YES];
        [self.textDescription setHidden:YES];
        
        [self.labelTakePhoto setHidden:YES];
        [self.btnCamera setHidden:YES];
        [self.labelPhotoC1 setHidden:YES];
        [self.labelPhotoC2 setHidden:YES];
        [self.imgSmallCamera setHidden:YES];
        [photoScrollView setHidden:YES];
        
        [self.labelReadyC1 setHidden:NO];
        [self.labelReadyC2 setHidden:NO];
        [self.btnReady setHidden:NO];
    }
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (IBAction)keyboardDismissed:(id)sender {
    [sender resignFirstResponder];
    [self updateContact:0];
    
}

//camera functions

- (IBAction)cameraButtonTapped:(id)sender
{
    // Check for camera
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == YES) {
        // Create image picker controller
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        // Set source to the camera
        imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
        
        // Delegate is self
        imagePicker.delegate = self;
        
        // Show image picker
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else{
        // Device has no camera
        UIImage *image;
        int r = arc4random() % 5;
        switch (r) {
            case 0:
                image = [UIImage imageNamed:@"ParseLogo.jpg"];
                break;
            case 1:
                image = [UIImage imageNamed:@"Crowd.jpg"];
                break;
            case 2:
                image = [UIImage imageNamed:@"Desert.jpg"];
                break;
            case 3:
                image = [UIImage imageNamed:@"Lime.jpg"];
                break;
            case 4:
                image = [UIImage imageNamed:@"Sunflowers.jpg"];
                break;
            default:
                break;
        }
        
        // Resize image
        UIGraphicsBeginImageContext(CGSizeMake(640, 960));
        [image drawInRect: CGRectMake(0, 0, 640, 960)];
        UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();   
        
        NSData *imageData = UIImageJPEGRepresentation(smallImage, 0.05f);
        [self uploadImage:imageData];
        
        // save image locally here
        NSString *docsDir;
        NSArray *dirPaths;

        // Get the documents directory
        dirPaths = NSSearchPathForDirectoriesInDomains(
        NSDocumentDirectory, NSUserDomainMask, YES);

        docsDir = dirPaths[0];

        // Build the path to the database file
        NSString* imageLowRes = [[NSString alloc]
            initWithString: [docsDir stringByAppendingPathComponent:
            @"lowres.jpg"]];
        NSString* imageHighRes = [[NSString alloc]
            initWithString: [docsDir stringByAppendingPathComponent:
            @"highres.jpg"]];
        
    }
}

- (IBAction)readyButtonTapped:(id)sender
{
    APPAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    [appDelegate initMain];
}

- (void)uploadImage:(NSData *)imageData
{
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    // Set determinate mode
    HUD.mode = MBProgressHUDModeDeterminate;
    HUD.delegate = self;
    HUD.labelText = @"Uploading";
    [HUD show:YES];
    
    // Save PFFile
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            //Hide determinate HUD
            [HUD hide:YES];
            
            // Show checkmark
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            
            // The sample image is based on the work by http://www.pixelpressicons.com, http://creativecommons.org/licenses/by/2.5/ca/
            // Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
            
            // Set custom view mode
            HUD.mode = MBProgressHUDModeCustomView;
            
            HUD.delegate = self;

            // Create a PFObject around a PFFile and associate it with the current user
            PFObject *userPhoto = [PFObject objectWithClassName:@"UserPhoto"];
            [userPhoto setObject:imageFile forKey:@"imageFile"];
            
            // Set the access control list to current user for security purposes
            userPhoto.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
            
            PFUser *user = [PFUser currentUser];
            [userPhoto setObject:user forKey:@"user"];
            
            [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    
                    //NSData *data = imageData;

                    //UIImage *image = [UIImage imageWithData:data];
                    //[self.imgSmallCamera setImage:image];
                    
                    //[self refresh:nil];
                    //[self showCameraTaken];
                    
                    //save camera location
                    
                }
                else{
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
        else{
            [HUD hide:YES];
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    } progressBlock:^(int percentDone) {
        // Update your progress spinner here. percentDone will be between 0 and 100.
        HUD.progress = (float)percentDone/100;
    }];
}

- (void)setUpImages:(NSArray *)images
{
    // Contains a list of all the BUTTONS
    allImages = [images mutableCopy];
    
    // This method sets up the downloaded images and places them nicely in a grid
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSMutableArray *imageDataArray = [NSMutableArray array];
        
        // Iterate over all images and get the data from the PFFile
        for (int i = 0; i < images.count; i++) {
            PFObject *eachObject = [images objectAtIndex:i];
            PFFile *theImage = [eachObject objectForKey:@"imageFile"];
            NSData *imageData = [theImage getData];
            UIImage *image = [UIImage imageWithData:imageData];
            [imageDataArray addObject:image];
        }
                   
        // Dispatch to main thread to update the UI
        dispatch_async(dispatch_get_main_queue(), ^{
            // Remove old grid
            for (UIView *view in [photoScrollView subviews]) {
                if ([view isKindOfClass:[UIButton class]]) {
                    [view removeFromSuperview];
                }
            }
            
            // Create the buttons necessary for each image in the grid
            for (int i = 0; i < [imageDataArray count]; i++) {
                PFObject *eachObject = [images objectAtIndex:i];
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                UIImage *image = [imageDataArray objectAtIndex:i];
                [button setImage:image forState:UIControlStateNormal];
                button.showsTouchWhenHighlighted = YES;
                [button addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
                button.tag = i;
                button.frame = CGRectMake(THUMBNAIL_WIDTH * (i % THUMBNAIL_COLS) + PADDING * (i % THUMBNAIL_COLS) + PADDING,
                                          THUMBNAIL_HEIGHT * (i / THUMBNAIL_COLS) + PADDING * (i / THUMBNAIL_COLS) + PADDING + PADDING_TOP,
                                          THUMBNAIL_WIDTH,
                                          THUMBNAIL_HEIGHT);
                button.imageView.contentMode = UIViewContentModeScaleAspectFill;
                [button setTitle:[eachObject objectId] forState:UIControlStateReserved];
                [photoScrollView addSubview:button];
            }
            
            // Size the grid accordingly
            int rows = images.count / THUMBNAIL_COLS;
            if (((float)images.count / THUMBNAIL_COLS) - rows != 0) {
                rows++;
            }
            int height = THUMBNAIL_HEIGHT * rows + PADDING * rows + PADDING + PADDING_TOP;
            
            photoScrollView.contentSize = CGSizeMake(self.view.frame.size.width, height);
            photoScrollView.clipsToBounds = YES;
        });
    });
}

- (void)buttonTouched:(id)sender {
    // When picture is touched, open a viewcontroller with the image
    PFObject *theObject = (PFObject *)[allImages objectAtIndex:[sender tag]];
    PFFile *theImage = [theObject objectForKey:@"imageFile"];
    
    NSData *imageData;
    imageData = [theImage getData];
    UIImage *selectedPhoto = [UIImage imageWithData:imageData];
    PhotoDetailViewController *pdvc = [[PhotoDetailViewController alloc] init];
    
    pdvc.selectedImage = selectedPhoto;
    [self presentViewController:pdvc animated:YES completion:nil];
}

- (IBAction)refresh:(id)sender
{
    NSLog(@"Showing Refresh HUD");
    refreshHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:refreshHUD];
	
    // Register for HUD callbacks so we can remove it from the window at the right time
    refreshHUD.delegate = self;
	
    // Show the HUD while the provided method executes in a new thread
    [refreshHUD show:YES];
    
    PFQuery *query = [PFQuery queryWithClassName:@"UserPhoto"];
    PFUser *user = [PFUser currentUser];
    [query whereKey:@"user" equalTo:user];
    [query orderByAscending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            if (refreshHUD) {
                [refreshHUD hide:YES];
                
                refreshHUD = [[MBProgressHUD alloc] initWithView:self.view];
                [self.view addSubview:refreshHUD];
                
                // The sample image is based on the work by http://www.pixelpressicons.com, http://creativecommons.org/licenses/by/2.5/ca/
                // Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
                refreshHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                
                // Set custom view mode
                refreshHUD.mode = MBProgressHUDModeCustomView;
                
                refreshHUD.delegate = self;
            }
            NSLog(@"Successfully retrieved %d photos.", objects.count);
            
            // Retrieve existing objectIDs

            NSMutableArray *oldCompareObjectIDArray = [NSMutableArray array];
            for (UIView *view in [photoScrollView subviews]) {
                if ([view isKindOfClass:[UIButton class]]) {
                    UIButton *eachButton = (UIButton *)view;
                    [oldCompareObjectIDArray addObject:[eachButton titleForState:UIControlStateReserved]];
                }
            }
                        
            NSMutableArray *oldCompareObjectIDArray2 = [NSMutableArray arrayWithArray:oldCompareObjectIDArray];
            
            // If there are photos, we start extracting the data
            // Save a list of object IDs while extracting this data
            
            NSMutableArray *newObjectIDArray = [NSMutableArray array];            
            if (objects.count > 0) {
                for (PFObject *eachObject in objects) {
                    [newObjectIDArray addObject:[eachObject objectId]];
                }
            }
            
            // Compare the old and new object IDs
            NSMutableArray *newCompareObjectIDArray = [NSMutableArray arrayWithArray:newObjectIDArray];
            NSMutableArray *newCompareObjectIDArray2 = [NSMutableArray arrayWithArray:newObjectIDArray];
            if (oldCompareObjectIDArray.count > 0) {
                // New objects
                [newCompareObjectIDArray removeObjectsInArray:oldCompareObjectIDArray];
                // Remove old objects if you delete them using the web browser
                [oldCompareObjectIDArray removeObjectsInArray:newCompareObjectIDArray2];
                if (oldCompareObjectIDArray.count > 0) {
                    // Check the position in the objectIDArray and remove
                    NSMutableArray *listOfToRemove = [[NSMutableArray alloc] init];
                    for (NSString *objectID in oldCompareObjectIDArray){
                        int i = 0;
                        for (NSString *oldObjectID in oldCompareObjectIDArray2){
                            if ([objectID isEqualToString:oldObjectID]) {
                                // Make list of all that you want to remove and remove at the end
                                [listOfToRemove addObject:[NSNumber numberWithInt:i]];
                            }
                            i++;
                        }
                    }
                    
                    // Remove from the back
                    NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
                    [listOfToRemove sortUsingDescriptors:[NSArray arrayWithObject:highestToLowest]];
                    
                    for (NSNumber *index in listOfToRemove){                        
                        [allImages removeObjectAtIndex:[index intValue]];
                    }
                }
            }
            
            // Add new objects
            for (NSString *objectID in newCompareObjectIDArray){
                for (PFObject *eachObject in objects){
                    if ([[eachObject objectId] isEqualToString:objectID]) {
                        NSMutableArray *selectedPhotoArray = [[NSMutableArray alloc] init];
                        [selectedPhotoArray addObject:eachObject];
                                                
                        if (selectedPhotoArray.count > 0) {
                            [allImages addObjectsFromArray:selectedPhotoArray];                
                        }
                    }
                }
            }
            
            // Remove and add from objects before this
            [self setUpImages:allImages];
            
        } else {
            [refreshHUD hide:YES];
            
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Access the uncropped image from info dictionary
    UIImage *imageLow = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    // Access the uncropped image from info dictionary
    UIImage *imageHigh = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    // Dismiss controller
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // Resize low image
    UIGraphicsBeginImageContext(CGSizeMake(160, 240));
    [imageLow drawInRect: CGRectMake(0, 0, 160, 240)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();   
    
    // Resize high image
    UIGraphicsBeginImageContext(CGSizeMake(640, 960));
    [imageHigh drawInRect: CGRectMake(0, 0, 640, 960)];
    UIImage *bigImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();   
    
    
     /*   // save image locally here
        NSString *docsDir;
        NSArray *dirPaths;

        // Get the documents directory
        dirPaths = NSSearchPathForDirectoriesInDomains(
        NSDocumentDirectory, NSUserDomainMask, YES);

        docsDir = dirPaths[0];

        // Build the path to the database file
        NSString* imageLowRes = [[NSString alloc]
            initWithString: [docsDir stringByAppendingPathComponent:
            @"lowres.jpg"]];
        NSString* imageHighRes = [[NSString alloc]
            initWithString: [docsDir stringByAppendingPathComponent:
            @"highres.jpg"]];
    */
    // save image to file
    //
    
    // Upload image
    NSData *imageDataHigh = UIImageJPEGRepresentation(bigImage, 0.05f);
    NSData *imageDataLow = UIImageJPEGRepresentation(smallImage, 0.05f);
    
    //NSData *pngData = UIImagePNGRepresentation(image);
    //This pulls out PNG data of the image you've captured. From here, you can write it to a file:
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    //mmNSString *
    _m_filePathLow = [documentsPath stringByAppendingPathComponent:@"imageLow.png"]; //Add the file name
    [imageDataLow writeToFile:_m_filePathLow atomically:YES]; //Write the file
    //NSString *m
    _m_filePathHigh = [documentsPath stringByAppendingPathComponent:@"imageHigh.png"]; //Add the file name
    [imageDataHigh writeToFile:_m_filePathHigh atomically:YES]; //Write the file
    
    [self updateImageContact:0];
    
                    NSData *data = imageDataHigh;

                    UIImage *image = [UIImage imageWithData:data];
                    [self.imgSmallCamera setImage:image];
                    
                    //[self refresh:nil];
                    [self showCameraTaken];
    
    
    //[self uploadImage:imageDataHigh];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD hides
    [HUD removeFromSuperview];
	HUD = nil;
}


@end
