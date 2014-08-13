//
//  CustomTableViewCell.h
//  SwipeTableCell
//
//  Created by Simon on 4/5/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface CustomTableViewCell : SWTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbl_taskColor;
@property (weak, nonatomic) IBOutlet UILabel *lbl_taskName;
@property (weak, nonatomic) IBOutlet UILabel *lbl_taskStartDate;
@property (weak, nonatomic) IBOutlet UILabel *lbl_taskPriority;
@end
