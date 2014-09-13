//
//  MCADetailTblCell.h
//  MobileCollegeAdmin
//
//  Created by rashmi on 9/12/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCADetailTblCell : UITableViewCell
@property(nonatomic,retain) UILabel *url;

-(void)setIntroductionText:(NSString*)text;
-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier; 
@end
