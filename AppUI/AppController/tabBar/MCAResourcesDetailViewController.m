//
//  MCAResourcesDetailViewController.m
//  MobileCollegeAdmin
//
//  Created by rashmi on 9/12/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MCAResourcesDetailViewController.h"

@interface MCAResourcesDetailViewController ()

@end

@implementation MCAResourcesDetailViewController

@synthesize reDHolder, detailCell;

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
    arr_url = [NSMutableArray new];
    
    self.navigationItem.title = reDHolder.str_book_name;
    
    NSArray * arr_url_old = [reDHolder.str_url componentsSeparatedByString:@"]["];
    for(NSString* strl in arr_url_old){
        NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"\\[]"];
        NSString *str = [[strl componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""];
            [arr_url addObject:str];

    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangePreferredContentSize:)
                                                 name:UIContentSizeCategoryDidChangeNotification object:nil];
    tbl_url.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    // Do any additional setup after loading the view.
}

- (void)didChangePreferredContentSize:(NSNotification *)notification
{
    [tbl_url reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arr_url.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self configureCell:cell forRowAtIndexPath:indexPath];
    static NSString *cellIdentifier = @"urlCell";
    UITableViewCell  *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellIdentifier];
    }
    NSString* str = [arr_url objectAtIndex:indexPath.row];
    NSLog(@"%@", str);
    UILabel *lbl_catName = (UILabel *)[cell.contentView viewWithTag:2];
    lbl_catName.text = str;
    lbl_catName.numberOfLines = 0;
    lbl_catName.lineBreakMode = NSLineBreakByWordWrapping;
    [lbl_catName sizeToFit];
    
    tbl_url.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString* str = [arr_url objectAtIndex:indexPath.row];
    
    CGSize constraint = {236, 20000};
    
    CGSize size = [str sizeWithFont: [UIFont fontWithName:@"Verdana" size:13] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat height = MAX(size.height, 44.0f);
    
    return height+10;
}


@end
