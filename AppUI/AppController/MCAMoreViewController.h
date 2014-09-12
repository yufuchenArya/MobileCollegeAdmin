//
//  MCAMoreViewController.h
//  MobileCollegeAdmin
//
//  Created by aditi on 16/08/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCAAppDelegate.h"

@interface MCAMoreViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    
    IBOutlet UITableView *tbl_moreOption;
    
    NSMutableArray *arr_moreOptionList;
    NSMutableArray *arr_moreImageList;
}

@end
