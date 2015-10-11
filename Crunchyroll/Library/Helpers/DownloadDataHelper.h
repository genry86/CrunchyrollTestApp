//
//  DownloadDataHelper.h
//  Crunchyroll
//
//  Created by Genry on 6/1/14.
//  Copyright (c) 2014 Genry. All rights reserved.
//

#import "GlobalConstants.h"

@interface DownloadDataHelper : NSObject
+ (DownloadDataHelper*)sharedInstance;
- (void)downloadJSON:(NSString*)jsonURL completionBlock:(CCDownloadDataHCompletionBlock)completionBlock;
- (void)downloadImage:(NSString*)imageURL completionBlock:(CCDownloadImageHCompletionBlock)completionBlock;
@end
