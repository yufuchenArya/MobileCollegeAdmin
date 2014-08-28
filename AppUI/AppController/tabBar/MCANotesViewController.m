//
//  MCANotesViewController.m
//  MobileCollegeAdmin
//
//  Created by aditi on 28/08/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MCANotesViewController.h"

@interface MCANotesViewController ()

@end

@implementation MCANotesViewController

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
    
    arr_notesCategory = [NSMutableArray new];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notesCategoryFailed:) name:NOTIFICATION_NOTES_CATEGORY_FAILED object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notesCategorySuccess:) name:NOTIFICATION_NOTES_CATEGORY_SUCCESS object:nil];
    
    [self getNotesCategory:nil];
    
    [MCALocalStoredFolder createRootDir];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getNotesCategory:(id)sender{
    
    NSMutableDictionary * info = [NSMutableDictionary new];
    
    [info setValue:@"get_note_category" forKey:@"cmd"];
    [info setValue:@"en_us" forKey:@"language_code"];
    
    NSString *str_jsonCategory = [NSString getJsonObject:info];
    [HUD showForTabBar];
    [self.view bringSubviewToFront:HUD];
    [self requestNotesCategory:str_jsonCategory];
    
}
#pragma mark -  UITABLEVIEW DELEGATE AND DATASOURCE METHODS

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 42;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return arr_notesCategory.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"notesCell";
    UITableViewCell  *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellIdentifier];
    }

    MCANotesCatDHolder *notesDHolder = (MCANotesCatDHolder*)[arr_notesCategory objectAtIndex:indexPath.row];
    
    UILabel *lbl_catName = (UILabel *)[cell.contentView viewWithTag:2];
    lbl_catName.text = notesDHolder.str_notesCatName;
    
    UIImageView *img_cat=(UIImageView *)[cell.contentView viewWithTag:1];
    [img_cat removeFromSuperview];
    img_cat = nil;
    img_cat = [[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 26, 26)];
    img_cat.tag = 1;
    [cell.contentView addSubview:img_cat];
    
    [img_cat setImageWithUrl:[NSURL URLWithString:notesDHolder.str_notesCatImage]
                   andPlaceHoder:[UIImage imageNamed:@"back.png"]
                      andNoImage:[UIImage imageNamed:@"back.png"]];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
    return cell;
    
}

#pragma mark - API CALLING

-(void)requestNotesCategory:(NSString*)info{
    
    if ([MCAGlobalFunction isConnectedToInternet]) {
        
        [[MCARestIntraction sharedManager]requestForNotesCategory:info];
        
    }else{
     
        [HUD hide];
        arr_notesCategory = [[MCADBIntraction databaseInteractionManager]retrieveNotesCatList:nil];
        [tbl_notesCategory reloadData];
    }
}
#pragma mark - NSNOTIFICATION SELECTOR

-(void)notesCategorySuccess:(NSNotification*)notification{
    
    [HUD hide];
    arr_notesCategory = notification.object;
    
    [[MCADBIntraction databaseInteractionManager]insertNotesCatList:arr_notesCategory];

    [tbl_notesCategory reloadData];
}
-(void)notesCategoryFailed:(NSNotification*)notification{
    
    [HUD hide];
}

@end
