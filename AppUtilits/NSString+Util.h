//
//  NSString+Util.h
//  MobileCollegeAdmin
//
//  Created by aditi on 23/08/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Util)
+(NSString*)getJsonObject:(NSMutableDictionary*)info;
+(NSString*)getJsonArray:(NSMutableArray*)info;
@end
