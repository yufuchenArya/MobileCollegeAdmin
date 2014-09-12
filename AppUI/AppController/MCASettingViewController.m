
//
//  MCASettingViewController.m
//  MobileCollegeAdmin
//
//  Created by aditi on 11/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MCASettingViewController.h"

@interface MCASettingViewController ()

@end

@implementation MCASettingViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IB_ACTION

-(IBAction)btnChangePwdDidClicked:(id)sender{
    
    [self performSegueWithIdentifier:@"segue_changePwd" sender:nil];
    
}
-(IBAction)btnUserProfileDidClicked:(id)sender{
    
    [self performSegueWithIdentifier:@"segue_userProfile" sender:nil];
    
}

@end
