//
//  MCACalendarViewController.h
//  MobileCollegeAdmin
//
//  Created by aditi on 22/08/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCACalendarView.h"
#import "SWTableViewCell.h"
#import "CustomTableViewCell.h"

@interface MCACalendarViewController : UIViewController <MCACalendarViewDelegate,UITableViewDelegate,UITableViewDataSource,SWTableViewCellDelegate>
{
    MCACalendarView *calendar;
    NSMutableDictionary *dict_taskList;
    
    NSMutableArray *arr_taskList;
    NSMutableArray *arr_currentTaskList;
    NSMutableArray *arr_monthTask;
    NSMutableArray *arr_studentList;
           NSArray *arr_gradeList;
   
  IBOutlet UITableView *tbl_monthTask;
           UITableView *tbl_gradeList;
           UITableView *tbl_studentList;
           UIView *view_transBg;
  IBOutlet UILabel *lbl_noEvent;
    
AryaHUD *HUD;
}
@end
