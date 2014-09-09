//
//  MCADropBoxNotesListViewController.h
//  MobileCollegeAdmin
//
//  Created by aditi on 08/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>

@interface MCADropBoxNotesListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,DBRestClientDelegate>{
    
    IBOutlet UITableView *tbl_notesfile;
    IBOutlet UIButton *btn_dropBox;
    NSArray *arr_notesfile;
    NSMutableArray *arr_selectedNotesfile;
    
    AryaHUD *HUD;
    int k;
    
}
@property (nonatomic, strong) DBRestClient *restClient;
@property (nonatomic,strong) NSString *str_noteFilePath;
-(IBAction)btnDropboxDidClicked:(id)sender;
@end
