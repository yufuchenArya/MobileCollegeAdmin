//
//  MCALoginDHolder.h
//  MobileCollegeAdmin
//
//  Created by aditi on 23/07/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCALoginDHolder : NSObject{
    
    
}
@property(nonatomic,strong)NSString *str_signinId;
@property(nonatomic,strong)NSString *str_grade;
@property(nonatomic,strong)NSString *str_userId;
@property(nonatomic,strong)NSString *str_userToken;
@property(nonatomic,strong)NSString *str_userType;
@property(nonatomic,strong)NSString *str_userIsApproved;
@property(nonatomic,strong)NSMutableArray *arr_StudentData;

@end
