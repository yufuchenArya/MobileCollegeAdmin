//
//  MCATaskDetailViewController.m
//  MobileCollegeAdmin
//
//  Created by aditi on 12/08/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MCATaskDetailViewController.h"

@interface MCATaskDetailViewController ()

@end

@implementation MCATaskDetailViewController
@synthesize taskDetailDHolder;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    lbl_taskName.text =  taskDetailDHolder.str_taskName;
  
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter1 setDateFormat:@"yyyy/MM/dd"];
    NSDate *date_Temp =[dateFormatter dateFromString:taskDetailDHolder.str_taskStartDate];
    NSString *str_date = [dateFormatter1 stringFromDate:date_Temp];
    lbl_taskStartDate.text = str_date;
    
    if ([taskDetailDHolder.str_taskPriority isEqualToString:@"h"]) {
        
       lbl_taskPriority.text = @"High";
       lbl_taskPriority.textColor = [UIColor colorWithRed:252.0/255.0 green:109.0/255.0 blue:36.0/255.0 alpha:1.0];
       lbl_taskColor.backgroundColor = [UIColor colorWithRed:252.0/255.0 green:109.0/255.0 blue:36.0/255.0 alpha:1.0];
        
    }else{
        
        lbl_taskPriority.text = @"Regular";
        lbl_taskPriority.textColor = [UIColor colorWithRed:39.0/255.0 green:166.0/255.0 blue:213.0/255.0 alpha:1.0];
        lbl_taskColor.backgroundColor = [UIColor colorWithRed:39.0/255.0 green:166.0/255.0 blue:213.0/255.0 alpha:1.0];
    }
    tv_taskDetail.text = taskDetailDHolder.str_taskDetail;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
