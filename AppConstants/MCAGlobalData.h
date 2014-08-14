//
//  MCAGlobalData.h
//  MobileCollegeAdmin
//
//  Created by aditi on 04/08/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCALoginDHolder.h"
#import "FMDatabase.h"

UITabBarController *tabBarMCACtr;
FMDatabase *dBCollgeAdmin;
NSMutableArray *arr_loginData;

@interface MCAGlobalData : NSObject<UITabBarControllerDelegate>{
    
}

+ (MCAGlobalData *)sharedManager;
-(void)goToTabbarView:(id)sender;

@end
