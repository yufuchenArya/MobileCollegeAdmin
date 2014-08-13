                                                                                   //
//  MCARestIntraction.m
//  MobileCollegeAdmin
//
//  Created by aditi on 23/07/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MCARestIntraction.h"

@implementation MCARestIntraction

+(id)sharedManager{
  
    if (!restIntraction) {
        
        restIntraction = [MCARestIntraction new];
        
    }
    return  restIntraction;
    
}
#pragma mark - LOGIN

-(void)requestForLogin:(NSString *)info{
    
    NSURL *url = [NSURL URLWithString:URL_MAIN];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [request setPostValue:info forKey:@"data"];
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestLoginFail:)];
    [request setDidFinishSelector:@selector(requestLoginSuccess:)];
    [request startAsynchronous];
    
}
-(void)requestLoginFail:(ASIFormDataRequest*)request{
        
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_LOGIN_FAILED object:@"Unable to login at this movement."];
                   });
}
-(void)requestLoginSuccess:(ASIFormDataRequest*)request{
    
    NSString *responseString = [request responseString];
    responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    SBJSON *parser=[[SBJSON alloc]init];
    
    NSDictionary *results = [parser objectWithString:responseString error:nil];
    NSMutableDictionary *responseDict = ((NSMutableDictionary *)[results objectForKey:@"data"]);
    NSString *status_code = [results valueForKey:@"status_code"];
    
    
    if ([status_code isEqualToString:@"S1002"]){
        
        MCALoginDHolder *loginDHolder = [MCALoginDHolder new];
        loginDHolder.str_userId = [responseDict valueForKey:@"user_id"];
        loginDHolder.str_signinId = [responseDict valueForKey:@"signin_id"];
        loginDHolder.str_grade = [responseDict valueForKey:@"grade"];
        loginDHolder.str_userType = [responseDict valueForKey:@"user_type"];
        loginDHolder.str_userToken = [responseDict valueForKey:@"user_token"];
        loginDHolder.str_userIsApproved = [responseDict valueForKey:@"user_is_approved"];
        loginDHolder.arr_StudentData = [responseDict valueForKey:@"student"];
        
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_LOGIN_SUCCESS object:loginDHolder];
                       });
    }else{
        
        NSString *errMsg = [results valueForKey:@"msg"];
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_LOGIN_FAILED object:errMsg];
                       });
       }
}

#pragma mark - FORGOT_PWD
-(void)requestForForgotPwd:(NSString *)info{
    
    NSURL *url = [NSURL URLWithString:URL_MAIN];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [request setPostValue:info forKey:@"data"];
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestForgotPwdFail:)];
    [request setDidFinishSelector:@selector(requestForgotPwdSuccess:)];
    [request startAsynchronous];
}
-(void)requestForgotPwdFail:(ASIFormDataRequest*)request{
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_FORGOT_PWD_FAILED object:@"something went wrong,try again."];
                   });
}
-(void)requestForgotPwdSuccess:(ASIFormDataRequest*)request{
    
    NSString *responseString = [request responseString];
    responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    SBJSON *parser=[[SBJSON alloc]init];
    
    NSDictionary *results = [parser objectWithString:responseString error:nil];
    NSMutableDictionary *responseDict = ((NSMutableDictionary *)[results objectForKey:@"data"]);
    NSString *status_code = [results valueForKey:@"status_code"];
    NSString *error_code = [results valueForKey:@"err_code"];
    
    
    if ([error_code isEqualToString:@"E1034"]) {
        NSString *errMsg = [results objectForKey:@"err_msg"];
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_FORGOT_PWD_FAILED object:errMsg];
                       });
    }else{
        
        NSString *errMsg = [responseDict objectForKey:@"err_msg"];
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_FORGOT_PWD_SUCCESS object:errMsg];
                       });
    }
}


#pragma mark - ADD_STUDENT

