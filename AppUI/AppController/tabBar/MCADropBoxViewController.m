//
//  MCADropBoxViewController.m
//  MobileCollegeAdmin
//
//  Created by aditi on 06/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MCADropBoxViewController.h"
#import "MCADropboxNotesViewController.h"

@interface MCADropBoxViewController ()

@end

@implementation MCADropBoxViewController

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
    
    arr_selectedCatList = [NSMutableArray new];
    
    [self readDirectory:nil];
    self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    self.restClient.delegate = self;
    
    if (![[DBSession sharedSession] isLinked]) {
        
          [btn_dropBox setTitle:@"Login To Dropbox" forState:UIControlStateNormal];
    }else{
          [btn_dropBox setTitle:@"Export" forState:UIControlStateNormal];
    }
    btn_dropBox.layer.cornerRadius = 12.0f;
    tbl_catList.tableFooterView = [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IB_ACTION

-(IBAction)btnLinkToDropboxDidClicked:(id)sender{
    
    if (![[DBSession sharedSession] isLinked]) {
        
        [[DBSession sharedSession] linkFromController:self];
    }else
    {
        [HUD showForTabBar];
        if(arr_selectedCatList.count > 0){
            
           [self readToFile:nil];
            
        }else{
            
            [HUD hide];
            [MCAGlobalFunction showAlert:@"Select a file"];
        }
    }
}
//-(IBAction)btnUploadToDropBox:(id)sender{
//    
//    [HUD showForTabBar];
//    if(arr_selectedCatList.count > 0){
//        
//        [self readToFile:nil];
//    }else{
//        
//        [HUD hide];
//        [MCAGlobalFunction showAlert:@"Select a note"];
//    }
//}
-(void)btnSelectDidClicked:(id)sender{
    
    MCACustomButton *btn_temp = (MCACustomButton*)sender;
    
   // NSIndexPath *indexPath = [NSIndexPath indexPathWithIndex:btn_temp.index];
    if (btn_temp.tag == 1) {
        
        [btn_temp setBackgroundImage:[UIImage imageNamed:@"blueCheckmark.png"]
                                forState:UIControlStateNormal];
        [arr_selectedCatList addObject:[arr_catList objectAtIndex:btn_temp.index]];
         btn_temp.tag = 2;

    }else{
        
        [btn_temp setBackgroundImage:[UIImage imageNamed:@""]
                            forState:UIControlStateNormal];
        [arr_selectedCatList removeObject:[arr_catList objectAtIndex:btn_temp.index]];
        btn_temp.tag = 1;

    }
}
#pragma mark -  UITABLEVIEW DELEGATE AND DATASOURCE METHODS

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 42;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return arr_catList.count;
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
    
    UILabel *lbl_cat = (UILabel*)[cell.contentView viewWithTag:2];
    lbl_cat.text = [arr_catList objectAtIndex:indexPath.row];
    
    MCACustomButton *btn_select = (MCACustomButton*)[cell.contentView viewWithTag:1];
    btn_select.layer.cornerRadius = 2.0f;
    btn_select.layer.borderWidth = 0.5f;
    [btn_select addTarget:self
                   action:@selector(btnSelectDidClicked:)
         forControlEvents:UIControlEventTouchUpInside];
    [btn_select setBackgroundImage:[UIImage imageNamed:@""]
                        forState:UIControlStateNormal];

    btn_select.index = indexPath.row;
    btn_select.tag = 1;
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.minimumScaleFactor = 0.7f;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    // int selected = [indexPath row];
//    
//    if (cell.accessoryType == UITableViewCellAccessoryNone)
//    {
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//        [arr_selectedCatList addObject:[arr_catList objectAtIndex:indexPath.row]];
//    }
//    else
//    {
//        cell.accessoryType = UITableViewCellAccessoryNone;
//         [arr_selectedCatList removeObject:[arr_catList objectAtIndex:indexPath.row]];
//    }
    
//    [self readToFile:nil];
    
//    NSString *documentsDirectory = [MCALocalStoredFolder getSubRootDir];
//    NSString *filePath = [documentsDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@",@"About Me/Values/Values.txt"]];
//    
//    NSString *destDir = @"/Notes";
//    [self.restClient uploadFile:@"test" toPath:destDir withParentRev:nil fromPath:filePath];
    
    [self performSegueWithIdentifier:@"segue_selectNote" sender:[arr_catList objectAtIndex:indexPath.row]];
    
}


