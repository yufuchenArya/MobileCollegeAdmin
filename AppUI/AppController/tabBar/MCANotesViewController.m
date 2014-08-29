//
//  MCANotesViewController.m
//  MobileCollegeAdmin
//
//  Created by aditi on 28/08/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MCANotesViewController.h"
#import "MCANotesDetailViewController.h"

@interface MCANotesViewController ()

@end

@implementation MCANotesViewController
@synthesize notesCatDHolder;
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
    
    arr_notes = [NSMutableArray new];
    tbl_notes.frame = CGRectMake(0, 0, 320, 0);
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notesFailed:) name:NOTIFICATION_NOTES_FAILED object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notesSuccess:) name:NOTIFICATION_NOTES_SUCCESS object:nil];
    
    self.navigationItem.title = notesCatDHolder.str_notesCatName;
    
    UIImage* img_add = [UIImage imageNamed:@"add.png"];
    CGRect img_addFrame = CGRectMake(0, 0, img_add.size.width, img_add.size.height);
    UIButton *btn_add = [[UIButton alloc] initWithFrame:img_addFrame];
    [btn_add setBackgroundImage:img_add forState:UIControlStateNormal];
    [btn_add setShowsTouchWhenHighlighted:YES];
    
    
    UIImage* img_refresh = [UIImage imageNamed:@"refresh.png"];
    CGRect img_gradeFrame = CGRectMake(0, 0, img_refresh.size.width, img_refresh.size.height);
    UIButton *btn_refresh = [[UIButton alloc] initWithFrame:img_gradeFrame];
    [btn_refresh setBackgroundImage:img_refresh forState:UIControlStateNormal];
    [btn_refresh setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *btnBar_add =[[UIBarButtonItem alloc] initWithCustomView:btn_add];
    UIBarButtonItem *btnBar_refresh =[[UIBarButtonItem alloc] initWithCustomView:btn_refresh];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:btnBar_add, btnBar_refresh, nil]];

    
    [self getNotes:notesCatDHolder.str_notesCatId];
    [MCALocalStoredFolder createSubRootDir:notesCatDHolder.str_notesCatName];
 
}
-(void)getNotes:(id)sender{
        
    NSMutableDictionary * info = [NSMutableDictionary new];
    
    [info setValue:@"get_notes" forKey:@"cmd"];
    [info setValue:@"en_us" forKey:@"language_code"];
    [info setValue:sender forKey:@"notes_cat_id"];
    
    NSString *str_jsonNotes = [NSString getJsonObject:info];
    [HUD showForTabBar];
    [self.view bringSubviewToFront:HUD];
    [self requestNotes:str_jsonNotes];
    
    
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
    
    return arr_notes.count;
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
    
    MCANotesDHolder *notesDHolder = (MCANotesDHolder*)[arr_notes objectAtIndex:indexPath.row];
    cell.textLabel.text = notesDHolder.str_notesName;
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.minimumScaleFactor = 0.7f;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MCANotesDHolder *notesDHolder = (MCANotesDHolder*)[arr_notes objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"segue_notesDetail" sender:notesDHolder];
    
}
#pragma mark - API CALLING

-(void)requestNotes:(NSString*)info{
        
    if ([MCAGlobalFunction isConnectedToInternet]) {
        
        [[MCARestIntraction sharedManager]requestForNotes:info];
        
    }else{
        
        [HUD hide];
    }

}
#pragma mark - NSNOTIFICATION SELECTOR

-(void)notesSuccess:(NSNotification*)notification{
    
    [HUD hide];
    arr_notes = notification.object;
    tbl_notes.frame = CGRectMake(0, 0, 320, 42*arr_notes.count);
    [tbl_notes reloadData];
    
}
-(void)notesFailed:(NSNotification*)notification{
    
    [HUD hide];
}
#pragma mark - OTHER_METHOD

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"segue_notesDetail"]) {
        
        MCANotesDetailViewController *noteDetailViewCtr = (MCANotesDetailViewController*)[segue destinationViewController];
        noteDetailViewCtr.notesDHolder = (MCANotesDHolder*)sender;
    }
}
@end
