//
//  MCAMoreViewController.m
//  MobileCollegeAdmin
//
//  Created by aditi on 16/08/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MCAMoreViewController.h"

@interface MCAMoreViewController ()

@end

@implementation MCAMoreViewController

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
    
    arr_moreOptionList = [[NSMutableArray alloc]initWithObjects:@"Settings",@"Share",@"Feedback",@"Logout", nil];
    arr_moreImageList = [[NSMutableArray alloc]initWithObjects:@"setting.png",@"share.png",@"feedback.png",@"list.png", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)btnLogoutDidClicked:(id)sender{
    
    [[MCADBIntraction databaseInteractionManager]deleteTaskList:nil];
    [[MCADBIntraction databaseInteractionManager]deleteStudList:nil];
    
    MCAAppDelegate *appdelegate = (MCAAppDelegate *)[UIApplication sharedApplication].delegate;
    [appdelegate logout];
    
}
#pragma mark UITABLEVIEW DELEGATE AND DATASOURCE METHODS

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arr_moreOptionList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [arr_moreOptionList objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[arr_moreImageList objectAtIndex:indexPath.row]];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    tbl_moreOption.separatorInset=UIEdgeInsetsMake(0.0, 0 + 1.0, 0.0, 0.0);
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 3) {
        [self btnLogoutDidClicked:nil];
    }
}
@end
