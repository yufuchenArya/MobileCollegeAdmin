//
//  MCANotesDetailViewController.h
//  MobileCollegeAdmin
//
//  Created by aditi on 29/08/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCANotesDetailViewController : UIViewController<UIScrollViewDelegate>{
    
   IBOutlet UILabel *lbl_noteName;
   IBOutlet UITextView *tv_noteDesc;
   IBOutlet UIScrollView *scrollV_noteImages;
  
    NSMutableArray *arr_scrollImages;
  

}
@property(nonatomic,strong)MCANotesDHolder *notesDHolder;
@end
