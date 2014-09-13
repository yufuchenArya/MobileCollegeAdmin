//
//  MCADetailTblCell.m
//  MobileCollegeAdmin
//
//  Created by rashmi on 9/12/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MCADetailTblCell.h"

@implementation MCADetailTblCell
-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}

-(void)initLayuot{
    _url = [[UILabel alloc] initWithFrame:CGRectMake(5, 78, 250, 40)];
    [self addSubview:_url];
}


-(void)setIntroductionText:(NSString*)text{
    CGRect frame = [self frame];
    self.url.text = text;
    self.url.numberOfLines = 10;
    CGSize size = CGSizeMake(300, 1000);
    CGSize labelSize = [self.url.text sizeWithFont:self.url.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
    self.url.frame = CGRectMake(self.url.frame.origin.x, self.url.frame.origin.y, labelSize.width, labelSize.height);
    frame.size.height = labelSize.height+100;
    
    self.frame = frame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
}

- (void)awakeFromNib
{
    // Initialization code
}


@end