#pragma mark - DROPBOX_DELEGATE

- (void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath from:(NSString *)srcPath metadata:(DBMetadata *)metadata {
    
    NSLog(@"File uploaded successfully to path: %@", metadata.path);
    [HUD hide];
    [tbl_catList reloadData];
}

- (void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error {
    
    NSLog(@"File upload failed with error: %@", error);
    [HUD hide];
}

#pragma mark - DOCUMENT_DIRECTORY_METHOD

-(void)readDirectory:(NSString *)fileName
{
    NSString *documentsDirectory = [MCALocalStoredFolder getSubRootDir];
    NSError * error;
    arr_catList =  [[NSFileManager defaultManager]
                        contentsOfDirectoryAtPath:documentsDirectory error:&error];
    [tbl_catList reloadData];
    
}
-(void)readToFile:(id)sender{
    
    for (int i = 0 ; i <arr_selectedCatList.count; i++)
    {
        NSError * error;
        NSString *documentsDirectory = [MCALocalStoredFolder getSubRootDir];
        NSString *subDocDir = [documentsDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@",[arr_selectedCatList objectAtIndex:i]]];
        NSArray *arr_notesList =  [[NSFileManager defaultManager]
                             contentsOfDirectoryAtPath:subDocDir error:&error];
        
        for (int j = 0; j < arr_notesList.count; j++)
        {
            NSString *filePath = [subDocDir stringByAppendingString:[NSString stringWithFormat:@"/%@",[arr_notesList objectAtIndex:j]]];
            
            NSArray* files = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:filePath error:&error];
            
            MCANotesDHolder *notesDHolder = [MCANotesDHolder new];
            notesDHolder.arr_notesImage = [NSMutableArray new];
            
            NSString *destDir = [NSString stringWithFormat:@"/%@/%@/%@",@"Notes",[arr_selectedCatList objectAtIndex:i],[arr_notesList objectAtIndex:j]];
            [HUD showForTabBar];
          
            for (int k = 0; k< files.count; k++)
            {
                NSString *fileName = [filePath stringByAppendingString:[NSString stringWithFormat:@"/%@",[files objectAtIndex:k]]];
//                NSData *retrieveData = [NSData dataWithContentsOfFile:fileName];
//
//                NSString *str_Temp = [[NSString alloc]initWithData:retrieveData encoding:NSUTF8StringEncoding];
//                if (str_Temp) {
//                    notesDHolder.str_notesDesc = str_Temp;
//                    
//                }
//                
//                UIImage *img_Temp = [UIImage imageWithData:retrieveData];
//                if (img_Temp) {
//                    [notesDHolder.arr_notesImage addObject:img_Temp];
//                }
//                
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                   
//                    [self.restClient uploadFile:[files objectAtIndex:k] toPath:destDir withParentRev:nil fromPath:fileName];
//                    dispatch_async(dispatch_get_main_queue(), ^(void) {
//                        [self processComplete];
//                    });
//                });
                
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    
                    [self.restClient uploadFile:[files objectAtIndex:k] toPath:destDir withParentRev:nil fromPath:fileName];
                });
            }
        }
    }
}
-(void)processComplete{
    
    
    
}
#pragma mark - OTHER_METHOD
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"segue_selectNote"]) {
        
        MCADropboxNotesViewController *noteViewCtr = (MCADropboxNotesViewController*)[segue destinationViewController];
        noteViewCtr.str_catName = sender;
        
    }
}
@end
