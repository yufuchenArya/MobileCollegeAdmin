//
//  MCAGlobalFunction.m
//  MobileCollegeAdmin
//
//  Created by aditi on 01/07/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MCAGlobalFunction.h"

@implementation MCAGlobalFunction


+(void)showAlert:(NSString*)msg{
    
    [[[UIAlertView alloc]initWithTitle:@"Message" message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil]show];
}
+(BOOL)isConnectedToInternet
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}
+(BOOL)isConnectedToHost
{
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}
@end
