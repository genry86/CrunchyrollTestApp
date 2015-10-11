//
//  CCHImageViewController.m
//  Crunchyroll
//
//  Created by Genry on 6/1/14.
//  Copyright (c) 2014 Genry. All rights reserved.
//

#import "CCHImageViewController.h"
#import "FTWCache.h"
#import "CCHGalleryItem.h"
#import "GlobalConstants.h"
#import "GlobalFunctions.h"

@interface CCHImageViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) BOOL topMenuVisible;
@property (nonatomic, strong) CCHGalleryItem *galleryItem;
@end

@implementation CCHImageViewController

- (void)centerScrollViewContents {
    CGSize boundsSize = self.view.frame.size;
    CGRect contentsFrame = self.imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height)
    {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height - (kCCHFullTopBarHeight + (!_topMenuVisible ? kCCHFullTopBarHeight : 0))) / 2.0f;
    }
    else
    {
        contentsFrame.origin.y = 0.0f;
    }
    self.imageView.frame = contentsFrame;
}


- (void)scrollViewSingleTapped:(UITapGestureRecognizer*)recognizer
{
    self.topMenuVisible = !self.topMenuVisible;
    self.navigationController.navigationBar.hidden = !_topMenuVisible;
    [self centerScrollViewContents];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [ProgressHUD show:@"Please wait..."];
    
    self.topMenuVisible = YES;
    
    [self setNeedsStatusBarAppearanceUpdate];
    self.view.backgroundColor = [UIColor whiteColor];
    [ProgressHUD show:@"Please wait..."];
    self.navigationController.navigationBar.translucent = YES;
    
    self.imageView = [[UIImageView alloc] init];
    [self.scrollView addSubview:self.imageView];
    
    self.singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewSingleTapped:)];
    self.singleTapRecognizer.numberOfTapsRequired = 1;
    self.singleTapRecognizer.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:self.singleTapRecognizer];
    self.singleTapRecognizer.enabled = NO;
    
    UIBarButtonItem *infoMenuBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Info"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self action:@selector(menuInfo:)];
    self.navigationItem.rightBarButtonItem = infoMenuBarButtonItem;
}

- (void)menuInfo:(id)sender
{
    ShowMessageWithTitle(@"Caption", self.galleryItem.title);
}

- (void)setupImage:(CCHGalleryItem*)galleryItem
{
    self.scrollView.zoomScale = 1; 
    
    self.galleryItem = galleryItem;
    UIImage *image   = galleryItem.image;
    
    [self.imageView setImage:image];
    self.imageView.frame = (CGRect){.origin=CGPointZero, .size=image.size};

    self.scrollView.contentSize = image.size;
    
    CGRect scrollViewFrame = self.scrollView.frame;
    CGFloat scaleWidth     = scrollViewFrame.size.width / self.scrollView.contentSize.width;
    CGFloat scaleHeight    = scrollViewFrame.size.height  / self.scrollView.contentSize.height;
    CGFloat minScale       = MIN(scaleWidth, scaleHeight);
    
    self.scrollView.minimumZoomScale = minScale;
    self.scrollView.maximumZoomScale = 1.0f;
    self.scrollView.zoomScale        = minScale;
    
    CGFloat viewHeight = CGRectGetHeight(self.view.frame);
    CGFloat viewWidth  = CGRectGetWidth(self.view.frame);
    self.scrollView.userInteractionEnabled = viewHeight < image.size.height || viewWidth < image.size.width;

    self.singleTapRecognizer.enabled = YES;
    
    self.navigationItem.rightBarButtonItem.enabled = galleryItem.title;
    
    [self centerScrollViewContents];
}



- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self centerScrollViewContents];
}

@end
