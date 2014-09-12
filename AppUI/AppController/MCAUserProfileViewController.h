//
//  MCAUserProfileViewController.h
//  MobileCollegeAdmin
//
//  Created by aditi on 11/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCAUserProfileViewController : UIViewController<UITextFieldDelegate>{
    
   IBOutlet UITextField *tx_name;
   IBOutlet UITextField *tx_email;
   IBOutlet UITextField *tx_zipcode;
   AryaHUD *HUD;
}
-(IBAction)btnDoneDidClicked:(id)sender;
@end
