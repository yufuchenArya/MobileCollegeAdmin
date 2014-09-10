//
//  MCAAppDelegate.h
//  MobileCollegeAdmin
//
//  Created by aditi on 01/07/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>

@interface MCAAppDelegate : UIResponder <UIApplicationDelegate,DBRestClientDelegate,DBSessionDelegate>{
    
    UIApplication *eApplication;
}

@property (strong, nonatomic) UIWindow *window;
-(void)logout;
@end
