//
//  MCADropBoxViewController.h
//  MobileCollegeAdmin
//
//  Created by aditi on 06/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>

@interface MCADropBoxViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,DBRestClientDelegate>{
    
    IBOutlet UITableView *tbl_notesList;
    NSArray *arr_catList;
    NSMutableArray *arr_selectedCatList;
    
    AryaHUD *HUD;
}
-(IBAction)btnUploadToDropBox:(id)sender;
@property (nonatomic, strong) DBRestClient *restClient;
@end
