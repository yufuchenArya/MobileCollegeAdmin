//
//  MCAResourcesViewController.m
//  MobileCollegeAdmin
//
//  Created by rashmi on 9/12/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MCAResourcesViewController.h"

@interface MCAResourcesViewController ()

@end

@implementation MCAResourcesViewController
@synthesize reCatDHolder;

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
    
    HUD = [AryaHUD new];
    [self.view addSubview:HUD];
    
    arr_resources = [NSMutableArray new];
    
    self.navigationItem.title = reCatDHolder.str_resourcesCatName;
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resourceFailed:) name:NOTIFICATION_RESOURCE_FAILED object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resourceSuccess:) name:NOTIFICATION_RESOURCE_SUCCESS object:nil];
    
    [self getResources:reCatDHolder.str_resourcesCatId];
    // Do any additional setup after loading the view.
}
-(void)getResources:(id)sender{
    
    NSMutableDictionary * info = [NSMutableDictionary new];
    
    [info setValue:@"get_resource" forKey:@"cmd"];
    [info setValue:@"en_us" forKey:@"language_code"];
    [info setValue:sender forKey:@"resource_id"];
    
    NSString *str_jsonNotes = [NSString getJsonObject:info];
    [HUD showForTabBar];
    [self.view bringSubviewToFront:HUD];
    [self requestResource:str_jsonNotes];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - API CALLING

-(void)requestResource:(NSString*)info{
    
    if ([MCAGlobalFunction isConnectedToInternet]) {
        
        [[MCARestIntraction sharedManager] requestForResources:info];
        
    }else{
        
        [HUD hide];
    }
}

#pragma mark - NSNOTIFICATION SELECTOR

-(void)resourceSuccess:(NSNotification*)notification{
    
    [HUD hide];
    arr_resources = notification.object;
    [tbl_resources reloadData];
    //[self writeToFile:nil];
    
}
-(void)resourceFailed:(NSNotification*)notification{
    
    [HUD hide];
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 42;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arr_resources.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"resourcesViewCell";
    UITableViewCell  *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellIdentifier];
    }
    MCAResourcesDHolder *reDholder = (MCAResourcesDHolder*)[arr_resources objectAtIndex:indexPath.row];
    UILabel *lbl_catName = (UILabel *)[cell.contentView viewWithTag:2];
    lbl_catName.text = reDholder.str_book_name;

    
    tbl_resources.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MCAResourcesDHolder *reDHolder = (MCAResourcesDHolder*)[arr_resources objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"segue_url" sender:reDHolder];
}

#pragma mark - OTHER_METHOD

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"segue_url"]) {
        MCAResourcesDetailViewController * reDetailCtr = (MCAResourcesDetailViewController*)[segue destinationViewController];
        reDetailCtr.reDHolder = (MCAResourcesDHolder*)sender;
    }
}
@end
