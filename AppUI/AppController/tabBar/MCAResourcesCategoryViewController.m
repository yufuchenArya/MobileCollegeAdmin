//
//  MCAResourcesCategoryViewController.m
//  MobileCollegeAdmin
//
//  Created by rashmi on 9/12/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MCAResourcesCategoryViewController.h"
#import "MCAResourcesViewController.h"

@interface MCAResourcesCategoryViewController ()

@end

@implementation MCAResourcesCategoryViewController

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
    arr_resourcesCategory = [NSMutableArray new];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resourcesCategoryFailed:) name:NOTIFICATION_RESOURCE_CATEGORY_FAILED object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resourcesCategorySuccess:) name:NOTIFICATION_RESOURCE_CATEGORY_SUCCESS object:nil];
    
    [self getResourcesCategory:nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -  UITABLEVIEW DELEGATE AND DATASOURCE METHODS

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 42;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arr_resourcesCategory.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"resourcesCell";
    UITableViewCell  *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellIdentifier];
    }
    MCAResourcesCatDHolder *reDHolder = (MCAResourcesCatDHolder*)[arr_resourcesCategory objectAtIndex:indexPath.row];
    UILabel *lbl_catName = (UILabel *)[cell.contentView viewWithTag:2];
    lbl_catName.text = reDHolder.str_resourcesCatName;
    
    UIImageView *img_cat=(UIImageView *)[cell.contentView viewWithTag:1];
    [img_cat removeFromSuperview];
    img_cat = nil;
    img_cat = [[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 26, 26)];
    img_cat.tag = 1;
    [cell.contentView addSubview:img_cat];
    
    [img_cat setImageWithUrl:[NSURL URLWithString:reDHolder.str_resourcesCatImage]
               andPlaceHoder:[UIImage imageNamed:PLACEHOLDER_IMAGE]
                  andNoImage:[UIImage imageNamed:NO_IMAGE]];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MCAResourcesCatDHolder *reDHolder = (MCAResourcesCatDHolder*)[arr_resourcesCategory objectAtIndex:indexPath.row];\
    if ([reDHolder.str_resourcesCatId isEqualToString:@"10"]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile College Admin" message:@"You have to purchase for this version. Do you want to purchase?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"Yes", nil];
        alert.backgroundColor = [UIColor blueColor];
        [alert show];
    }
    else
    [self performSegueWithIdentifier:@"segue_resources" sender:reDHolder];
    
}

-(void)willPresentAlertView:(UIAlertView *)alertView{
    UIImage *theImage = [UIImage imageNamed:@"BlueBg.png"];
    UIView *view=[alertView valueForKey:@"_backgroundImageView"];
    //Set frame according to adustable
    UIImageView *image=[[UIImageView alloc] initWithImage:theImage];
    [image setFrame:CGRectMake(0, 0, 280, 130)];
    [view addSubview:image];
    NSLog(@"%lu", (unsigned long)[alertView subviews].count);
    //[[[alertView subviews] objectAtIndex:3] setBackgroundColor:[UIColor blueColor]];
}

-(void)alertView:(UIAlertView*)alterView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URL_APPLESTORE]];
    }
}


-(void)getResourcesCategory:(id)sender{
    
    NSMutableDictionary * info = [NSMutableDictionary new];
    
    [info setValue:@"get_resource_category" forKey:@"cmd"];
    [info setValue:@"en_us" forKey:@"language_code"];
    
    NSString *str_jsonCategory = [NSString getJsonObject:info];
    [HUD showForTabBar];
    [self.view bringSubviewToFront:HUD];
    [self requestResourcesCategory:str_jsonCategory];
    
}

-(void)requestResourcesCategory:(NSString*)info{
    
    if ([MCAGlobalFunction isConnectedToInternet]) {
        
        [[MCARestIntraction sharedManager]requestForResourcesCategory:info];
        
    }else{
        
        [HUD hide];
        arr_resourcesCategory = [[MCADBIntraction databaseInteractionManager] retrieveResourceCatList: nil];
        [tbl_resourcesCategory reloadData];
    }
}

#pragma mark - NSNOTIFICATION SELECTOR

-(void)resourcesCategorySuccess:(NSNotification*)notification{
    
    [HUD hide];
    arr_resourcesCategory = notification.object;
    
    [[MCADBIntraction databaseInteractionManager]insertResourceCatList:arr_resourcesCategory];
    [tbl_resourcesCategory reloadData];
}
-(void)resourcesCategoryFailed:(NSNotification*)notification{
    
    [HUD hide];
}

#pragma mark - OTHER_METHOD

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"segue_resources"]) {
        
        MCAResourcesViewController *reViewCtr = (MCAResourcesViewController*)[segue destinationViewController];
        reViewCtr.reCatDHolder = (MCAResourcesCatDHolder*)sender;
    }
}



@end
