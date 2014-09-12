//
//  MCADropboxNotesViewController.h
//  MobileCollegeAdmin
//
//  Created by aditi on 08/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>

@interface MCADropboxNotesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,DBRestClientDelegate>{
    
    IBOutlet UITableView *tbl_notesList;
    IBOutlet UIButton *btn_dropBox;
           NSArray *arr_notesList;
    NSMutableArray *arr_selectedNotesList;
    
    AryaHUD *HUD;
    NSMutableArray *arrtest;

    int k;
    
}
@property(nonatomic,retain)NSString *str_catName;
@property (nonatomic, strong) DBRestClient *restClient;
-(IBAction)btnDropboxDidClicked:(id)sender;
@end
