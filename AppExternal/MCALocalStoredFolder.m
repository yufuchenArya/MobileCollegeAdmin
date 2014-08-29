//
//  MCALocalStoredFolder.m
//  MobileCollegeAdmin
//
//  Created by aditi on 28/08/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MCALocalStoredFolder.h"

@implementation MCALocalStoredFolder
static NSString *rootDir;
static NSString *subRootDir;

+(void)createRootDir
{
    rootDir = [self createSubfolderWithRootDir:[self getSystemDocumentFolder] andSubDirName:ROOT_FOLDER];
}
+(void)createSubRootDir:(id)sender
{
    subRootDir = [self createSubfolderWithRootDir:rootDir andSubDirName:sender];
}

+(NSString *)createSubfolderWithRootDir:(NSString *)rootDirPath andSubDirName:(NSString *)subDirName
{
    NSString *createdDir = (NSMutableString *)[rootDirPath stringByAppendingPathComponent:subDirName];
    
    NSError *error;
    if (![[NSFileManager defaultManager] createDirectoryAtPath:createdDir withIntermediateDirectories:NO attributes:nil error:&error])
    {
        NSLog(@"Couldn't create directory error: %@", error);
    }
    else
    {
        NSLog(@"directory created!");
    }
    return createdDir;
}
+(NSString *)getSystemDocumentFolder
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

@end
