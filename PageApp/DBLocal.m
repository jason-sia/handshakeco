//
//  DBLocal.m
//  ShakeHandApp
//
//  Created by Jason B. Sia on 14/5/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import "DBLocal.h"
#import <sqlite3.h>

@interface DBLocal ()

    @property (strong, nonatomic) NSString* m_name;
    @property (strong, nonatomic) NSString* m_job;
    @property (strong, nonatomic) NSString* m_uuid;
    @property (strong, nonatomic) NSString* m_imglow;
    @property (strong, nonatomic) NSString* m_imghigh;
    @property (strong, nonatomic) NSString* m_profilepic;
    @property (strong, nonatomic) NSString* m_databasePath;
    @property (nonatomic) sqlite3 *contactDB;
@end

@implementation DBLocal

- (void)initDBPath {
    // Do any additional setup after loading the view from its nib.
    NSString *docsDir;
    NSArray *dirPaths;

    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(
      NSDocumentDirectory, NSUserDomainMask, YES);

    docsDir = dirPaths[0];

    // Build the path to the database file
    self.m_databasePath = [[NSString alloc]
       initWithString: [docsDir stringByAppendingPathComponent:
       @"contacts.db"]];
}

- (NSString*)getName {
    return self.m_name;
}

- (NSString*)getJob {
    return self.m_job;
}

- (NSString*)getUUID {
    return self.m_uuid;
}

- (NSString*)getImageLow {
    return self.m_imglow;
}

- (NSString*)getImageHigh {
    return self.m_imghigh;
}

- (NSString*)getProfilePic {
    return self.m_profilepic;
}

- (void) findContact:(int)idx
{
    [self initDBPath];
     const char *dbpath = [self.m_databasePath UTF8String];
     sqlite3_stmt    *statement;

     if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
     {
             NSString *querySQL = [NSString stringWithFormat:
               @"SELECT name, job, imglow, imghigh, uuid FROM contacts WHERE id=%d",
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
                             self.m_name = name;
                             NSString *job = [[NSString alloc]
                                 initWithUTF8String:(const char *)
                                 sqlite3_column_text(statement, 1)];
                             self.m_job = job;
                         
                             self.m_imglow = [[NSString alloc]
                                 initWithUTF8String:(const char *)
                                 sqlite3_column_text(statement, 2)];

                             self.m_imghigh = [[NSString alloc]
                                 initWithUTF8String:(const char *)
                                 sqlite3_column_text(statement, 3)];

                             self.m_uuid = [[NSString alloc]
                                 initWithUTF8String:(const char *)
                                 sqlite3_column_text(statement, 4)];

                            /*if (_m_filePathHigh.length>0)
                            {
                                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,       NSUserDomainMask, YES);
                                NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
                                //NSString *filePath = [documentsPath stringByAppendingPathComponent:@"imagehigh.png"]; //Add the file name

                                NSData *pngData = [NSData dataWithContentsOfFile:_m_filePathHigh];
                                UIImage *imageHigh = [UIImage imageWithData:pngData];
                                [self.imgSmallCamera setImage:imageHigh];
                                //[self showCameraTaken];
                            }*/
                            // _status.text = @"Match found";
                     } else {
                            // _status.text = @"Match not found";
                             self.m_name = @"";
                             self.m_job = @"";
                     }
                     sqlite3_finalize(statement);
             }
             sqlite3_close(_contactDB);
     }
}


@end
