//
//  MCANotesViewController.h
//  MobileCollegeAdmin
//
//  Created by aditi on 28/08/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCANotesViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    
    IBOutlet UITableView *tbl_notes;
    
    NSMutableArray *arr_notes;
    
    AryaHUD *HUD;
}
@property(nonatomic,strong)MCANotesCatDHolder *notesCatDHolder;

@end
