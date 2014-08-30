//
//  MCALocalStoredFolder.h
//  MobileCollegeAdmin
//
//  Created by aditi on 28/08/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCALocalStoredFolder : NSObject{
    
}
#pragma mark - Create Directories

+(void)createRootDir;
+(void)createSubRootDir:(id)sender;
+(void)createCategoryDir:(id)sender;
+(void)createSubCategoryDir:(id)sender;
#pragma mark - Get Directories path
+(NSString *)getRootDir;
+(NSString *)getSubRootDir;
+(NSString *)getCategoryDir;
+(NSString *)getSubCategoryDir;

@end
