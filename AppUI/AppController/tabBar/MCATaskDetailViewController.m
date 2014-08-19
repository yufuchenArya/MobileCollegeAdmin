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
@synthesize taskDetailDHolder,delegate;

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
    
    HUD = [AryaHUD new];
    [self.view addSubview:HUD];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteTaskDetailSuccess:) name:NOTIFICATION_DELETE_TASK_DETAIL_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(completeTaskDetailSuccess:) name:NOTIFICATION_COMPLETE_TASK_DETAIL_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteOrCompleteTaskDetailFailed:) name:NOTIFICATION_DELETE_COMPLETE_TASK_DETAIL_FAILED object:nil];
    
   
  
    
     tv_taskDetail.text = taskDetailDHolder.str_taskDetail;
    
    //code for navigation bar
    if ([taskDetailDHolder.str_taskStatus isEqualToString:@"o"])
    {
        UIImage* img_delete = [UIImage imageNamed:@"delete.png"];
        CGRect img_deleteFrame = CGRectMake(0, 0, img_delete.size.width, img_delete.size.height);
        UIButton *btn_delete = [[UIButton alloc] initWithFrame:img_deleteFrame];
        [btn_delete setBackgroundImage:img_delete forState:UIControlStateNormal];
        [btn_delete addTarget:self
                    action:@selector(btnBar_deleteDidClicked:)
          forControlEvents:UIControlEventTouchUpInside];
        [btn_delete setShowsTouchWhenHighlighted:YES];
        
        UIImage* img_edit = [UIImage imageNamed:@"edit.png"];
        CGRect img_editFrame = CGRectMake(0, 0, img_edit.size.width, img_edit.size.height);
        UIButton *btn_edit = [[UIButton alloc] initWithFrame:img_editFrame];
        [btn_edit setBackgroundImage:img_edit forState:UIControlStateNormal];
        [btn_edit addTarget:self
                      action:@selector(btnBar_editDidClicked:)
            forControlEvents:UIControlEventTouchUpInside];
        [btn_edit setShowsTouchWhenHighlighted:YES];
        
        UIBarButtonItem *btnBar_delete =[[UIBarButtonItem alloc] initWithCustomView:btn_delete];
        UIBarButtonItem *btnBar_edit =[[UIBarButtonItem alloc] initWithCustomView:btn_edit];
        
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:btnBar_delete,btnBar_edit, nil]];
    }
    
    btn_complete.layer.cornerRadius = 3.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IB_ACTION

