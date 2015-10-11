//
//  GlobalConstants.h
//  Crunchyroll
//
//  Created by Genry on 6/1/14.
//  Copyright (c) 2014 Genry. All rights reserved.
//

typedef enum AppMode{
    CCHImageTypeUndefined = 0,
    CCHImageTypePNG,
    CCHImageTypeJPEG,
    CCHImageTypeGIF,
    CCHImageTypeTIFF
}CCHImageType;

extern NSUInteger const kCCHStatusBarHeight;
extern NSUInteger const kCCHNavigationBarHeight;
extern NSUInteger const kCCHFullTopBarHeight;

extern NSUInteger const kCCHTableViewCellHeight;

extern NSUInteger const kHTTPStatusCodeOK;

extern NSString *const kCCHJSONDataULRAddress;
extern NSString *const kCCHJSONDataItemTitleField;
extern NSString *const kCCHJSONDataItemImageField;
extern NSString *const kCCHJSONDataItemThumbnailField;

typedef void(^CCDownloadDataHCompletionBlock)(NSArray* galleryItems);
typedef void(^CCDownloadImageHCompletionBlock)(NSData *imageData);

#define CCHMenuVisibleWidth ([[UIScreen mainScreen] bounds].size.width - 60)

@interface GlobalConstants : NSObject

@end
