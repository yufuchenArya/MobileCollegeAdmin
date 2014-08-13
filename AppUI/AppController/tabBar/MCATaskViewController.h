//
//  MCATaskViewController.h
//  MobileCollegeAdmin
//
//  Created by aditi on 05/08/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTableViewCell.h"
#import "SWTableViewCell.h"
#import "MCATaskDetailViewController.h"

@interface MCATaskViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,SWTableViewCellDelegate>{
    
    IBOutlet UISegmentedControl *segControl_task;
   
    IBOutlet UITableView *tbl_taskCurrent;
    IBOutlet UITableView *tbl_taskCompleted;
    IBOutlet UITableView *tbl_taskDeleted;
    IBOutlet UITableView *tbl_gradeList;
                  UIView *view_transBg;
    
    NSMutableArray *arr_taskList;
    NSMutableArray *arr_currentTaskList;
    NSMutableArray *arr_completedTaskList;
    NSMutableArray *arr_deletedTaskList;
    
    NSMutableArray *arr_deletedTaskDetail;
    NSMutableArray *arr_completedTaskDetail;
           NSArray *arr_gradeList;
    
    AryaHUD *HUD;
}
-(IBAction)btnSegControl_taskDidClicked:(id)sender;
@end