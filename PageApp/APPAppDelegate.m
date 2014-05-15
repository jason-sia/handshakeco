//
//  APPAppDelegate.m
//  ShakeHandApp
//
//  Created by Jason Bandilla Sia 12/05/14.
//  Copyright (c) 2014 Handshake Co.. All rights reserved.

#import "APPAppDelegate.h"

#import "APPViewController.h"

#import "FirstViewController.h"
#import "SecondViewController.h"
#import "SimpleTableViewController.h"
//#import "LeveyTabBarController.h"
#import "SimpleShare.h"
#import "DBLocal.h"
#import <sqlite3.h>

@implementation APPAppDelegate

- (void)initMain {
    FirstViewController *firstVC = [[FirstViewController alloc] init];
	SecondViewController *secondVC = [[SecondViewController alloc] init];
//	UITableViewController *thirdVC = [[UITableViewController alloc] init];

//	UITableViewController *thirdVC = [[NearbyItemsViewController alloc] init];
    SimpleTableViewController *thirdVC = [[SimpleTableViewController alloc] initWithNibName:@"SimpleTableViewController" bundle:nil];
    
	UIViewController *fourthVC = [[UIViewController alloc] init];
	fourthVC.view.backgroundColor = [UIColor grayColor];
    
	//FirstViewController *fifthVC = [[FirstViewController alloc] init];
	UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:secondVC];
	nc.delegate = self;
	//[secondVC release];
	NSArray *ctrlArr = [NSArray arrayWithObjects:firstVC,thirdVC,nc,fourthVC,nil];
	//[firstVC release];
	//[nc release];
	//[thirdVC release];
	//[fourthVC release];
	//[fifthVC release];
		
	NSMutableDictionary *imgDic = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic setObject:[UIImage imageNamed:@"001_1.png"] forKey:@"Default"];
	[imgDic setObject:[UIImage imageNamed:@"001.png"] forKey:@"Highlighted"];
	[imgDic setObject:[UIImage imageNamed:@"001.png"] forKey:@"Seleted"];
	NSMutableDictionary *imgDic2 = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic2 setObject:[UIImage imageNamed:@"002_2.png"] forKey:@"Default"];
	[imgDic2 setObject:[UIImage imageNamed:@"002.png"] forKey:@"Highlighted"];
	[imgDic2 setObject:[UIImage imageNamed:@"002.png"] forKey:@"Seleted"];
	NSMutableDictionary *imgDic3 = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic3 setObject:[UIImage imageNamed:@"003_3.png"] forKey:@"Default"];
	[imgDic3 setObject:[UIImage imageNamed:@"003.png"] forKey:@"Highlighted"];
	[imgDic3 setObject:[UIImage imageNamed:@"003.png"] forKey:@"Seleted"];
	NSMutableDictionary *imgDic4 = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic4 setObject:[UIImage imageNamed:@"004_4.png"] forKey:@"Default"];
	[imgDic4 setObject:[UIImage imageNamed:@"004.png"] forKey:@"Highlighted"];
	[imgDic4 setObject:[UIImage imageNamed:@"004.png"] forKey:@"Seleted"];
