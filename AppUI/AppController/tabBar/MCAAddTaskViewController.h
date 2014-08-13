//
//  MCAAddTaskViewController.h
//  MobileCollegeAdmin
//
//  Created by aditi on 09/08/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCAAddTaskViewController : UIViewController<UITextFieldDelegate,UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate>{
    
    IBOutlet UITextField *tx_taskNAme;
    IBOutlet UITextField *tx_chooseDate;
    IBOutlet UITextField *tx_priority;
    IBOutlet UITextView  *tv_description;
    
    UIActionSheet *sheet_datePicker;
    UITableView   *tbl_priority;
    UIDatePicker  *datePicker;
    NSString      *str_dateSelected;
    UIView        *view_transBg;
    
    UIBarButtonItem *btnBar_done;
    UIBarButtonItem *btnBar_cancel;
    
    NSMutableArray  *arr_priority;
    
    AryaHUD *HUD;
}
-(IBAction)chooseDateDidClicked:(id)sender;
-(IBAction)selectPriorityDidClicked:(id)sender;
-(IBAction)btnBarDoneDidClicked:(id)sender;
@end
