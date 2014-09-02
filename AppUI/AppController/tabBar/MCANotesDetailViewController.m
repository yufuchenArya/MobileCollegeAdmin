//
//  MCANotesDetailViewController.m
//  MobileCollegeAdmin
//
//  Created by aditi on 29/08/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MCANotesDetailViewController.h"

@interface MCANotesDetailViewController ()

@end

@implementation MCANotesDetailViewController
@synthesize notesDHolder;
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
    
    arr_scrollImages = [NSMutableArray new];
    
    lbl_noteName.text = notesDHolder.str_notesName;
    tv_noteDesc.text = notesDHolder.str_notesDesc;
    tv_noteDesc.layer.borderWidth = 0.5f;
    tv_noteDesc.layer.cornerRadius = 3.0f;
    tv_noteDesc.editable = NO;
        
    [self getImageScrollView:nil];
    
    UIImage* img_delete = [UIImage imageNamed:@"delete.png"];
    CGRect img_deleteFrame = CGRectMake(0, 0, img_delete.size.width, img_delete.size.height);
    UIButton *btn_delete = [[UIButton alloc] initWithFrame:img_deleteFrame];
    [btn_delete setBackgroundImage:img_delete forState:UIControlStateNormal];
//    [btn_delete addTarget:self
//                   action:@selector(btnBar_deleteDidClicked:)
//         forControlEvents:UIControlEventTouchUpInside];
    [btn_delete setShowsTouchWhenHighlighted:YES];
    
    UIImage* img_edit = [UIImage imageNamed:@"edit.png"];
    CGRect img_editFrame = CGRectMake(0, 0, img_edit.size.width, img_edit.size.height);
    UIButton *btn_edit = [[UIButton alloc] initWithFrame:img_editFrame];
    [btn_edit setBackgroundImage:img_edit forState:UIControlStateNormal];
//    [btn_edit addTarget:self
//                 action:@selector(btnBar_editDidClicked:)
//       forControlEvents:UIControlEventTouchUpInside];
    [btn_edit setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *btnBar_delete =[[UIBarButtonItem alloc] initWithCustomView:btn_delete];
    UIBarButtonItem *btnBar_edit =[[UIBarButtonItem alloc] initWithCustomView:btn_edit];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:btnBar_delete,btnBar_edit, nil]];
    
    [MCALocalStoredFolder createSubCategoryDir:notesDHolder.str_notesName];
    
}
-(void)getImageScrollView:(id)sender{
    
    [HUD showForTabBar];
    scrollV_noteImages.delegate = self;
    scrollV_noteImages.scrollEnabled = YES;
    int scrollheight = 60;
    scrollV_noteImages.contentSize = CGSizeMake(300,scrollheight);
    
    int yOffset = 0;
    int xOffset = 0;
    
    for(int index=0; index < [notesDHolder.arr_notesImage count]; index++)
    {
        UIImageView *img = [[UIImageView alloc] init];
        img.bounds = CGRectMake(10, 10, 68, 68);
        img.frame = CGRectMake(xOffset, yOffset+5, 68, 68);
        
        [img setImageWithUrl:[NSURL URLWithString:[notesDHolder.arr_notesImage objectAtIndex:index]]
               andPlaceHoder:[UIImage imageNamed:PLACEHOLDER_IMAGE]
                  andNoImage:[UIImage imageNamed:NO_IMAGE]];
            
        [arr_scrollImages insertObject:img atIndex:index];
        scrollV_noteImages.contentSize = CGSizeMake(300 ,110+yOffset);
        [scrollV_noteImages addSubview:[arr_scrollImages objectAtIndex:index]];
        
        xOffset += 78;
        if (xOffset>300)
        {
            xOffset = 0;
            yOffset += 78;
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^ {
       
       [self writeToTextFile];
        
    });
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)writeToTextFile{
 
    //get the documents directory:
    NSString *documentsDirectory = [MCALocalStoredFolder getSubCategoryDir];
    
    //make a file name to write the data to using the documents directory:
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",
                                                                             notesDHolder.str_notesName]];
    //create content - four lines of text
    NSString *content = notesDHolder.str_notesDesc;
    
    for (int i = 0; i < notesDHolder.arr_notesImage.count; i++) {
        
        UIImageView *img =[UIImageView new];
        
        img.image = [UIImage imageWithData:
                          [NSData dataWithContentsOfURL:
                             [NSURL URLWithString: [notesDHolder.arr_notesImage objectAtIndex:i]]]];
        
       NSString *imageName = [[notesDHolder.arr_notesImage objectAtIndex:i] lastPathComponent];
       NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:imageName];
       NSData *imageData = UIImagePNGRepresentation(img.image);
        
       [imageData writeToFile:imagePath
                  atomically:NO];
    }

    //save content to the documents directory
    [content writeToFile:filePath
              atomically:NO
                encoding:NSStringEncodingConversionAllowLossy
                   error:nil];
    [HUD hide];
}
@end
