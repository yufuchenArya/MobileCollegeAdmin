//
//  MCALoginViewController.h
//  MobileCollegeAdmin
//
//  Created by aditi on 01/07/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCALoginViewController : UIViewController{
    
    IBOutlet UITextField *tx_email;
    IBOutlet UITextField *tx_pwd;
    AryaHUD *HUD;

}
-(IBAction)btnLoginDidClicked:(id)sender;
-(IBAction)ReturnKeyButton:(id)sender;
@end
