//
//  NSString+Util.m
//  MobileCollegeAdmin
//
//  Created by aditi on 23/08/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "NSString+Util.h"

@implementation NSString (Util)

+(NSString*)getJsonObject:(NSMutableDictionary*)info{
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_TOKEN]) {
          [info setValue:[[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_TOKEN] forKey:@"user_token"];
    }else{
          [info setValue:@"" forKey:@"user_token"];
    }
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_ID]) {
        [info setValue:[[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_ID] forKey:@"user_id"];
    }else{
        [info setValue:@"" forKey:@"user_id"];
    }
    
    [info setValue:@"1.0" forKey:@"app_ver"];
    [info setValue:@"" forKey:@"app_token"];
    [info setValue:@"ad607645c57ceb4" forKey:@"device_id"];
   
    NSError* error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:info
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString* jsonString=  [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    return jsonString;
 
}
+(NSString*)getJsonArray:(NSMutableArray *)arr_info{
    
    NSError* error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr_info
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                            encoding:NSUTF8StringEncoding];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    return jsonString;
}
@end
