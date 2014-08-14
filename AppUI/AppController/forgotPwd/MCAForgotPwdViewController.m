//
//  MCAForgotPwdViewController.m
//  MobileCollegeAdmin
//
//  Created by aditi on 04/08/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MCAForgotPwdViewController.h"

@interface MCAForgotPwdViewController ()

@end

@implementation MCAForgotPwdViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(forgotPwdSuccess:) name:NOTIFICATION_FORGOT_PWD_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(forgotPwdFailed:) name:NOTIFICATION_FORGOT_PWD_FAILED object:nil];
    
    HUD = [AryaHUD new];
    [self.view addSubview:HUD];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [tx_forgotPwd resignFirstResponder];
        
}
#pragma mark - IBACTION

-(IBAction)btnBackDidClicked:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)btnSubmitDidClicked:(id)sender{
    
     if (![tx_forgotPwd.text isEqualToString:@""]&&[MCAValidation isValidEmailId:tx_forgotPwd.text]) {
        
         NSMutableDictionary *info=[NSMutableDictionary new];
         [info setValue:tx_forgotPwd.text forKey:@"signin_id"];
         
         [info setValue:@"forgot_password" forKey:@"cmd"];
         [info setValue:@"" forKey:@"user_token"];
         [info setValue:@"" forKey:@"app_token"];
         [info setValue:@"ad607645c57ceb4" forKey:@"device_id"];
         [info setValue:@"" forKey:@"user_id"];
         [info setValue:@"1.0" forKey:@"app_ver"];
         
         NSError* error;
         NSData* jsonData = [NSJSONSerialization dataWithJSONObject:info
                                                            options:NSJSONWritingPrettyPrinted
                                                              error:&error];
         NSString* jsonForgotPwdData=  [[NSString alloc] initWithData:jsonData
                                                  encoding:NSUTF8StringEncoding];
         jsonForgotPwdData = [jsonForgotPwdData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
         jsonForgotPwdData = [jsonForgotPwdData stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
         
         [HUD show];
         [self requestForgotPwd:jsonForgotPwdData];

     }else{
         
         [MCAGlobalFunction showAlert:EMAIL_MESSAGE];
     }
}
#pragma mark - API CALLING

-(void)requestForgotPwd:(NSString*)info{
    
    if ([MCAGlobalFunction isConnectedToInternet]) {
        [[MCARestIntraction sharedManager]requestForForgotPwd:info];
    }else{
        [HUD hide];
        [MCAGlobalFunction showAlert:NET_NOT_AVAIALABLE];
    }
}

#pragma mark - NSNOTIFICATION SELECTOR

-(void)forgotPwdSuccess:(NSNotification*)notification{
    
    [HUD hide];
}

-(void)forgotPwdFailed:(NSNotification*)notification{
    
    [HUD hide];
    [MCAGlobalFunction showAlert:notification.object];
}
@end
