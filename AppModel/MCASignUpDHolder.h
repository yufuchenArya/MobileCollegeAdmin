//
//  MCASignUpDHolder.h
//  MobileCollegeAdmin
//
//  Created by aditi on 06/08/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCASignUpDHolder : NSObject{
    
}
@property(nonatomic,strong)NSString *str_signinId;
@property(nonatomic,strong)NSString *str_grade;
@property(nonatomic,strong)NSString *str_family;
@property(nonatomic,strong)NSString *str_userId;
@property(nonatomic,strong)NSString *str_userName;
@property(nonatomic,strong)NSString *str_zipCode;
@property(nonatomic,strong)NSString *str_appToken;
@property(nonatomic,strong)NSString *str_appVer;
@property(nonatomic,strong)NSString *str_hasChild;
@property(nonatomic,strong)NSString *str_lang;
@property(nonatomic,strong)NSString *str_notifyByMail;
@property(nonatomic,strong)NSString *str_notifyByPush;
@property(nonatomic,strong)NSString *str_sourceApp;
@property(nonatomic,strong)NSString *str_userToken;
@property(nonatomic,strong)NSString *str_userType;
@property(nonatomic,strong)NSString *str_userIsApproved;
@property(nonatomic,strong)NSMutableArray *arr_StudentData;

@end
