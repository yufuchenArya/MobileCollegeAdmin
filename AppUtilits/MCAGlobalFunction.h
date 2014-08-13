//
//  MCAGlobalFunction.h
//  MobileCollegeAdmin
//
//  Created by aditi on 01/07/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCAGlobalFunction : NSObject{
    
    
}
+(void)showAlert:(NSString*)msg;
+(BOOL)isConnectedToInternet;
+(BOOL)isConnectedToHost;


@end
