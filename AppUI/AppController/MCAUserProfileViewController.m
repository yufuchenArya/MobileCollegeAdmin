//
//  MCAUserProfileViewController.m
//  MobileCollegeAdmin
//
//  Created by aditi on 11/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MCAUserProfileViewController.h"

@interface MCAUserProfileViewController ()

@end

@implementation MCAUserProfileViewController
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
    
    HUD=[AryaHUD new];
    [self.view addSubview:HUD];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UserProfileEditSuccess:) name:NOTIFICATION_USER_PROFILE_EDIT_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UserProfileEditFailed:) name:NOTIFICATION_USER_PROFILE_EDIT_FAILED object:nil];
    
    tx_name.text = [[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_NAME];
    tx_email.text = [[NSUserDefaults standardUserDefaults]valueForKey:KEY_SIGNIN_ID];
    tx_zipcode.text = [[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_ZIPCODE];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [tx_email resignFirstResponder];
    [tx_name resignFirstResponder];
    [tx_zipcode resignFirstResponder];
   
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - IB_ACTION

-(IBAction)btnDoneDidClicked:(id)sender{
    
    if (![tx_email.text isEqualToString:@""] && [MCAValidation isValidEmailId:tx_email.text]) {
        
        if (![tx_name.text isEqualToString:@""]) {
            
             NSMutableDictionary *info = [NSMutableDictionary new];
            if (tx_zipcode.text.length != 0)
            {
                if (tx_zipcode.text.length == 5)
                {
                    [info setValue:tx_zipcode.text forKey:@"zipcode"];
                    
                }else{
                    [MCAGlobalFunction showAlert:ZIP_CODE_MSG];
                    return;
                }
            }else{
                [info setValue:@"" forKey:@"zipcode"];
                
            }
         
            [info setValue:tx_name.text forKey:@"user_name"];
            [info setValue:[[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_FAMILY] forKey:@"family"];
            [info setValue:[[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_GRADE] forKey:@"grade"];
            [info setValue:tx_zipcode.text forKey:@"zipcode"];
            [info setValue:@"edit_profile" forKey:@"cmd"];
             NSString *str_jsonProfileEdit = [NSString getJsonObject:info];
            
            [HUD showForTabBar];
            [self requestUserProfileEdit:str_jsonProfileEdit];
            
        }else{
            
            [MCAGlobalFunction showAlert:INVALID_USERNAME];
        }
    }else{
        
        [MCAGlobalFunction showAlert:EMAIL_MESSAGE];
    }
}

#pragma mark - API CALLING

-(void)requestUserProfileEdit:(NSString*)info{
    
    if ([MCAGlobalFunction isConnectedToInternet]) {
        [[MCARestIntraction sharedManager]requestForUserProfileEdit:info];
    }else{
        [HUD hide];
        [MCAGlobalFunction showAlert:NET_NOT_AVAIALABLE];
    }
}

#pragma mark - NSNOTIFICATION SELECTOR

-(void)UserProfileEditSuccess:(NSNotification*)notification{
    
    [HUD hide];
    [tx_name resignFirstResponder];
    [tx_zipcode resignFirstResponder];
    MCALoginDHolder *loginDHolder = notification.object;
    [[NSUserDefaults standardUserDefaults]setValue:loginDHolder.str_userName forKey:KEY_USER_NAME];
    [[NSUserDefaults standardUserDefaults]setValue:loginDHolder.str_zipCode forKey:KEY_USER_ZIPCODE];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
     UIAlertView *alert   = [[UIAlertView alloc]initWithTitle:@"Message"
                                            message:@"Profile updated successfully."
                                           delegate:nil
                                  cancelButtonTitle:nil
                                  otherButtonTitles:nil, nil];
    [alert show];
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(),^ {
        
        [alert dismissWithClickedButtonIndex:0 animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    });

}
-(void)UserProfileEditFailed:(NSNotification*)notification{
    
    [HUD hide];
    [MCAGlobalFunction showAlert:notification.object];
}

@end
