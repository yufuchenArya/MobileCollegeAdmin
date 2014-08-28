//
//  UIImageView+LazyImage.h
//  LazyLoading
//
//  Created by Shivam Dotsquares on 20/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (LazyImage)<NSURLConnectionDelegate>

//@property (nonatomic, strong) UIActivityIndicatorView *indicaterView;
//@property (nonatomic, strong) NSMutableData *activeDownload;
//@property (nonatomic, strong) NSURLConnection *imageConnection;

-(void)setImageWithUrl:(NSURL *)url andPlaceHoder:(UIImage*)placeHolderImage andNoImage:(UIImage*)noImage;
- (UIImage *)getCachedImage: (NSString *)imageURLString;
- (void)displayImage:(UIImage *)image;
- (void)loadImage:(NSURL*)url;
@end
