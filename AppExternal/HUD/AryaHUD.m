//
//  ESMHUD.m
//  ESafeMove
//
//  Created by vishnu on 12/12/13.
//  Copyright (c) 2013 Aryavrat. All rights reserved.
//

#define FONT_SIZE 11
#define FONT_NAME @"Arial"

#import "AryaHUD.h"
@implementation AryaHUD
@synthesize isSuperViewIntractionEnabled;
- (id)init
{
    
    aIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    lblHUDText = [[UILabel alloc]init];
    
    self = [super initWithFrame:CGRectMake(0,0, 60, 60)];
    if (self) {
        
        [self addSubview:aIndicatorView];
        [self addSubview:lblHUDText];
        lblHUDText.text = @"";
        lblHUDText.frame = CGRectMake(12, 44, 50, 13);
        lblHUDText.textColor = [UIColor whiteColor];
        lblHUDText.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE];
        aIndicatorView.frame = self.bounds;
        aIndicatorView.center = self.center;
        self.backgroundColor = [UIColor colorWithRed:32.0/255.0 green:36.0/255.0 blue:48.0/255.0 alpha:1];
     
        aIndicatorView.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin |    UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin);
        self.layer.cornerRadius = 8;
        self.layer.opacity = 0.9f;
        self.hidden = YES;
    }
    
    return self;
}

-(void)setHUDText:(NSString*)HUDText{
    
    lblHUDText.text = HUDText;
    UIFont *font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    CGFloat width = [[[NSAttributedString alloc] initWithString:HUDText attributes:attributes] size].width;
    self.frame = CGRectMake(0, 0, width+24, 60);
    lblHUDText.frame = CGRectMake(12, 44, width, 12);
    lblHUDText.textAlignment = NSTextAlignmentCenter ;
    
    [self resetFrame];
}

-(void)hide{
    
    [self.superview setUserInteractionEnabled:YES];
    [aIndicatorView stopAnimating];
    self.hidden = YES;
}
-(void)show{
    
    self.center = self.superview.center;
    if (isSuperViewIntractionEnabled) {
        [self.superview setUserInteractionEnabled:YES];
    }else{
        [self.superview setUserInteractionEnabled:NO];
    }
    
    [aIndicatorView startAnimating];
    self.hidden = NO;
    }
-(void)showForTabBar{
    
    if (IS_IPHONE_5) {
         self.center = CGPointMake(160, 222);
    }else{
         self.center = CGPointMake(160, 192);
    }
    
   
    if (isSuperViewIntractionEnabled) {
        [self.superview setUserInteractionEnabled:YES];
    }else{
        [self.superview setUserInteractionEnabled:NO];
    }
    
    [aIndicatorView startAnimating];
    self.hidden = NO;
}
-(void)resetFrame{
    
    aIndicatorView.center = CGPointMake(self.center.x, self.center.y);
    self.center = self.superview.center;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
