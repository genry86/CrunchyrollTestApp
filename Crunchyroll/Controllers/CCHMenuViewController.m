//
//  CCHMenuViewController.m
//  Crunchyroll
//
//  Created by Genry on 6/1/14.
//  Copyright (c) 2014 Genry. All rights reserved.
//

#import "CCHMenuViewController.h"
#import "FTWCache.h"
#import "CCHImageViewController.h"
#import "DownloadDataHelper.h"
#import "CCHGalleryItem.h"

@interface CCHMenuViewController ()
@property (nonatomic, strong) UITableView *menuTableView;
@property (nonatomic, strong) UINavigationController *contentController;
@property (nonatomic, strong) NSMutableArray *galleryItems;
@end

@implementation CCHMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _galleryItems = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _menuTableView = [[UITableView alloc] init];
    CGRect rect = self.view.frame;
    _menuTableView.frame = CGRectMake(0, kCCHStatusBarHeight, rect.size.width, rect.size.height - kCCHStatusBarHeight);
    _menuTableView.delegate = self;
    _menuTableView.dataSource = self;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_menuTableView];
    
    CCHImageViewController *imageViewController = [[CCHImageViewController alloc] initWithNibName:@"CCHImageViewController" bundle:nil];
    self.contentController = [[UINavigationController alloc] initWithRootViewController:imageViewController];
    
    CGSize size = self.view.frame.size;

    self.contentController.view.frame = CGRectMake(CCHMenuVisibleWidth, 0, size.width, size.height);
    
    UIBarButtonItem *showMenuBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu"
                                                                                style:UIBarButtonItemStylePlain
                                                                               target:self action:@selector(showMenu:)];
    
    imageViewController.navigationItem.leftBarButtonItems = @[showMenuBarButtonItem];
    
    [self addChildViewController:self.contentController];
    [self.view addSubview:self.contentController.view];
    
    [self downloadData];
}

- (void)showMenu:(id)sender
{
    CGSize size = self.contentController.view.frame.size;
    [UIView animateWithDuration:0.5 animations:^{
        CCHImageViewController *imageViewController = (CCHImageViewController*)self.contentController.topViewController;
        imageViewController.singleTapRecognizer.enabled = NO;
        
        self.contentController.view.frame = CGRectMake(CCHMenuVisibleWidth, 0, size.width, size.height);
    }];
}

- (void)downloadData
{
    __weak CCHMenuViewController *weakSelf = self;
    
    DownloadDataHelper *downloadDataHelper = [DownloadDataHelper sharedInstance];
    [downloadDataHelper downloadJSON:kCCHJSONDataULRAddress
                     completionBlock:^(NSArray *galleryItems)
                     {
                         NSArray *items = [galleryItems subarrayWithRange:NSMakeRange(0, 100)];
                         
                         [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
                          {
                              NSString *title        =  [obj valueForKey:kCCHJSONDataItemTitleField];
                              NSString *imageUrl     =  [obj valueForKey:kCCHJSONDataItemImageField];
                              NSString *thumbnailUrl =  [obj valueForKey:kCCHJSONDataItemThumbnailField];
                              
                              CCHGalleryItem *galleryItem = [CCHGalleryItem new];
                              
                              if (![title isKindOfClass:[NSNull class]])                 galleryItem.title    = title;
                              if (imageUrl && ![imageUrl isKindOfClass:[NSNull class]])  galleryItem.imageURL = imageUrl;
                              
                              if (thumbnailUrl && ![thumbnailUrl isKindOfClass:[NSNull class]])
                              {
                                  NSString *key = [thumbnailUrl MD5String];
                                  NSData *data  = [FTWCache objectForKey:key];
                                  
                                  if (data)
                                  {
                                      galleryItem.thumbnail = [UIImage imageWithData:data];
                                  }
                                  else
                                  {
                                      NSURL *url     = [[NSURL alloc] initWithString:thumbnailUrl];
                                      NSData *data   = [NSData dataWithContentsOfURL:url];
                                      UIImage *image = [UIImage imageWithData:data];
                                      image          = [image imageByScalingAndCroppingForSize:CGSizeMake(kCCHTableViewCellHeight, kCCHTableViewCellHeight)];
                                      
                                      NSData *imageData;
                                      if ([data contentTypeForImageData] == CCHImageTypePNG)
                                      {
                                          imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
                                      }
                                      else if([data contentTypeForImageData] == CCHImageTypeJPEG)
                                      {
                                          imageData = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0)];
                                      }
                                      
                                      if (imageData)
                                      {
                                          [FTWCache setObject:imageData forKey:key];
                                          galleryItem.thumbnail = image;
                                      }
                                      else
                                      {
                                          NSLog(@"Bad image data");
                                      }
                                  }
                              }
                              [_galleryItems addObject:galleryItem];
                          }];
                         
                         [weakSelf.menuTableView reloadData];
                         [ProgressHUD dismiss];
                     }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _galleryItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text  = nil;
    cell.imageView.image = nil;
    
    NSUInteger      row         = [indexPath row];
    CCHGalleryItem *galleryItem = _galleryItems[row];
    
    if (galleryItem.title)
    {
        cell.textLabel.text = galleryItem.title;
    }
    else
    {
        cell.textLabel.text = @"No Title";
    }
    if (galleryItem.thumbnail) cell.imageView.image = galleryItem.thumbnail;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger      row         = [indexPath row];
    CCHGalleryItem *galleryItem = _galleryItems[row];

    if (galleryItem.image)
    {
        [self presentDetailedImage:galleryItem];
    }
    else
    {
        __weak CCHMenuViewController *weakSelf = self;
        
        DownloadDataHelper *downloadDataHelper = [DownloadDataHelper sharedInstance];
        [downloadDataHelper downloadImage:galleryItem.imageURL
                          completionBlock:^(NSData *imageData)
                            {
                                NSString *key = [galleryItem.imageURL MD5String];
                                [FTWCache setObject:imageData forKey:key];
                                UIImage *image = [UIImage imageWithData:imageData];
                                
                                galleryItem.image = image;
                                
                                [weakSelf presentDetailedImage:galleryItem];
                            }];
    }
}

-(void)presentDetailedImage:(CCHGalleryItem*)galleryItem
{
    CCHImageViewController *imageViewController = (CCHImageViewController*)self.contentController.topViewController;
    
    CGSize size = self.contentController.view.frame.size;
    [imageViewController setupImage:galleryItem];
    [UIView animateWithDuration:0.5 animations:^{
        self.contentController.view.frame = CGRectMake(0, 0, size.width, size.height);
    }];
}

@end
