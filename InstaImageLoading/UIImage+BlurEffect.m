//
//  UIImage+BlurEffect.m
//  InstaImageLoading
//
//  Created by Ugur Cetinkaya on 01/11/16.
//  Copyright © 2016 ceuur. All rights reserved.
//

#import "UIImage+BlurEffect.h"

@implementation UIImage (BlurEffect)

+ (UIImage *)blurEffect:(UIImage *)sourceImage {
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:sourceImage.CGImage];
    
    //setting up Gaussian Blur (we could use one of many filters offered by Core Image)
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:2.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    //CIGaussianBlur has a tendency to shrink the image a little, this ensures it matches up exactly to the bounds of our original image
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    return [UIImage imageWithCGImage:cgImage];
}

@end
