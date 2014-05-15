//
//  APPViewController.m
//  ShakeHandApp
//
//  Created by Jason Bandilla Sia 12/05/14.
//  Copyright (c) 2014 Handshake Co.. All rights reserved.

#import "APPViewController.h"
#import "APPChildViewController.h"
#import <sqlite3.h>

@interface APPViewController ()
    @property (strong, nonatomic) NSString *databasePath;
    @property (nonatomic) sqlite3 *contactDB;
    @property (strong, nonatomic) IBOutlet UILabel *status;
@end

@implementation APPViewController

- (void)buildDB {
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

    NSFileManager *filemgr = [NSFileManager defaultManager];

    if ([filemgr fileExistsAtPath: _databasePath ] == NO)
    {
       const char *dbpath = [_databasePath UTF8String];

       if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
       {
            char *errMsg;
            const char *sql_stmt =
           "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY, NAME TEXT, JOB TEXT, UUID TEXT, IMGLOW TEXT, IMGHIGH TEXT, PROFILEPIC TEXT)";

            if (sqlite3_exec(_contactDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                 _status.text = @"Failed to create table";
            }
            else {
                // add default user
                sqlite3_stmt    *statement;
                
                CFUUIDRef udid = CFUUIDCreate(NULL);
                NSString *udidString = (NSString *) CFBridgingRelease(CFUUIDCreateString(NULL, udid));
                //[contact setObject:udidString forKey:@"uuid"];
                
                NSString *insertSQL = [NSString stringWithFormat:
                    @"INSERT INTO CONTACTS (id, name, job, uuid, imglow, imghigh, profilepic) VALUES (\"%d\", \"%@\", \"%@\", \"%@\",\"\",\"\",\"\")",
                    0, @"", @"", udidString];

                const char *insert_stmt = [insertSQL UTF8String];
                sqlite3_prepare_v2(_contactDB, insert_stmt,
                    -1, &statement, NULL);
                    if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    _status.text = @"Contact added";
                    /*_name.text = @"";
                    _address.text = @"";
                    _phone.text = @"";*/
                } else {
                 _status.text = @"Failed to add contact";
                }
                sqlite3_finalize(statement);
            }
           
            sqlite3_close(_contactDB);
        } else {
                 _status.text = @"Failed to open/create database";
        }
     }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    // build database
    [self buildDB];
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    [[self.pageController view] setFrame:[[self view] bounds]];
    
    APPChildViewController *initialViewController = [self viewControllerAtIndex:0];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (APPChildViewController *)viewControllerAtIndex:(NSUInteger)index {
        
    APPChildViewController *childViewController = [[APPChildViewController alloc] initWithNibName:@"APPChildViewController" bundle:nil];
    childViewController.index = index;
    
    return childViewController;
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(APPChildViewController *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    
    // Decrease the index by 1 to return
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(APPChildViewController *)viewController index];
    
    index++;
    
    if (index == 3) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return 3;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}

@end
