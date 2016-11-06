//
//  ViewController.m
//  InstaImageLoading
//
//  Created by Ugur Cetinkaya on 01/11/16.
//  Copyright © 2016 ceuur. All rights reserved.
//

#import "ViewController.h"

#import "UIImage+BlurEffect.h"

#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <M13ProgressSuite/M13ProgressViewBorderedBar.h>
#import <ChameleonFramework/Chameleon.h>

static NSString *const kLowResImageURL = @"http://lorempixel.com/15/15/city/4/uur/";
static NSString *const kHighResImageURL = @"http://lorempixel.com/1920/1920/city/4/uur/";

@interface ViewController ()

@property (nonatomic, strong) UIImageView *lowResImage;
@property (nonatomic, strong) UIImageView *highResImage;
@property (nonatomic, strong) M13ProgressViewBorderedBar *progressBar;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"InstaImageLoading";
    
    self.view.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleLeftToRight withFrame:self.view.frame andColors:[NSArray arrayWithObjects:[UIColor colorWithRed:0.98 green:0.75 blue:0.36 alpha:1.0], [UIColor colorWithRed:0.86 green:0.28 blue:0.40 alpha:1.0], [UIColor colorWithRed:0.35 green:0.42 blue:0.71 alpha:1.0], nil]];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.view.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:blurEffectView];
    
    _lowResImage = [UIImageView new];
    [_lowResImage setContentMode:UIViewContentModeScaleAspectFill];
    [_lowResImage setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:_lowResImage];
    
    _highResImage = [UIImageView new];
    [_highResImage setContentMode:UIViewContentModeScaleAspectFill];
    [self.view addSubview:_highResImage];
    [_highResImage setHidden:YES];
    
    _progressBar = [M13ProgressViewBorderedBar new];
    _progressBar.progressDirection = M13ProgressViewBorderedBarProgressDirectionLeftToRight;
    _progressBar.cornerType = M13ProgressViewBorderedBarCornerTypeCircle;
    [_progressBar setPrimaryColor:[UIColor colorWithRed:0.96 green:0.26 blue:0.21 alpha:1.0]];
    [_progressBar setSecondaryColor:[UIColor colorWithRed:0.96 green:0.26 blue:0.21 alpha:1.0]];
    [self.view addSubview:_progressBar];
    [_progressBar setIndeterminate:YES];
    
    [self.view setNeedsUpdateConstraints];
    
    [self setImages];
}

- (void)setImages {
    __weak UIImageView *weakLowResImage = _lowResImage;
    __weak UIImageView *weakHighResImage = _highResImage;
    __weak M13ProgressViewBorderedBar *weakProgressBar = _progressBar;
    
    [_lowResImage sd_setImageWithURL:[NSURL URLWithString:kLowResImageURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [weakLowResImage setImage:[UIImage blurEffect:image]];
    }];
    
    [_highResImage sd_setImageWithURL:[NSURL URLWithString:kHighResImageURL] placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [weakLowResImage setHidden:YES];
        [weakProgressBar setHidden:YES];
        [weakHighResImage setHidden:NO];
        [weakHighResImage setImage:image];
    }];
}

- (void)updateViewConstraints {
    [_lowResImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.height.width.equalTo(@300);
    }];
    [_progressBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_lowResImage);
        make.width.equalTo(@80);
        make.height.equalTo(@15);
    }];
    [_highResImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.height.width.equalTo(@300);
    }];
    
    [super updateViewConstraints];
}

@end
