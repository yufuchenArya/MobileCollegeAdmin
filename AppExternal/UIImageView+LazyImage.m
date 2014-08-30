//
//  UIImageView+LazyImage.m
//  LazyLoading
//
//  Created by Shivam Dotsquares on 20/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIImageView+LazyImage.h"

@implementation UIImageView (LazyImage)

-(void)setImageWithUrl:(NSURL *)url andPlaceHoder:(UIImage*)placeHolderImage andNoImage:(UIImage*)noImage
{
    if (placeHolderImage==nil) {
        placeHolderImage=[UIImage imageNamed:@"loading"];
    }
    if (noImage==nil) {
        noImage=[UIImage imageNamed:@"noimage1"];
    }
    [self setImage:placeHolderImage];
    
    NSOperationQueue *queue = [NSOperationQueue new];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:url, @"url", noImage, @"noImage", nil];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] 
                                        initWithTarget:self
                                        selector:@selector(loadImage:) 
                                        object:dic];
    [queue addOperation:operation];
}

- (void)loadImage:(NSMutableDictionary*)dic {
    NSURL *imageUrl=[dic valueForKey:@"url"];
	UIImage *image = [self getCachedImage:imageUrl.relativeString];
    [self performSelectorOnMainThread:@selector(displayImage:) withObject:image waitUntilDone:NO];
}
- (void)displayImage:(UIImage *)image {
   
    self.alpha = 0.0f;
    [self setImage:image];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5f];
    self.alpha = 1.0f;
    [UIView commitAnimations];
    [self setNeedsDisplay];
    
}

-(UIImage *)getCachedImage: (NSString *)imageURLString
{
    UIImage *image;
    // Check for a cached version
    
    NSString *fileName = [imageURLString lastPathComponent];
    BOOL isFileExists = [MCAGlobalFunction isFileExists:fileName];
    if(!isFileExists)
    {
        // image = [UIImage imageWithContentsOfFile: uniquePath]; // this is the cached image
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:imageURLString] cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:-1];
        NSURLResponse *response;
        NSError *error;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        image = [[UIImage alloc] initWithData:data];
        if (image.size.width > 45 || image.size.height > 45)
        {
            float ratio;
            float newH = image.size.height;
            float newW = image.size.width;
            if (image.size.height>45) {
                ratio = image.size.width/image.size.height;
                newH = 45;
                newW = ratio*newH;
                if (newW>45) {
                    ratio = image.size.height/image.size.width;
                    newW = 45;
                    newH = ratio*newW;
                }
            }else if (image.size.width>45)
            {
                ratio = image.size.height/image.size.width;
                newW = 45;
                newH = ratio*newW;
                if (newH>45) {
                    ratio = image.size.width/image.size.height;
                    newH = 45;
                    newW = ratio*newH;
                }
            }
            CGSize itemSize = CGSizeMake(newW, newH);
            UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0f);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [image drawInRect:imageRect];
            UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            NSData * binaryImageData = UIImagePNGRepresentation(resizedImage);
            data = binaryImageData;
        }
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *path = [paths objectAtIndex:0];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@",path,fileName];
        [data writeToFile:filePath atomically:YES];
        data = nil;
        image = nil;
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",path,fileName];
    NSData *imgData = [NSData dataWithContentsOfFile:filePath];
    image = [UIImage imageWithData:imgData];
	if (image==nil)
    {
        image = [UIImage imageNamed:@"no-person.png"];
    }

    return image;
}
@end