-(void)requestForAddStudent:(NSString *)info{
    
    NSURL *url = [NSURL URLWithString:URL_MAIN];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [request setPostValue:info forKey:@"data"];
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestAddStudentFail:)];
    [request setDidFinishSelector:@selector(requestAddStudentSuccess:)];
    [request startAsynchronous];
    
}
-(void)requestAddStudentFail:(ASIFormDataRequest*)request{
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_ADD_STUDENT_FAILED object:@"Unable to add student at this movement."];
                   });
}
-(void)requestAddStudentSuccess:(ASIFormDataRequest*)request{
    
    NSString *responseString = [request responseString];
    responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    SBJSON *parser=[[SBJSON alloc]init];
    
    NSDictionary *results = [parser objectWithString:responseString error:nil];
    NSMutableDictionary *responseDict = ((NSMutableDictionary *)[results objectForKey:@"data"]);
    NSString *error_code = [results valueForKey:@"err_code"];
    
    if ([error_code isEqualToString:@"E1034"]) {
        
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_ADD_STUDENT_SUCCESS object:nil];
                       });
    }else{
        
        NSString *errMsg = [responseDict objectForKey:@"error_msg"];
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_ADD_STUDENT_FAILED object:errMsg];
                       });
      }
}
#pragma mark - PARENT_SIGN_UP

-(void)requestForParentSignUp:(NSString *)info{
    
    NSURL *url = [NSURL URLWithString:URL_MAIN];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [request setPostValue:info forKey:@"data"];
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestParentSignUpFail:)];
    [request setDidFinishSelector:@selector(requestParentSignUpSuccess:)];
    [request startAsynchronous];
}
-(void)requestParentSignUpFail:(ASIFormDataRequest*)request{
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_PARENT_SIGNUP_FAILED object:@"Unable to register at this movement."];
                   });
}
-(void)requestParentSignUpSuccess:(ASIFormDataRequest*)request{
    
    NSString *responseString = [request responseString];
    responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    SBJSON *parser=[[SBJSON alloc]init];
    
    NSDictionary *results = [parser objectWithString:responseString error:nil];
    NSMutableDictionary *responseDict = ((NSMutableDictionary *)[results objectForKey:@"data"]);
    NSString *status_code = [results valueForKey:@"status_code"];
    
    if ([status_code isEqualToString:@"S1019"]){
        
        MCASignUpDHolder *signUpDHolder = [MCASignUpDHolder new];
        
        signUpDHolder.str_appToken = [responseDict valueForKey:@"app_token"];
        signUpDHolder.str_appVer = [responseDict valueForKey:@"app_ver"];
        signUpDHolder.str_hasChild = [responseDict valueForKey:@"has_child"];
        signUpDHolder.str_lang = [responseDict valueForKey:@"language"];
        signUpDHolder.str_notifyByMail = [responseDict valueForKey:@"notify_by_email"];
        signUpDHolder.str_notifyByPush = [responseDict valueForKey:@"notify_by_push"];
        signUpDHolder.str_signinId = [responseDict valueForKey:@"signin_id"];
        signUpDHolder.str_sourceApp = [responseDict valueForKey:@"source_app"];
        signUpDHolder.arr_StudentData = [responseDict valueForKey:@"student"];
        signUpDHolder.str_userId = [responseDict valueForKey:@"user_id"];
        signUpDHolder.str_userIsApproved = [responseDict valueForKey:@"user_is_approved"];
        signUpDHolder.str_userToken = [responseDict valueForKey:@"user_token"];
        signUpDHolder.str_userType = [responseDict valueForKey:@"user_type"];
        signUpDHolder.str_userName = [responseDict valueForKey:@"username"];
        signUpDHolder.str_zipCode = [responseDict valueForKey:@"zipcode"];
        
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_PARENT_SIGNUP_SUCCESS object:signUpDHolder];
                       });
    }else{
        
        NSString *errMsg = [results valueForKey:@"msg"];
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_PARENT_SIGNUP_FAILED object:errMsg];
                       });
    }
}
#pragma mark - STUDENT_SIGN_UP

