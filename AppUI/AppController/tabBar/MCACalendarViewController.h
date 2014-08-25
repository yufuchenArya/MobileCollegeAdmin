//
//  MCACalendarViewController.h
//  MobileCollegeAdmin
//
//  Created by aditi on 22/08/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCACalendarView.h"

@interface MCACalendarViewController : UIViewController <MCACalendarViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    MCACalendarView *calendar;
    NSMutableArray  *arr_taskList;
    NSMutableArray  *arr_currentTaskList;
            NSArray *arr_gradeList;
   
    UITableView *tbl_gradeList;
         UIView *view_transBg;
}
@end
