//
//  MCADropBoxNotesListViewController.m
//  MobileCollegeAdmin
//
//  Created by aditi on 08/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MCADropBoxNotesListViewController.h"

@interface MCADropBoxNotesListViewController ()

@end

@implementation MCADropBoxNotesListViewController
@synthesize str_noteFilePath;

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
    
    arr_selectedNotesfile = [NSMutableArray new];
    
    [self readDirectory:nil];
    self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    self.restClient.delegate = self;
    
    if (![[DBSession sharedSession] isLinked]) {
        
        [btn_dropBox setTitle:@"Login To Dropbox" forState:UIControlStateNormal];
    }else{
        [btn_dropBox setTitle:@"Export" forState:UIControlStateNormal];
    }
    
    btn_dropBox.layer.cornerRadius = 12.0f;
    tbl_notesfile.tableFooterView = [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IB_ACTION

-(void)btnSelectDidClicked:(id)sender{
    
    MCACustomButton *btn_temp = (MCACustomButton*)sender;
    
    // NSIndexPath *indexPath = [NSIndexPath indexPathWithIndex:btn_temp.index];
    if (btn_temp.tag == 1) {
        
        [btn_temp setBackgroundImage:[UIImage imageNamed:@"blueCheckmark.png"]
                            forState:UIControlStateNormal];
        [arr_selectedNotesfile addObject:[arr_notesfile objectAtIndex:btn_temp.index]];
        btn_temp.tag = 2;
        
    }else{
        
        [btn_temp setBackgroundImage:[UIImage imageNamed:@""]
                            forState:UIControlStateNormal];
        [arr_selectedNotesfile removeObject:[arr_notesfile objectAtIndex:btn_temp.index]];
        btn_temp.tag = 1;
        
    }
}
-(IBAction)btnDropboxDidClicked:(id)sender{
    
    if (![[DBSession sharedSession] isLinked]) {
        
        [[DBSession sharedSession] linkFromController:self];
        
    }else
    {
        [HUD showForTabBar];
        if(arr_selectedNotesfile.count > 0){
            
            [self readToFile:nil];
            
        }else{
            
            [HUD hide];
            [MCAGlobalFunction showAlert:@"Select a file"];
        }
    }
}
#pragma mark -  UITABLEVIEW DELEGATE AND DATASOURCE METHODS

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 42;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return arr_notesfile.count;
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
    
    UILabel *lbl_notes = (UILabel*)[cell.contentView viewWithTag:2];
    lbl_notes.text = [arr_notesfile objectAtIndex:indexPath.row];
    
    MCACustomButton *btn_select = (MCACustomButton*)[cell.contentView viewWithTag:1];
    btn_select.layer.cornerRadius = 2.0f;
    btn_select.layer.borderWidth = 0.5f;
    [btn_select setBackgroundImage:[UIImage imageNamed:@""]
                          forState:UIControlStateNormal];
    [btn_select addTarget:self
                   action:@selector(btnSelectDidClicked:)
         forControlEvents:UIControlEventTouchUpInside];
    btn_select.index = indexPath.row;
    btn_select.tag = 1;
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    //    cell.textLabel.text = [arr_catList objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.minimumScaleFactor = 0.7f;
    return cell;
    
}
#pragma mark - DROPBOX_DELEGATE

- (void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath from:(NSString *)srcPath metadata:(DBMetadata *)metadata {
    
    NSLog(@"File uploaded successfully to path: %@", metadata.path);
   
    [HUD hide];
    [tbl_notesfile reloadData];
    
}

- (void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error {
    
    NSLog(@"File upload failed with error: %@", error);
}

#pragma mark - DOCUMENT_DIRECTORY_METHOD

-(void)readDirectory:(NSString *)fileName
{
    NSString *documentsDirectory = [MCALocalStoredFolder getSubRootDir];
    NSString *subDocDirectory = [documentsDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@",str_noteFilePath]];
    NSError * error;
    arr_notesfile =  [[NSFileManager defaultManager]
                      contentsOfDirectoryAtPath:subDocDirectory error:&error];
    [tbl_notesfile reloadData];
    
}
-(void)readToFile:(id)sender{
    
    for (int i = 0 ; i <arr_selectedNotesfile.count; i++)
    {
        NSError * error;
        NSString *documentsDirectory = [MCALocalStoredFolder getSubRootDir];
        NSString *filePath = [documentsDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@",str_noteFilePath]];
        NSArray *files=  [[NSFileManager defaultManager]
                          contentsOfDirectoryAtPath:filePath error:&error];
        
        NSString *destDir = [NSString stringWithFormat:@"/%@",@"Notes"];
      
        NSString *fileName = [filePath stringByAppendingString:[NSString stringWithFormat:@"/%@",[arr_selectedNotesfile objectAtIndex:i]]];
//        NSData *retrieveData = [NSData dataWithContentsOfFile:fileName];
//        
//        NSString *str_Temp = [[NSString alloc]initWithData:retrieveData encoding:NSUTF8StringEncoding];
//        if (str_Temp) {
//            [self.restClient uploadFile:[files objectAtIndex:i] toPath:destDir withParentRev:nil fromPath:fileName];
//        }
//        
//        UIImage *img_Temp = [UIImage imageWithData:retrieveData];
//        if (img_Temp) {
        
           [self.restClient uploadFile:[files objectAtIndex:i] toPath:destDir withParentRev:nil fromPath:fileName];
       
//          }
     }
}

@end
