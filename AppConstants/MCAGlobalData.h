//
//  MCAGlobalData.h
//  MobileCollegeAdmin
//
//  Created by aditi on 04/08/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+Util.h"
#import "MCACustomButton.h"
#import "Reachability.h"
#import "MCAAlertView.h"
#import "FMDatabase.h"

UITabBarController *tabBarMCACtr;
FMDatabase *dBCollgeAdmin;
NSMutableArray *arr_loginData;
Reachability *hostReachable;

@interface MCAGlobalData : NSObject<UITabBarControllerDelegate>{
    
}

+ (MCAGlobalData *)sharedManager;
-(void)goToTabbarView:(id)sender;

@end