-(void)btnBar_deleteDidClicked:(id)sender{
    
    MCAAlertView *alertView = [MCAGlobalFunction showAlert:@"Do you want to delete the task?"
                                                  delegate:self
                                                     btnOk:@"Confirm Action"
                                                 btnCancel:@"Cancel"];
    alertView.tag = 1;
   
    
}
-(void)btnBar_editDidClicked:(id)sender{
    
    [self performSegueWithIdentifier:@"segue_editTask" sender:nil];
}
-(IBAction)btnCompleteDidClicked:(id)sender{
    
    MCAAlertView *alertView = [MCAGlobalFunction showAlert:@"Do you want to complete the task?"
                                                  delegate:self
                                                     btnOk:@"Confirm Action"
                                                 btnCancel:@"Cancel"];
    
    alertView.tag = 2;
    
}
-(void)alertView:(MCAAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    MCAAlertView *mcaAlert = (MCAAlertView*)alertView;
    
    if (alertView.tag == 1)
    {
        if (buttonIndex == 1)
        {          
            NSDateFormatter *dateFormatterTime = [[NSDateFormatter alloc]init];
            [dateFormatterTime setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            NSString *str_dateTime = [dateFormatterTime stringFromDate:[NSDate date]];
            
            taskDetailDHolder.str_taskStatus = @"d";
            
            NSMutableDictionary *info=[NSMutableDictionary new];
            [info setValue:str_dateTime forKey:@"updated_at"];
            [info setValue:@"d" forKey:@"task_status"];
            [info setValue:taskDetailDHolder.str_taskId forKey:@"task_id"];
            
            [info setValue:@"task_status" forKey:@"cmd"];
            [info setValue:[[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_TOKEN] forKey:@"user_token"];
            [info setValue:@"" forKey:@"app_token"];
            [info setValue:@"ad607645c57ceb4" forKey:@"device_id"];
            [info setValue:[[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_ID] forKey:@"user_id"];
            [info setValue:@"1.0" forKey:@"app_ver"];
            
            NSError* error;
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:info
                                                               options:NSJSONWritingPrettyPrinted
                                                                 error:&error];
            NSString* jsonDeleteTaskData=  [[NSString alloc] initWithData:jsonData
                                                                 encoding:NSUTF8StringEncoding];
            jsonDeleteTaskData = [jsonDeleteTaskData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            jsonDeleteTaskData = [jsonDeleteTaskData stringByReplacingOccurrencesOfString:@" " withString:@""];
            jsonDeleteTaskData = [jsonDeleteTaskData stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            
            [HUD show];
            [self.view bringSubviewToFront:HUD];
            [self requestDeleteOrCompleteTask:jsonDeleteTaskData];

        }
    }
    else
    {
       if (buttonIndex == 1)
        {       
            NSDateFormatter *dateFormatterTime = [[NSDateFormatter alloc]init];
            [dateFormatterTime setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            NSString *str_dateTime = [dateFormatterTime stringFromDate:[NSDate date]];
            
            taskDetailDHolder.str_taskStatus = @"c";
            
            NSMutableDictionary *info=[NSMutableDictionary new];
            [info setValue:str_dateTime forKey:@"updated_at"];
            [info setValue:@"c" forKey:@"task_status"];
            [info setValue:taskDetailDHolder.str_taskId forKey:@"task_id"];
            
            [info setValue:@"task_status" forKey:@"cmd"];
            [info setValue:[[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_TOKEN] forKey:@"user_token"];
            [info setValue:@"" forKey:@"app_token"];
            [info setValue:@"ad607645c57ceb4" forKey:@"device_id"];
            [info setValue:[[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_ID] forKey:@"user_id"];
            [info setValue:@"1.0" forKey:@"app_ver"];
            
            NSError* error;
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:info
                                                               options:NSJSONWritingPrettyPrinted
                                                                 error:&error];
            NSString* jsonCompleteTaskData=  [[NSString alloc] initWithData:jsonData
                                                                   encoding:NSUTF8StringEncoding];
            jsonCompleteTaskData = [jsonCompleteTaskData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            jsonCompleteTaskData = [jsonCompleteTaskData stringByReplacingOccurrencesOfString:@" " withString:@""];
            jsonCompleteTaskData = [jsonCompleteTaskData stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            
            [HUD show];
            [self.view bringSubviewToFront:HUD];
            [self requestDeleteOrCompleteTask:jsonCompleteTaskData];
       }
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     static NSString *cellIdentifier = @"Cell";
     CustomTableViewCell *cell  = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:                                                 cellIdentifier forIndexPath:indexPath];
        
     NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    
        if ([taskDetailDHolder.str_taskPriority isEqualToString:@"h"]) {
            
            [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:252.0/255.0 green:109.0/255.0 blue:36.0/255.0  alpha:1.0]icon:[UIImage imageNamed:@"taskSelect.png"]];
            cell.lbl_taskPriority.text = @"High";
            cell.lbl_taskPriority.textColor = [UIColor colorWithRed:252.0/255.0 green:109.0/255.0 blue:36.0/255.0 alpha:1.0];
            cell.lbl_taskColor.backgroundColor = [UIColor colorWithRed:252.0/255.0 green:109.0/255.0 blue:36.0/255.0  alpha:1.0];
            
        }else{
            
            [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:39.0/255.0 green:166.0/255.0 blue:213.0/255.0 alpha:1.0]icon:[UIImage imageNamed:@"taskSelect.png"]];
            cell.lbl_taskPriority.text = @"Regular";
            cell.lbl_taskPriority.textColor = [UIColor colorWithRed:39.0/255.0 green:166.0/255.0 blue:213.0/255.0 alpha:1.0];
            cell.lbl_taskColor.backgroundColor = [UIColor colorWithRed:39.0/255.0 green:166.0/255.0 blue:213.0/255.0 alpha:1.0];
        }
    
    cell.leftUtilityButtons = leftUtilityButtons;
    
    cell.lbl_taskName.text =  taskDetailDHolder.str_taskName;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter1 setDateFormat:@"yyyy/MM/dd"];
    NSDate *date_Temp =[dateFormatter dateFromString:taskDetailDHolder.str_taskStartDate];
    NSString *str_date = [dateFormatter1 stringFromDate:date_Temp];
    cell.lbl_taskStartDate.text = str_date;
    cell.delegate = self;
    return cell;
    
}
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    
    switch (index) {
        case 0:
        {
            MCAAlertView *alertView = [MCAGlobalFunction showAlert:@"Do you want to complete the task?"
                                                          delegate:self
                                                             btnOk:@"Confirm Action"
                                                         btnCancel:@"Cancel"];
            
            alertView.tag = 2;
            [cell hideUtilityButtonsAnimated:YES];
            
            break;
        }
        default:
        break;
    }
}
-(void)requestDeleteOrCompleteTask:(NSString*)info{
    
    if ([MCAGlobalFunction isConnectedToInternet]) {
        [[MCARestIntraction sharedManager]requestForDeleteOrCompleteTask:info :@"taskDetail"];
    }else{
        [HUD hide];
        [MCAGlobalFunction showAlert:NET_NOT_AVAIALABLE];
    }
}
# pragma mark - NS_NOTIFICATION SELECTOR
-(void)deleteTaskDetailSuccess:(NSNotification*)notification
{
    [HUD hide];
    [delegate deleteTaskDetail:taskDetailDHolder];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)completeTaskDetailSuccess:(NSNotification*)notification{
    
    [HUD hide];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)deleteOrCompleteTaskDetailFailed:(NSNotification*)notification{
    
    [HUD hide];
    [MCAGlobalFunction showAlert:notification.object];
    
}

@end
