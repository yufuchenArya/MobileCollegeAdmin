//
//  MCACalendarViewController.m
//  MobileCollegeAdmin
//
//  Created by aditi on 22/08/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MCACalendarViewController.h"

@interface MCACalendarViewController ()

@end

@implementation MCACalendarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
 
    //Navigation Bar Setting
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBackgroundImage:[[UIImage alloc] init]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
    
     arr_gradeList = [[NSArray alloc]initWithObjects:@"12th",@"11th",@"10th", nil];
    
    if ([[NSUserDefaults standardUserDefaults]integerForKey:KEY_STUDENT_COUNT] > 0)
    {
        UIImage* img_student = [UIImage imageNamed:@"student.png"];
        CGRect img_studFrame = CGRectMake(0, 0, img_student.size.width, img_student.size.height);
        UIButton *btn_student = [[UIButton alloc] initWithFrame:img_studFrame];
        [btn_student setBackgroundImage:img_student forState:UIControlStateNormal];
        [btn_student addTarget:self
                        action:@selector(btnBar_studentDidClicked:)
              forControlEvents:UIControlEventTouchUpInside];
        [btn_student setShowsTouchWhenHighlighted:YES];
        
        UIBarButtonItem *btnBar_student =[[UIBarButtonItem alloc] initWithCustomView:btn_student];
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:btnBar_student,nil]];
     
    }else
    {    
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_TYPE] isEqualToString:@"p"])
        {
            UIImage* img_grade = [UIImage imageNamed:@"grade.png"];
            CGRect img_gradeFrame = CGRectMake(0, 0, img_grade.size.width, img_grade.size.height);
            UIButton *btn_grade = [[UIButton alloc] initWithFrame:img_gradeFrame];
            [btn_grade setBackgroundImage:img_grade forState:UIControlStateNormal];
            [btn_grade addTarget:self
                          action:@selector(btnBar_gradeDidClicked:)
                forControlEvents:UIControlEventTouchUpInside];
            [btn_grade setShowsTouchWhenHighlighted:YES];
            
           UIBarButtonItem *btnBar_grade =[[UIBarButtonItem alloc] initWithCustomView:btn_grade];
           [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:btnBar_grade, nil]];
        }
    }
    
   
}
-(void)viewWillAppear:(BOOL)animated{
  
     [self createTaskList:@"12"];
     calendar = [[MCACalendarView alloc] init];
     calendar.delegate=self;
     [self.view addSubview:calendar];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [calendar removeFromSuperview];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [view_transBg removeFromSuperview];
    [tbl_gradeList removeFromSuperview];
    self.navigationController.navigationBar.userInteractionEnabled = YES;
    tabBarMCACtr.tabBar.userInteractionEnabled = YES;
    
}
#pragma mark - IB_ACTION

-(void)btnBar_gradeDidClicked:(id)sender{
    
    if (IS_IPHONE_5) {
        view_transBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    }else{
        view_transBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    }
    
    view_transBg.backgroundColor = [UIColor blackColor];
    view_transBg.layer.opacity = 0.6f;
    [self.view addSubview:view_transBg];
    
    tbl_gradeList = [[UITableView alloc]initWithFrame:CGRectMake(20, 160, 282, 128)];
    tbl_gradeList.dataSource = self;
    tbl_gradeList.delegate = self;
    [tbl_gradeList reloadData];
    [self.view addSubview:tbl_gradeList];
    [self.view bringSubviewToFront:tbl_gradeList];
    
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    tabBarMCACtr.tabBar.userInteractionEnabled = NO;
}
-(void)btn_selectGradeDidClicked:(id)sender{
    
    MCACustomButton *btn_temp = (MCACustomButton*)sender;
    NSString *str_selectedGrade = [arr_gradeList objectAtIndex:btn_temp.index];
    
    [[NSUserDefaults standardUserDefaults]setInteger:btn_temp.index forKey:KEY_TASK_GRADE_INDEX];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    str_selectedGrade = [str_selectedGrade stringByReplacingOccurrencesOfString:@"th" withString:@""];
    
    [view_transBg removeFromSuperview];
    [tbl_gradeList removeFromSuperview];
   
    [self createTaskList:str_selectedGrade];
    self.navigationController.navigationBar.userInteractionEnabled = YES;
    
}
-(void)btnBar_studentDidClicked:(id)sender{
    
//    if (IS_IPHONE_5) {
//        view_transBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
//    }else{
//        view_transBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
//    }
//    
//    view_transBg.backgroundColor = [UIColor blackColor];
//    view_transBg.layer.opacity = 0.6f;
//    [self.view addSubview:view_transBg];
//    
//    tbl_studentList = [[UITableView alloc]initWithFrame:CGRectMake(20, 160, 282, arr_studentList.count * 32 + 64)];
//    tbl_studentList.dataSource = self;
//    tbl_studentList.delegate = self;
//    [tbl_studentList reloadData];
//    [self.view addSubview:tbl_studentList];
//    [self.view bringSubviewToFront:tbl_studentList];
//    
//    self.navigationController.navigationBar.userInteractionEnabled = NO;
    
}

