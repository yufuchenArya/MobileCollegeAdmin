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
    
    IBOutlet UITableView *tbl_catList;
    IBOutlet UIButton *btn_dropBox;
    NSArray *arr_catList;
    NSMutableArray *arr_selectedCatList;
    
    AryaHUD *HUD;
}
@property (nonatomic, strong) DBRestClient *restClient;
@end
