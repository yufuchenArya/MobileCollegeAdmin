//
//  MCADropBoxViewController.m
//  MobileCollegeAdmin
//
//  Created by aditi on 06/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MCADropBoxViewController.h"
#import <DropboxSDK/DropboxSDK.h>

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
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = [arr_catList objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.minimumScaleFactor = 0.7f;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // int selected = [indexPath row];
    
    if (cell.accessoryType == UITableViewCellAccessoryNone)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [arr_selectedCatList addObject:[arr_catList objectAtIndex:indexPath.row]];
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
         [arr_selectedCatList removeObject:[arr_catList objectAtIndex:indexPath.row]];
    }
    
//    [self readToFile:nil];
    
//    NSString *documentsDirectory = [MCALocalStoredFolder getSubRootDir];
//    NSString *filePath = [documentsDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@",@"About Me/Values/Values.txt"]];
//    
//    NSString *destDir = @"/Notes";
//    [self.restClient uploadFile:@"test" toPath:destDir withParentRev:nil fromPath:filePath];
    
}

-(IBAction)btnUploadToDropBox:(id)sender{
  
    [HUD showForTabBar];
    
    if(arr_selectedCatList.count > 0){
        
         [self readToFile:nil];
    }else{
        
        [MCAGlobalFunction showAlert:@"Select a note"];
    }
    
}
#pragma mark - DROPBOX_DELEGATE

- (void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath
              from:(NSString *)srcPath metadata:(DBMetadata *)metadata {
    
    NSLog(@"File uploaded successfully to path: %@", metadata.path);
    [HUD hide];
}

- (void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error {
    
    NSLog(@"File upload failed with error: %@", error);
}

#pragma mark - DOCUMENT_DIRECTORY_METHOD

-(void)readDirectory:(NSString *)fileName
{
    NSString *documentsDirectory = [MCALocalStoredFolder getSubRootDir];
    NSError * error;
    arr_catList =  [[NSFileManager defaultManager]
                        contentsOfDirectoryAtPath:documentsDirectory error:&error];
    [tbl_notesList reloadData];
    
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
            
            for (int k = 0; k< files.count; k++)
            {
                NSString *fileName = [filePath stringByAppendingString:[NSString stringWithFormat:@"/%@",[files objectAtIndex:k]]];
                NSData *retrieveData = [NSData dataWithContentsOfFile:fileName];
                
                NSString *str_Temp = [[NSString alloc]initWithData:retrieveData encoding:NSUTF8StringEncoding];
                if (str_Temp) {
                    
                    notesDHolder.str_notesDesc = str_Temp;
                    [HUD showForTabBar];
                    [self.restClient uploadFile:[files objectAtIndex:k] toPath:destDir withParentRev:nil fromPath:fileName];
                }
                
                UIImage *img_Temp = [UIImage imageWithData:retrieveData];
                if (img_Temp) {
                    
                    [notesDHolder.arr_notesImage addObject:img_Temp];
                    [HUD showForTabBar];
                    [self.restClient uploadFile:[files objectAtIndex:k] toPath:destDir withParentRev:nil fromPath:fileName];
                }
            }
        }
    }
}

@end
