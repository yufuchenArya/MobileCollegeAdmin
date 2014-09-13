//
//  MCAResourcesDetailViewController.h
//  MobileCollegeAdmin
//
//  Created by rashmi on 9/12/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCAResourcesDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView* tbl_url;
    NSMutableArray *arr_url;
}

@property(nonatomic, strong)MCAResourcesDHolder* reDHolder;

@end
