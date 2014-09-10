//
//  MCATutorialViewController.h
//  ESafeMove
//
//  Created by vishnu on 16/12/13.
//  Copyright (c) 2013 Aryavrat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCATutorialViewController : UIViewController<UIScrollViewDelegate>{

    IBOutlet UIScrollView *scrollView;
    IBOutlet UIPageControl *pageControl;
    IBOutlet UIButton *btnPrevious;
    IBOutlet UIButton *btnNext;
    NSInteger preContentOffSet;
}
-(IBAction)btnPrevious:(id)sender;
-(IBAction)btnNext:(id)sender;
@end
