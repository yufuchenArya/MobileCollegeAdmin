//
//  MCATaskDetailViewController.h
//  MobileCollegeAdmin
//
//  Created by aditi on 12/08/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTableViewCell.h"
#import "SWTableViewCell.h"
#import "MCATaskDetailDHolder.h"
@protocol TaskDetailDelegate <NSObject>
-(void)deleteTaskDetail:(MCATaskDetailDHolder*)taskDHolder;
@end

@interface MCATaskDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    
    IBOutlet UITableView *tbl_taskDetail;
    
    IBOutlet UIButton *btn_complete;
    IBOutlet UITextView *tv_taskDetail;
    
    AryaHUD *HUD;
    
}
-(IBAction)btnCompleteDidClicked:(id)sender;
@property(nonatomic,assign)id<TaskDetailDelegate> delegate;
@property(nonatomic,strong)MCATaskDetailDHolder *taskDetailDHolder;

@end
