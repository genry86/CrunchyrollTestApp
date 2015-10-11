//
//  CCHImageViewController.h
//  Crunchyroll
//
//  Created by Genry on 6/1/14.
//  Copyright (c) 2014 Genry. All rights reserved.
//

#import "CCHGalleryItem.h"

@interface CCHImageViewController : UIViewController<UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UITapGestureRecognizer *singleTapRecognizer;

- (void)setupImage:(CCHGalleryItem*)galleryItem;

@end