-(void)requestForStudentSignUp:(NSString *)info{
    
    NSURL *url = [NSURL URLWithString:URL_MAIN];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [request setPostValue:info forKey:@"data"];
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestStudSignUpFail:)];
    [request setDidFinishSelector:@selector(requestStudSignUpSuccess:)];
    [request startAsynchronous];
}
-(void)requestStudSignUpFail:(ASIFormDataRequest*)request{
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_STUD_SIGNUP_FAILED object:@"Unable to register at this movement."];
                   });
}
-(void)requestStudSignUpSuccess:(ASIFormDataRequest*)request{
    
    NSString *responseString = [request responseString];
    responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    SBJSON *parser=[[SBJSON alloc]init];
    
    NSDictionary *results = [parser objectWithString:responseString error:nil];
    NSMutableDictionary *responseDict = ((NSMutableDictionary *)[results objectForKey:@"data"]);
    NSString *status_code = [results valueForKey:@"status_code"];
    
    if ([status_code isEqualToString:@"S1028"]){
        
        MCASignUpDHolder *signUpDHolder = [MCASignUpDHolder new];
        
        signUpDHolder.str_family = [responseDict valueForKey:@"family"];
        signUpDHolder.str_grade = [responseDict valueForKey:@"grade"];
        signUpDHolder.str_lang = [responseDict valueForKey:@"language"];
        signUpDHolder.str_notifyByMail = [responseDict valueForKey:@"notify_by_email"];
        signUpDHolder.str_notifyByPush = [responseDict valueForKey:@"notify_by_push"];
        signUpDHolder.str_signinId = [responseDict valueForKey:@"signin_id"];
        signUpDHolder.str_sourceApp = [responseDict valueForKey:@"source_app"];
        signUpDHolder.str_userId = [responseDict valueForKey:@"user_id"];
        signUpDHolder.str_userToken = [responseDict valueForKey:@"user_token"];
        signUpDHolder.str_userType = [responseDict valueForKey:@"user_type"];
        signUpDHolder.str_userName = [responseDict valueForKey:@"username"];
        signUpDHolder.str_zipCode = [responseDict valueForKey:@"zipcode"];
        
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_STUD_SIGNUP_SUCCESS object:signUpDHolder];
                       });
    }else{
        
        NSString *errMsg = [results valueForKey:@"msg"];
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_STUD_SIGNUP_FAILED object:errMsg];
                       });
    }
}

#pragma mark - TASK_LIST
-(void)requestForTaskList:(NSString *)info{
    
    NSURL *url = [NSURL URLWithString:URL_MAIN];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [request setPostValue:info forKey:@"data"];
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestTaskListFail:)];
    [request setDidFinishSelector:@selector(requestTaskListSuccess:)];
    [request startAsynchronous];
}
-(void)requestTaskListFail:(ASIFormDataRequest*)request{
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_TASK_LIST_FAILED object:@"Unable to register at this movement."];
                   });
}
-(void)requestTaskListSuccess:(ASIFormDataRequest*)request{
    
    NSString *responseString = [request responseString];
    responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    SBJSON *parser=[[SBJSON alloc]init];
    
    NSDictionary *results = [parser objectWithString:responseString error:nil];
    NSMutableDictionary *responseDict = ((NSMutableDictionary *)[results objectForKey:@"data"]);
    NSMutableArray *arr_taskDetail = (NSMutableArray*)[responseDict objectForKey:@"alldata"];
    NSString *status_code = [results valueForKey:@"status_code"];
  
    
    if ([status_code isEqualToString:@"S1001"]){
        
        NSMutableArray *arr_taskDetailList = [NSMutableArray new];
        
        for (int i = 0;i < arr_taskDetail.count;i++) {
           
            MCATaskDetailDHolder *taskDHolder = [MCATaskDetailDHolder new];
            
            taskDHolder.str_createdAt = [[arr_taskDetail valueForKey:@"created_at"]objectAtIndex:i];
            taskDHolder.str_createdBy = [[arr_taskDetail valueForKey:@"created_by"]objectAtIndex:i];
            taskDHolder.str_grade = [[arr_taskDetail valueForKey:@"grade"]objectAtIndex:i];
            taskDHolder.str_status = [[arr_taskDetail valueForKey:@"status"]objectAtIndex:i];
            taskDHolder.str_taskDetail = [[arr_taskDetail valueForKey:@"task_detail"]objectAtIndex:i];
            taskDHolder.str_taskId = [[arr_taskDetail valueForKey:@"task_id"]objectAtIndex:i];
            taskDHolder.str_taskName = [[arr_taskDetail valueForKey:@"task_name"]objectAtIndex:i];
            taskDHolder.str_taskPriority = [[arr_taskDetail valueForKey:@"task_priority"]objectAtIndex:i];
            taskDHolder.str_taskStartDate = [[arr_taskDetail valueForKey:@"task_start_date"]objectAtIndex:i];
            taskDHolder.str_taskStatus = [[arr_taskDetail valueForKey:@"task_status"]objectAtIndex:i];
            taskDHolder.str_updatedAt = [[arr_taskDetail valueForKey:@"updated_at"]objectAtIndex:i];
            taskDHolder.str_userId = [[arr_taskDetail valueForKey:@"user_id"]objectAtIndex:i];
            taskDHolder.str_nowDate = [responseDict valueForKey:@"now_date"];
            taskDHolder.str_network = @"1";
                        
            [arr_taskDetailList addObject:taskDHolder];
        }
      
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_TASK_LIST_SUCCESS object:arr_taskDetailList];
                       });
    }else{
        
        NSString *errMsg = [results valueForKey:@"msg"];
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_TASK_LIST_FAILED object:errMsg];
                       });
    }
}

