//
//  MCATaskViewController.m
//  MobileCollegeAdmin
//
//  Created by aditi on 05/08/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MCATaskViewController.h"

@interface MCATaskViewController ()

@end

@implementation MCATaskViewController

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
    
    //Arya HUD
    HUD=[AryaHUD new];
    [self.view addSubview:HUD];
    
    arr_taskList = [NSMutableArray new];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(taskListSuccess:) name:NOTIFICATION_TASK_LIST_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(taskListFailed:) name:NOTIFICATION_TASK_LIST_FAILED object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteTaskSuccess:) name:NOTIFICATION_DELETE_TASK_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(completeTaskSuccess:) name:NOTIFICATION_COMPLETE_TASK_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteOrCompleteTaskFailed:) name:NOTIFICATION_DELETE_COMPLETE_TASK_FAILED object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addTaskSuccess:) name:NOTIFICATION_ADD_TASK_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addTaskFailed:) name:NOTIFICATION_ADD_TASK_FAILED object:nil];
    
    segControl_task.tintColor=[UIColor whiteColor];
    arr_gradeList = [[NSArray alloc]initWithObjects:@"My Task",@"12th",@"11th",@"10th", nil];
    [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:KEY_TASK_GRADE_INDEX];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    
    [navigationBar setBackgroundImage:[[UIImage alloc] init]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    
    [navigationBar setShadowImage:[UIImage new]];
    
    if ([[NSUserDefaults standardUserDefaults]integerForKey:KEY_STUDENT_COUNT] > 0) {
      
        UIImage* img_student = [UIImage imageNamed:@"student.png"];
        CGRect img_studFrame = CGRectMake(0, 0, img_student.size.width, img_student.size.height);
        UIButton *btn_student = [[UIButton alloc] initWithFrame:img_studFrame];
        [btn_student setBackgroundImage:img_student forState:UIControlStateNormal];
        [btn_student setShowsTouchWhenHighlighted:YES];
        
        UIBarButtonItem *btnBar_student =[[UIBarButtonItem alloc] initWithCustomView:btn_student];
        
        self.navigationItem.title = @"Task";
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:btnBar_student,nil]];
        //            [nav_TaskBar setItems:[NSArray arrayWithObject:self.navigationItem]];
        
//         [nav_TaskBar setItems:[NSArray arrayWithObject:self.navigationItem]];
    }else{
        
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_TYPE] isEqualToString:@"p"])
        {
            
            UIImage* img_add = [UIImage imageNamed:@"add.png"];
            CGRect img_addFrame = CGRectMake(0, 0, img_add.size.width, img_add.size.height);
            UIButton *btn_add = [[UIButton alloc] initWithFrame:img_addFrame];
            [btn_add setBackgroundImage:img_add forState:UIControlStateNormal];
            [btn_add addTarget:self
                         action:@selector(btnBar_addDidClicked:)
                     forControlEvents:UIControlEventTouchUpInside];
            [btn_add setShowsTouchWhenHighlighted:YES];
            
            UIImage* img_grade = [UIImage imageNamed:@"grade.png"];
            CGRect img_gradeFrame = CGRectMake(0, 0, img_grade.size.width, img_grade.size.height);
            UIButton *btn_grade = [[UIButton alloc] initWithFrame:img_gradeFrame];
            [btn_grade setBackgroundImage:img_grade forState:UIControlStateNormal];
            [btn_grade addTarget:self
                          action:@selector(btnBar_gradeDidClicked:)
                           forControlEvents:UIControlEventTouchUpInside];
            [btn_grade setShowsTouchWhenHighlighted:YES];
            
            UIBarButtonItem *btnBar_add =[[UIBarButtonItem alloc] initWithCustomView:btn_add];
            UIBarButtonItem *btnBar_grade =[[UIBarButtonItem alloc] initWithCustomView:btn_grade];
            
            self.navigationItem.title = @"Task";
            [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:btnBar_add,btnBar_grade, nil]];
            
        }else{
            
            UIImage* img_add = [UIImage imageNamed:@"add.png"];
            CGRect img_addFrame = CGRectMake(0, 0, img_add.size.width, img_add.size.height);
            UIButton *btn_add = [[UIButton alloc] initWithFrame:img_addFrame];
            [btn_add setBackgroundImage:img_add forState:UIControlStateNormal];
            [btn_add addTarget:self
                                 action:@selector(btnBar_addDidClicked:)
                     forControlEvents:UIControlEventTouchUpInside];
            [btn_add setShowsTouchWhenHighlighted:YES];
            
            UIBarButtonItem *btnBar_add =[[UIBarButtonItem alloc] initWithCustomView:btn_add];
            self.navigationItem.title = @"Task";
            [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:btnBar_add,nil]];
