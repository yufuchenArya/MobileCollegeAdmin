//
//  MCANotesDetailViewController.h
//  MobileCollegeAdmin
//
//  Created by aditi on 29/08/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCAAddEditNotesViewController.h"

@interface MCANotesDetailViewController : UIViewController<UIScrollViewDelegate,AddEditNoteDelegate>{
    
   IBOutlet UILabel *lbl_noteName;
   IBOutlet UITextView *tv_noteDesc;
   IBOutlet UIScrollView *scrollV_noteImages;
            UIScrollView *scrollV_images;
  
   NSMutableArray *arr_scrollImages;
//   NSMutableArray *arr_dirImages;
  
   NSInteger preContentOffSet;
   AryaHUD *HUD;
    
}
@property(nonatomic,strong)MCANotesDHolder *notesDHolder;
@end