#pragma mark - DELETE/COMPLETE_TASK

-(void)requestForDeleteOrCompleteTask:(NSString *)info{
    
    NSURL *url = [NSURL URLWithString:URL_MAIN];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [request setPostValue:info forKey:@"data"];
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestDeleteOrCompleteTaskFail:)];
    [request setDidFinishSelector:@selector(requestDeleteOrCompleteTaskSuccess:)];
    [request startAsynchronous];
    
}
-(void)requestDeleteOrCompleteTaskFail:(ASIFormDataRequest*)request{
    
    dispatch_async(dispatch_get_main_queue(), ^
               {
                   [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_DELETE_COMPLETE_TASK_FAILED object:@"Unable to perfrom task at this movement."];
               });
}
-(void)requestDeleteOrCompleteTaskSuccess:(ASIFormDataRequest*)request{
    
    NSString *responseString = [request responseString];
    responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    SBJSON *parser=[[SBJSON alloc]init];
    
    NSDictionary *results = [parser objectWithString:responseString error:nil];
    NSMutableDictionary *responseDict = ((NSMutableDictionary *)[results objectForKey:@"data"]);
    NSString *status_code = [results valueForKey:@"status_code"];
    
     if ([status_code isEqualToString:@"S1023"]){
         
         NSString *errMsg = [results valueForKey:@"msg"];
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_DELETE_COMPLETE_TASK_SUCCESS object:errMsg];
                        });
         
     }else{
         
         NSString *errMsg = [results valueForKey:@"msg"];
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_DELETE_COMPLETE_TASK_FAILED object:errMsg];
                        });
        }
}

#pragma mark - ADD_TASK

-(void)requestForAddTask:(NSString *)info{
    
    NSURL *url = [NSURL URLWithString:URL_MAIN];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [request setPostValue:info forKey:@"data"];
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestAddTaskFail:)];
    [request setDidFinishSelector:@selector(requestAddTaskSuccess:)];
    [request startAsynchronous];
    
}
-(void)requestAddTaskFail:(ASIFormDataRequest*)request{
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_ADD_TASK_FAILED object:@"Unable to perfrom task at this movement."];
                   });
}
-(void)requestAddTaskSuccess:(ASIFormDataRequest*)request{
    
    NSString *responseString = [request responseString];
    responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    SBJSON *parser=[[SBJSON alloc]init];
    
    NSDictionary *results = [parser objectWithString:responseString error:nil];
    NSMutableDictionary *responseDict = ((NSMutableDictionary *)[results objectForKey:@"data"]);
    NSString *status_code = [results valueForKey:@"status_code"];
    
    if ([status_code isEqualToString:@"S1001"]) {
        
        NSString *errMsg = [results valueForKey:@"msg"];
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_ADD_TASK_SUCCESS object:errMsg];
                       });
    }else{
        NSString *errMsg = [results valueForKey:@"msg"];
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_ADD_TASK_FAILED object:errMsg];
                       });
    }
}

@end