//            [nav_TaskBar setItems:[NSArray arrayWithObject:self.navigationItem]];
            
        }
    }
    
    [self performSelector:@selector(apiCalling:) withObject:nil afterDelay:1];
}
-(void)apiCalling:(id)sender{
    
     arr_taskList = [[MCADBIntraction databaseInteractionManager]retrieveTaskList:nil];
    
    //Api calling
    if (!arr_taskList.count > 0)
    {
        arr_taskList = [NSMutableArray new];
        [self getTaskList:nil];
        
    }else{
        
        [self createTaskList:@"My Task"];
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [view_transBg removeFromSuperview];
    [tbl_gradeList removeFromSuperview];
    self.navigationController.navigationBar.userInteractionEnabled = YES;
    
}
-(void)getTaskList:(id)sender{
    
    NSMutableDictionary *info=[NSMutableDictionary new];
    [info setValue:[[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_TYPE] forKey:@"user_type"];
    [info setValue:[[NSUserDefaults standardUserDefaults]valueForKey:KEY_LANGUAGE_CODE] forKey:@"language_code"];
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:KEY_LANGUAGE_CODE]) {
        [info setValue:[[NSUserDefaults standardUserDefaults]valueForKey:KEY_LANGUAGE_CODE] forKey:@"language_code"];
    }else{
        [info setValue:@"en_us" forKey:@"language_code"];
    }
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:KEY_NOW_DATE]) {
        [info setValue:[[NSUserDefaults standardUserDefaults]valueForKey:KEY_NOW_DATE] forKey:@"now_date"];
    }else{
        [info setValue:@"" forKey:@"now_date"];
    }
    
    [info setValue:@"get_task_list" forKey:@"cmd"];
    [info setValue:[[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_TOKEN] forKey:@"user_token"];
    [info setValue:@"" forKey:@"app_token"];
    [info setValue:@"ad607645c57ceb4" forKey:@"device_id"];
    [info setValue:[[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_ID] forKey:@"user_id"];
    [info setValue:@"1.0" forKey:@"app_ver"];
    
    NSError* error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:info
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString* jsonTaskData=  [[NSString alloc] initWithData:jsonData
                                                    encoding:NSUTF8StringEncoding];
    jsonTaskData = [jsonTaskData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    jsonTaskData = [jsonTaskData stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    [HUD show];
    [HUD setHUDText:@"Loading"];
    [self requestTaskList:jsonTaskData];
    
}

-(void)confirmationApi:(id)sender{
    
    NSMutableDictionary *info=[NSMutableDictionary new];
    
    [info setValue:@"[]" forKey:@"deleted_task"];
    
    [info setValue:@"conform" forKey:@"cmd"];
    [info setValue:[[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_TOKEN] forKey:@"user_token"];
    [info setValue:@"" forKey:@"app_token"];
    [info setValue:@"ad607645c57ceb4" forKey:@"device_id"];
    [info setValue:[[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_ID] forKey:@"user_id"];
    [info setValue:@"1.0" forKey:@"app_ver"];
    
    NSError* error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:info
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString* jsonConfirmationData=  [[NSString alloc] initWithData:jsonData
                                                   encoding:NSUTF8StringEncoding];
    jsonConfirmationData = [jsonConfirmationData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    jsonConfirmationData = [jsonConfirmationData stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    jsonConfirmationData = [jsonConfirmationData stringByReplacingOccurrencesOfString:@": \"\[" withString:@":["];
    jsonConfirmationData = [jsonConfirmationData stringByReplacingOccurrencesOfString:@"]\"" withString:@"]"];
    
    [HUD show];
    [HUD setHUDText:@"Loading"];
    [self requestConfirmation:jsonConfirmationData];
    
}
#pragma mark - IB_ACTION

-(IBAction)btnSegControl_taskDidClicked:(id)sender{
    
    if (segControl_task.selectedSegmentIndex == 0) {
        
        [tbl_taskCompleted removeFromSuperview];
        [tbl_taskDeleted removeFromSuperview];
        
        tbl_taskCurrent.delegate = self;
        tbl_taskCurrent.dataSource = self;
        if (IS_IPHONE_5) {
             tbl_taskCurrent.frame = CGRectMake(0, 36, 320, 422);
        }else{
             tbl_taskCurrent.frame = CGRectMake(0, 36, 320, 332);
        }
       
        [tbl_taskCurrent reloadData];
        [self.view addSubview:tbl_taskCurrent];
        
    }else if(segControl_task.selectedSegmentIndex == 1){
        
        [tbl_taskCurrent removeFromSuperview];
        [tbl_taskDeleted removeFromSuperview];
        
        tbl_taskCompleted.delegate = self;
        tbl_taskCompleted.dataSource = self;
        if (IS_IPHONE_5) {
            tbl_taskCompleted.frame = CGRectMake(0, 36, 320, 422);
        }else{
            tbl_taskCompleted.frame = CGRectMake(0, 36, 320, 332);
        }
        
        [tbl_taskCompleted reloadData];
        [self.view addSubview:tbl_taskCompleted];
      
    }else{
        
        [tbl_taskCompleted removeFromSuperview];
        [tbl_taskCurrent removeFromSuperview];
        
        tbl_taskDeleted.delegate = self;
        tbl_taskDeleted.dataSource = self;
        if (IS_IPHONE_5) {
            tbl_taskDeleted.frame = CGRectMake(0, 36, 320, 422);
        }else{
            tbl_taskDeleted.frame = CGRectMake(0, 36, 320, 332);
        }
      
        [tbl_taskDeleted reloadData];
        [self.view addSubview:tbl_taskDeleted];
    }
}
-(void)btnBar_addDidClicked:(id)sender{
    
    [self performSegueWithIdentifier:@"segue_AddTask" sender:nil];
}
-(void)btnBar_gradeDidClicked:(id)sender{
    
    if (IS_IPHONE_5) {
        view_transBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    }else{
        view_transBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    }
    
    view_transBg.backgroundColor = [UIColor blackColor];
    view_transBg.layer.opacity = 0.7f;
    [self.view addSubview:view_transBg];
    
    tbl_gradeList = [[UITableView alloc]initWithFrame:CGRectMake(20, 160, 282, 160)];
    tbl_gradeList.dataSource = self;
    tbl_gradeList.delegate = self;
    [tbl_gradeList reloadData];
    [self.view addSubview:tbl_gradeList];
    [self.view bringSubviewToFront:tbl_gradeList];
    
    self.navigationController.navigationBar.userInteractionEnabled = NO;
}
-(void)btn_selectGradeDidClicked:(id)sender{
    
    MCACustomButton *btn_temp = (MCACustomButton*)sender;
    
    NSString *str_selectedGrade = [arr_gradeList objectAtIndex:btn_temp.index];
    
    [[NSUserDefaults standardUserDefaults]setInteger:btn_temp.index forKey:KEY_TASK_GRADE_INDEX];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    str_selectedGrade = [str_selectedGrade stringByReplacingOccurrencesOfString:@"th" withString:@""];
    
    [view_transBg removeFromSuperview];
    [tbl_gradeList removeFromSuperview];
    [HUD show];
    [self createTaskList:str_selectedGrade];
    self.navigationController.navigationBar.userInteractionEnabled = YES;
    
}
-(void)btn_deleteTaskDidClicked:(id)sender{
    
    
    
}
#pragma mark -  UITABLEVIEW DELEGATE AND DATASOURCE METHODS

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (tableView == tbl_gradeList) {
        return 32;
    }else{
        return 0;
    }
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == tbl_gradeList) {
        // 1. The view for the header
        
        UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,30)];
        
        // 2. Set a custom background color and a border
        headerView.backgroundColor = [UIColor colorWithRed:39.0/255 green:166.0/255 blue:213.0/255 alpha:1];
        
        // 3. Add an image
        UILabel* headerLabel = [[UILabel alloc] init];
        headerLabel.frame = CGRectMake(0,2,282,22);
        headerLabel.textColor = [UIColor whiteColor];
        headerLabel.font = [UIFont boldSystemFontOfSize:14];
        headerLabel.text = @"Select a grade";
        headerLabel.textAlignment = NSTextAlignmentCenter;
        
        [headerView addSubview:headerLabel];
        
        // 5. Finally return
        return headerView;
    }else{
        
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == tbl_gradeList) {
        return 32;
    }else{
        return 72;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
       
    if (tableView == tbl_taskCurrent) {
        
        return arr_currentTaskList.count;
        
     }else if (tableView == tbl_taskCompleted){
        
        return arr_completedTaskList.count;
         
     }else if(tableView == tbl_taskDeleted){
         
         return arr_deletedTaskList.count;
     }else{
         
         return arr_gradeList.count;
     }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == tbl_gradeList) {
        NSString *cellIdentifier =@"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:cellIdentifier];
      
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:12.0f];
        cell.textLabel.text = [arr_gradeList objectAtIndex:indexPath.row];

        MCACustomButton *btn_selectGrade = [MCACustomButton buttonWithType:UIButtonTypeCustom];
        btn_selectGrade.frame = CGRectMake(242, 4, 24, 24);
        btn_selectGrade.layer.cornerRadius = 12.0f;
      
        if (indexPath.row == [[NSUserDefaults standardUserDefaults]integerForKey:KEY_TASK_GRADE_INDEX]) {
           
            [btn_selectGrade setBackgroundImage:[UIImage imageNamed:@"blue_checkMark.png"]
                                       forState:UIControlStateNormal];
            
        }
        
         btn_selectGrade.layer.borderColor = [UIColor colorWithRed:39.0/255 green:166.0/255 blue:213.0/255 alpha:1].CGColor;
         btn_selectGrade.layer.borderWidth = 1.0f;
         [btn_selectGrade addTarget:self
                     action:@selector(btn_selectGradeDidClicked:)
           forControlEvents:UIControlEventTouchUpInside];
         btn_selectGrade.index = indexPath.row;
         [cell addSubview:btn_selectGrade];
        
        tbl_gradeList.separatorInset=UIEdgeInsetsMake(0.0, 0 + 1.0, 0.0, 0.0);
        
        return cell;

    }else{
        CustomTableViewCell *cell;
        MCATaskDetailDHolder *taskDHolder;
        
        if (tableView == tbl_taskCurrent) {
            
            static NSString *cellIdentifier = @"Cell";
            taskDHolder = (MCATaskDetailDHolder *)[arr_currentTaskList objectAtIndex:indexPath.row];
            cell  = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:                                                 cellIdentifier forIndexPath:indexPath];
            
            // Add utility buttons
            NSMutableArray *leftUtilityButtons = [NSMutableArray new];
            NSMutableArray *rightUtilityButtons = [NSMutableArray new];
            
            if ([taskDHolder.str_taskPriority isEqualToString:@"h"]) {
                
                cell.lbl_taskPriority.text = @"Higher";
                cell.lbl_taskPriority.textColor = [UIColor colorWithRed:251.0/255.0 green:0.0/255.0 blue:71.0/255.0 alpha:1.0];
                cell.lbl_taskColor.backgroundColor = [UIColor colorWithRed:251.0/255.0 green:0.0/255.0 blue:71.0/255.0 alpha:1.0];
                [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:251.0/255.0 green:0.0/255.0 blue:71.0/255.0 alpha:1.0]icon:[UIImage imageNamed:@"taskSelect.png"]];
                
            }else{
                
                cell.lbl_taskPriority.text = @"Regular";
                cell.lbl_taskPriority.textColor = [UIColor colorWithRed:254.0/255.0 green:206.0/255.0 blue:36.0/255.0 alpha:1.0];
                cell.lbl_taskColor.backgroundColor = [UIColor colorWithRed:254.0/255.0 green:206.0/255.0 blue:36.0/255.0 alpha:1.0];
                [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:254.0/255.0 green:206.0/255.0 blue:36.0/255.0 alpha:1.0]icon:[UIImage imageNamed:@"taskSelect.png"]];
                
            }
            
            [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor redColor]
                                                         icon:[UIImage imageNamed:@"delete1.png"]];
            
            cell.leftUtilityButtons = leftUtilityButtons;
            cell.rightUtilityButtons = rightUtilityButtons;

            
        }else if (tableView == tbl_taskCompleted){
            
            static NSString *cellIdentifier = @"Cell";
            taskDHolder = (MCATaskDetailDHolder *)[arr_completedTaskList objectAtIndex:indexPath.row];
            cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:                                                 cellIdentifier forIndexPath:indexPath];
            
            if ([taskDHolder.str_taskPriority isEqualToString:@"h"]) {
                
                cell.lbl_taskPriority.text = @"Higher";
                cell.lbl_taskPriority.textColor = [UIColor colorWithRed:251.0/255.0 green:0.0/255.0 blue:71.0/255.0 alpha:1.0];
                cell.lbl_taskColor.backgroundColor = [UIColor colorWithRed:251.0/255.0 green:0.0/255.0 blue:71.0/255.0 alpha:1.0];
                
                
            }else{
                
                cell.lbl_taskPriority.text = @"Regular";
                cell.lbl_taskPriority.textColor = [UIColor colorWithRed:254.0/255.0 green:206.0/255.0 blue:36.0/255.0 alpha:1.0];
                cell.lbl_taskColor.backgroundColor = [UIColor colorWithRed:254.0/255.0 green:206.0/255.0 blue:36.0/255.0 alpha:1.0];
               
                
            }

        }else{
            
            static NSString *cellIdentifier = @"Cell";
            taskDHolder = (MCATaskDetailDHolder *)[arr_deletedTaskList objectAtIndex:indexPath.row];
            cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:                                                 cellIdentifier forIndexPath:indexPath];
            
            if ([taskDHolder.str_taskPriority isEqualToString:@"h"]) {
                
                cell.lbl_taskPriority.text = @"Higher";
                cell.lbl_taskPriority.textColor = [UIColor colorWithRed:251.0/255.0 green:0.0/255.0 blue:71.0/255.0 alpha:1.0];
                cell.lbl_taskColor.backgroundColor = [UIColor colorWithRed:251.0/255.0 green:0.0/255.0 blue:71.0/255.0 alpha:1.0];
               
                
            }else{
                
                cell.lbl_taskPriority.text = @"Regular";
                cell.lbl_taskPriority.textColor = [UIColor colorWithRed:254.0/255.0 green:206.0/255.0 blue:36.0/255.0 alpha:1.0];
                cell.lbl_taskColor.backgroundColor = [UIColor colorWithRed:254.0/255.0 green:206.0/255.0 blue:36.0/255.0 alpha:1.0];
                
            }
        }
        
        // Configure the cell
        cell.lbl_taskName.text = taskDHolder.str_taskName;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc]init];
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [dateFormatter1 setDateFormat:@"yyyy/MM/dd"];
        NSDate *dateTemp =[dateFormatter dateFromString:taskDHolder.str_taskStartDate];
        NSString *strDate = [dateFormatter1 stringFromDate:dateTemp];
        cell.lbl_taskStartDate.text = strDate;
        
              cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MCATaskDetailDHolder *taskDetailDHolder;
    
    if (tableView == tbl_taskCurrent) {
        
        taskDetailDHolder  = [arr_currentTaskList objectAtIndex:indexPath.row];
    }else if(tableView == tbl_taskCompleted){
        
        taskDetailDHolder = [arr_completedTaskList objectAtIndex:indexPath.row];
    }else if (tableView == tbl_taskDeleted){
        
        taskDetailDHolder = [arr_deletedTaskList objectAtIndex:indexPath.row];
    }
        [self performSegueWithIdentifier:@"segue_taskDetail" sender:taskDetailDHolder];
  
}
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    
    switch (index) {
        case 0:
        {
            NSIndexPath *cellIndexPath = [tbl_taskCurrent indexPathForCell:cell];
            MCATaskDetailDHolder *taskDHolder  = [arr_currentTaskList objectAtIndex:cellIndexPath.row];
            
            NSDateFormatter *dateFormatterTime = [[NSDateFormatter alloc]init];
            [dateFormatterTime setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            NSString *str_dateTime = [dateFormatterTime stringFromDate:[NSDate date]];
            
            arr_completedTaskDetail = [NSMutableArray new];
            taskDHolder.str_taskStatus = @"c";
            [arr_completedTaskDetail addObject:taskDHolder];
            
            NSMutableDictionary *info=[NSMutableDictionary new];
            [info setValue:str_dateTime forKey:@"updated_at"];
            [info setValue:@"c" forKey:@"task_status"];
            [info setValue:taskDHolder.str_taskId forKey:@"task_id"];
            
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
            [self requestDeleteOrCompleteTask:jsonDeleteTaskData];
            [cell hideUtilityButtonsAnimated:YES];
            break;
        }
            default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
   
    switch (index) {
      case 0:
      {
            NSIndexPath *cellIndexPath = [tbl_taskCurrent indexPathForCell:cell];
            MCATaskDetailDHolder *taskDHolder  = [arr_currentTaskList objectAtIndex:cellIndexPath.row];
        
            NSDateFormatter *dateFormatterTime = [[NSDateFormatter alloc]init];
            [dateFormatterTime setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            NSString *str_dateTime = [dateFormatterTime stringFromDate:[NSDate date]];
         
            arr_deletedTaskDetail = [NSMutableArray new];
            taskDHolder.str_taskStatus = @"d";
            [arr_deletedTaskDetail addObject:taskDHolder];
          
            NSMutableDictionary *info=[NSMutableDictionary new];
            [info setValue:str_dateTime forKey:@"updated_at"];
            [info setValue:@"d" forKey:@"task_status"];
            [info setValue:taskDHolder.str_taskId forKey:@"task_id"];
            
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
            [self requestDeleteOrCompleteTask:jsonDeleteTaskData];
            [cell hideUtilityButtonsAnimated:YES];
            break;
        }
           default:
            break;
    }
}
#pragma mark - API CALLING

-(void)requestTaskList:(NSString*)info{
    
    if ([MCAGlobalFunction isConnectedToInternet]) {
        [[MCARestIntraction sharedManager]requestForTaskList:info];
    }else{
//        arr_taskList = [[MCADBIntraction databaseInteractionManager]retrieveTaskList:nil];
        [self createTaskList:@"My Task"];
//        [MCAGlobalFunction showAlert:NET_NOT_AVAIALABLE];
    }
}
-(void)requestConfirmation:(NSString*)info{
    
    if ([MCAGlobalFunction isConnectedToInternet]) {
        [[MCARestIntraction sharedManager]requestForConfirmationApi:info];
    }else{
        [MCAGlobalFunction showAlert:NET_NOT_AVAIALABLE];
    }
}
-(void)requestDeleteOrCompleteTask:(NSString*)info{
    
    if ([MCAGlobalFunction isConnectedToInternet]) {
        [[MCARestIntraction sharedManager]requestForDeleteOrCompleteTask:info];
    }else{
         [MCAGlobalFunction showAlert:NET_NOT_AVAIALABLE];
    }
}
#pragma mark - NSNOTIFICATION SELECTOR

-(void)taskListSuccess:(NSNotification*)notification{

    arr_taskList = notification.object;
   
    if ([[NSUserDefaults standardUserDefaults]valueForKey:KEY_NOW_DATE]) {
        
        [[MCADBIntraction databaseInteractionManager]deleteTask:arr_taskList];
        [[MCADBIntraction databaseInteractionManager]insertTaskList:arr_taskList];
        
    }else{
        
        [[MCADBIntraction databaseInteractionManager]insertTaskList:arr_taskList];
    }
    
    [self confirmationApi:nil];
    [self createTaskList:@"My Task"];
    
}
-(void)taskListFailed:(NSNotification*)notification{
    
    [HUD hide];
}
-(void)deleteTaskSuccess:(NSNotification*)notification{

//    [self getTaskList:nil];
    [[MCADBIntraction databaseInteractionManager]updateTaskList:arr_deletedTaskDetail];
    [self createTaskList:@"My Task"];
}
-(void)completeTaskSuccess:(NSNotification*)notification{
    
    [[MCADBIntraction databaseInteractionManager]updateTaskList:arr_completedTaskDetail];
    [self createTaskList:@"My Task"];
}
-(void)deleteOrCompleteTaskFailed:(NSNotification*)notification{
    
    [HUD hide];
    [MCAGlobalFunction showAlert:notification.object];
}
-(void)addTaskSuccess:(NSNotification*)notification{
    
    [HUD hide];
    [self getTaskList:nil];
    
}

-(void)addTaskFailed:(NSNotification*)notification{
    
    [HUD hide];
    [MCAGlobalFunction showAlert:notification.object];
}
#pragma mark - OTHER_METHODS

-(void)createTaskList:(id)sender{
    
    [HUD show];
    
    arr_taskList = [NSMutableArray new];
    arr_currentTaskList  = [NSMutableArray new];
    arr_completedTaskList  = [NSMutableArray new];
    arr_deletedTaskList = [NSMutableArray new];
    
    arr_taskList = [[MCADBIntraction databaseInteractionManager]retrieveTaskList:nil];
    
    for (int i = 0; i < arr_taskList.count; i++)
    {
      MCATaskDetailDHolder *taskDHolder = (MCATaskDetailDHolder *)[arr_taskList objectAtIndex:i];
        
      [[NSUserDefaults standardUserDefaults]setValue:taskDHolder.str_nowDate forKey:KEY_NOW_DATE];
      [[NSUserDefaults standardUserDefaults]synchronize];
        
      if ([[[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_TYPE] isEqualToString:@"p"])
      {
        if ([sender isEqualToString:@"My Task"]) {
            
            if ([taskDHolder.str_taskStatus isEqualToString:@"o"] && [taskDHolder.str_userId isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_ID]] && [taskDHolder.str_createdBy isEqualToString:@"p"] ){
                
                [arr_currentTaskList addObject:taskDHolder];
                
            }else if ([taskDHolder.str_taskStatus isEqualToString:@"c"] && [taskDHolder.str_userId isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_ID]] && [taskDHolder.str_createdBy isEqualToString:@"p"]){
                
                [arr_completedTaskList addObject:taskDHolder];
                
            }else if([taskDHolder.str_taskStatus isEqualToString:@"d"] && [taskDHolder.str_userId isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_ID]] && [taskDHolder.str_createdBy isEqualToString:@"p"]){
                
                [arr_deletedTaskList addObject:taskDHolder];
            }
            
        }else{
            if ([taskDHolder.str_taskStatus isEqualToString:@"o"] && [taskDHolder.str_grade isEqualToString:sender]){
                
                [arr_currentTaskList addObject:taskDHolder];
                
            }else if ([taskDHolder.str_taskStatus isEqualToString:@"c"] && [taskDHolder.str_grade isEqualToString:sender]){
                
                [arr_completedTaskList addObject:taskDHolder];
                
            }else if([taskDHolder.str_taskStatus isEqualToString:@"d"] && [taskDHolder.str_grade isEqualToString:sender]){
                
                [arr_deletedTaskList addObject:taskDHolder];
             }
          }
      }else{
          
          if ([taskDHolder.str_taskStatus isEqualToString:@"o"]){
              
              [arr_currentTaskList addObject:taskDHolder];
              
          }else if ([taskDHolder.str_taskStatus isEqualToString:@"c"]){
              
              [arr_completedTaskList addObject:taskDHolder];
              
          }else if([taskDHolder.str_taskStatus isEqualToString:@"d"]){
              
              [arr_deletedTaskList addObject:taskDHolder];
          }
       }
   }
    
    NSLog(@"%ld",(long)segControl_task.selectedSegmentIndex);
    
    [HUD hide];
    [self btnSegControl_taskDidClicked:nil];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"segue_taskDetail"]) {
        
        MCATaskDetailViewController *taskDetailViewCtr = (MCATaskDetailViewController*)[segue destinationViewController];
        
        taskDetailViewCtr.taskDetailDHolder = (MCATaskDetailDHolder*)sender;
        
    }
    
}
@end