#pragma mark - CALENDAR_VIEW METHODS

-(void)calendarView:(MCACalendarView *)calendarView switchedToMonth:(int)month switchedToYear:(int)year targetHeight:(float)targetHeight animated:(BOOL)animated {
    
    NSMutableArray *arr_taskDates = [NSMutableArray new];
    NSMutableArray  *arr_taskPriority=[NSMutableArray new];
    
    for (int i=0; i<arr_currentTaskList.count; i++)
    {
        MCATaskDetailDHolder *taskDHolder = (MCATaskDetailDHolder *)[arr_currentTaskList objectAtIndex:i];
        NSString *str_startDate = taskDHolder.str_taskStartDate;
      
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd 00:00:00"];
        NSDate *date = [formatter dateFromString:str_startDate];
        
        if(date!=nil)
        {
            NSInteger age = [date timeIntervalSinceNow]/31556926;
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
            NSInteger selectedDay = [components day];
            NSInteger selectedMonth = [components month];
            NSInteger selectedYear = [components year];
            
            NSLog(@"Day:%d Month:%ld Year:%ld Age:%ld",selectedDay,(long)selectedMonth,(long)selectedYear,(long)age);
            
            if (month == selectedMonth && year == selectedYear)
            {
                [arr_taskDates addObject:[NSNumber numberWithInt:selectedDay]];
                [arr_taskPriority addObject:taskDHolder.str_taskPriority];
                 [calendarView markDates:arr_taskDates priorityQueue:arr_taskPriority];
            }
         }
     }
}

-(void)calendarView:(MCACalendarView *)calendarView dateSelected:(NSDate *)date {
    
    NSLog(@"Selected date = %@",date);
    
}

#pragma mark - UITABLEVIEW DELEGATE AND DATASOURCE METHODS

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
    }else {
        
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
    
    return arr_gradeList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
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

}
#pragma mark - OTHER_METHOD

-(void)createTaskList:(id)sender{
    
    arr_taskList = [[MCADBIntraction databaseInteractionManager]retrieveTaskList:nil];
    arr_currentTaskList = [NSMutableArray new];
    
    for (int i=0; i<arr_taskList.count; i++)
    {
        MCATaskDetailDHolder *taskDHolder = (MCATaskDetailDHolder *)[arr_taskList objectAtIndex:i];
        
        if ([taskDHolder.str_status isEqualToString:@"1"])
        {
            if ([[NSUserDefaults standardUserDefaults]integerForKey:KEY_STUDENT_COUNT] > 0)
            {
                if ([sender isEqualToString:@"All"] || [sender isEqualToString:@"12"])
                {
                    if ([taskDHolder.str_taskStatus isEqualToString:@"o"])
                    {
                        [arr_currentTaskList addObject:taskDHolder];
                
                    }
                }else
                {
                    if ([taskDHolder.str_taskStatus isEqualToString:@"o"] && [taskDHolder.str_userId isEqualToString:sender]) {
                        
                        [arr_currentTaskList addObject:taskDHolder];
                        
                 }
            }
         }else{
                if ([[[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_TYPE] isEqualToString:@"p"])
                {
                    if (([taskDHolder.str_taskStatus isEqualToString:@"o"] && [taskDHolder.str_grade isEqualToString:sender])
                        || ([taskDHolder.str_taskStatus isEqualToString:@"o"] && [taskDHolder.str_userId isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_ID]] && [taskDHolder.str_createdBy isEqualToString:@"p"]))
                    {
                        [arr_currentTaskList addObject:taskDHolder];
                    }
                }else{
                    
                    if ([taskDHolder.str_taskStatus isEqualToString:@"o"]){
                        
                        [arr_currentTaskList addObject:taskDHolder];
                        
                    }
                }
            }
        }
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
@end
