//
//  MCATaskDetailViewController.h
//  MobileCollegeAdmin
//
//  Created by aditi on 12/08/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCATaskDetailDHolder.h"

@interface MCATaskDetailViewController : UIViewController{
        
    IBOutlet UILabel *lbl_taskName;
    IBOutlet UILabel *lbl_taskColor;
    IBOutlet UILabel *lbl_taskStartDate;
    IBOutlet UILabel *lbl_taskPriority;
    IBOutlet UITextView *tv_taskDetail;
    
}
@property(nonatomic,strong)MCATaskDetailDHolder *taskDetailDHolder;


@end