//	NSMutableDictionary *imgDic5 = [NSMutableDictionary dictionaryWithCapacity:3];
//	[imgDic5 setObject:[UIImage imageNamed:@"1.png"] forKey:@"Default"];
//	[imgDic5 setObject:[UIImage imageNamed:@"2.png"] forKey:@"Highlighted"];
//	[imgDic5 setObject:[UIImage imageNamed:@"2.png"] forKey:@"Seleted"];
	
	NSArray *imgArr = [NSArray arrayWithObjects:imgDic,imgDic2,imgDic3,imgDic4,nil];
	
	self.leveyTabBarController = [[LeveyTabBarController alloc] initWithViewControllers:ctrlArr imageArray:imgArr];
	[self.leveyTabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"c-2-1.png"]];
	[self.leveyTabBarController setTabBarTransparent:YES];
        [self.window addSubview:self.leveyTabBarController.view];
    
        // Override point for customization after application launch.
        //[self.window makeKeyAndVisible];
        
        [self.window makeKeyAndVisible];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [SimpleShare sharedInstance].simpleShareAppID = @"16C44370-4252-48BD-8C07-C74B0AFCDF6C";
    
    // ****************************************************************************
    // Fill in with your Parse credentials:
    // ****************************************************************************
    // [Parse setApplicationId:@"YOUR_APPLICATION_ID" clientKey:@"YOUR_CLIENT_KEY"];
    [Parse setApplicationId:@"idi3QQPPISRyFmQIqy1cjjiiE4yICoHqLcwg9dMG"
              clientKey:@"Cjc6UBSv3XegJEI1gaRpeA25zSlQtY7xJV6QRBAk"];
    
    
    // Wipe out old user defaults
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"objectIDArray"]){
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"objectIDArray"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Simple way to create a user or log in the existing user
    // For your app, you will probably want to present your own login screen
    PFUser *currentUser = [PFUser currentUser];

    if (!currentUser) {
        // Dummy username and password
        PFUser *user = [PFUser user];


                CFUUIDRef udid = CFUUIDCreate(NULL);
                NSString *udidString = (NSString *) CFBridgingRelease(CFUUIDCreateString(NULL, udid));
        
        user.username = udidString;
        user.password = @"handshakeco0601";
        user.email =  [NSString stringWithFormat:@"%@@gmail.com", udidString];
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                // Assume the error is because the user already existed.
                [PFUser logInWithUsername:@"jasonbsia2" password:@"handshakeco0601"];
            }
        }];
        self.startUpFlag = 0;
    }
    else
    {
        self.startUpFlag = 1;
    }
    
    
    [PFUser enableAutomaticUser];
    
    PFACL *defaultACL = [PFACL ACL];

    // If you would like all objects to be private by default, remove this line.
    [defaultACL setPublicReadAccess:YES];
    
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    
    
    // build database
    [self buildDB];    
    
    DBLocal* db = [DBLocal alloc]; //)]
    [db findContact:0];
    
    if ([db getName].length>0)
        self.startUpFlag = 1;
    
    // check if setup or tab bar
    if (self.startUpFlag==0)
    {
        //[self initMain];
        //[self.window addSubview:self.leveyTabBarController.view];
    
        // Override point for customization after application launch.
        self.viewController = [[APPViewController alloc] initWithNibName:@"APPViewController" bundle:nil];
        self.window.rootViewController = self.viewController;
        //[self.window makeKeyAndVisible];
        
        [self.window makeKeyAndVisible];
        
    }
    else{
        //self.viewController = [[APPViewController alloc] initWithNibName:@"APPViewController" bundle:nil];
        //self.window.rootViewController = self.viewController;
    
    
        [self initMain];
        //[self.window addSubview:self.leveyTabBarController.view];
    
        // Override point for customization after application launch.
        //[self.window makeKeyAndVisible];
        
        //[self.window makeKeyAndVisible];
    }
    return YES;
}

- (void)buildDB {
    NSString *docsDir;
    NSArray *dirPaths;
     UILabel *_status;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(
      NSDocumentDirectory, NSUserDomainMask, YES);

    docsDir = dirPaths[0];
    sqlite3 *_contactDB;

    // Build the path to the database file
    NSString* _databasePath = [[NSString alloc]
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


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
//	if ([viewController isKindOfClass:[SecondViewController class]])
//	{
//        [leveyTabBarController hidesTabBar:NO animated:YES]; 
//	}
    
    if (viewController.hidesBottomBarWhenPushed)
    {
        [self.leveyTabBarController hidesTabBar:YES animated:YES];
    }
    else
    {
        [self.leveyTabBarController hidesTabBar:NO animated:YES];
    }
}


@end
