//
//  GlobalConstants.m
//  Crunchyroll
//
//  Created by Genry on 6/1/14.
//  Copyright (c) 2014 Genry. All rights reserved.
//

#import "GlobalConstants.h"

NSUInteger const kCCHStatusBarHeight = 20;
NSUInteger const kCCHNavigationBarHeight = 20;
NSUInteger const kCCHFullTopBarHeight = kCCHStatusBarHeight + kCCHNavigationBarHeight;

NSUInteger const kCCHTableViewCellHeight = 50;

NSUInteger const kHTTPStatusCodeOK = 200;

NSString *const kCCHJSONDataULRAddress = @"http://jsonplaceholder.typicode.com/photos";
NSString *const kCCHJSONDataItemTitleField = @"title";
NSString *const kCCHJSONDataItemImageField = @"url";
NSString *const kCCHJSONDataItemThumbnailField = @"thumbnailUrl";

@implementation GlobalConstants

@end
