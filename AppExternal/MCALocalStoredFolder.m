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
static NSString *categoryDir;
static NSString *subCategoryDir;

#pragma mark - CREATE_DIRECTORY

+(void)createRootDir
{
    rootDir = [self createSubfolderWithRootDir:[self getSystemDocumentFolder] andSubDirName:ROOT_FOLDER];
}
+(void)createSubRootDir:(id)sender
{
    subRootDir = [self createSubfolderWithRootDir:rootDir andSubDirName:sender];
}
+(void)createCategoryDir:(id)sender
{
    categoryDir = [self createSubfolderWithRootDir:subRootDir andSubDirName:sender];
}
+(void)createSubCategoryDir:(id)sender{
    
   subCategoryDir = [self createSubfolderWithRootDir:categoryDir andSubDirName:sender];
    
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
+(BOOL)isDirExistWithName:(NSString *)dirPath
{
    return [[NSFileManager defaultManager] fileExistsAtPath:dirPath];
}
 
#pragma mark - Get Directory path
+(NSString *)getRootDir
{
    return rootDir;
}
+(NSString *)getSubRootDir
{
    return subRootDir;
}
+(NSString *)getCategoryDir
{
    return categoryDir;
}
+(NSString *)getSubCategoryDir
{
    return subCategoryDir;
}

@end
