//
//  DownloadDataHelper.m
//  Crunchyroll
//
//  Created by Genry on 6/1/14.
//  Copyright (c) 2014 Genry. All rights reserved.
//

#import "DownloadDataHelper.h"

@implementation DownloadDataHelper

+ (DownloadDataHelper*)sharedInstance
{
    static DownloadDataHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[DownloadDataHelper alloc] init];
    });
    return  helper;
}

- (void)downloadImage:(NSString*)imageURL completionBlock:(CCDownloadImageHCompletionBlock)completionBlock
{
    CCDownloadImageHCompletionBlock block = [completionBlock copy];
    
    [ProgressHUD show:@"Please wait..."];
    
    __weak DownloadDataHelper *weakSelf = self;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue,
                   ^{
                       NSURL *url = [[NSURL alloc] initWithString:imageURL];
                       NSData *data = [NSData dataWithContentsOfURL:url];
                       
                       if (data)
                       {
                           if ([data contentTypeForImageData] != CCHImageTypeUndefined)
                           {
                               dispatch_async(dispatch_get_main_queue(),
                               ^{
                                   block(data);
                               });
                           }
                           else
                           {
                               [weakSelf showErrorInMainQueue:@"Loaded data isn't image" error:nil];
                           }
                       }
                       else
                       {
                           [weakSelf showErrorInMainQueue:@"Loading image problem" error:nil];
                       }
                       dispatch_async(dispatch_get_main_queue(), ^{
                           [ProgressHUD dismiss];
                       });
                   });
}

- (void)downloadJSON:(NSString*)jsonURL completionBlock:(CCDownloadDataHCompletionBlock)completionBlock
{
    CCDownloadDataHCompletionBlock block = [completionBlock copy];
    
    NSURL* url = [NSURL URLWithString:jsonURL];
    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];

    __weak DownloadDataHelper *weakSelf = self;
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:queue
                           completionHandler:^(NSURLResponse* response,
                                               NSData* data,
                                               NSError* error)
     {
         if (data)
         {
             NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
             if (httpResponse.statusCode == kHTTPStatusCodeOK /* OK */ )
             {
                 NSError* error;
                 id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                 if (!error)
                 {
                     if ([jsonObject isKindOfClass:[NSArray class]])
                     {
                        dispatch_async(dispatch_get_main_queue(),
                        ^{
                            block(jsonObject);
                        });
                     }
                     else
                     {
                         [weakSelf showErrorInMainQueue:@"Downloaded data is not an Array" error:error];
                     }
                 }
                 else
                 {
                     [weakSelf showErrorInMainQueue:@"Invalid format of downloaded data" error:error];
                 }
             }
             else
             {
                 NSString* desc = [[NSString alloc] initWithFormat:@"HTTP Request failed with status code: %d (%@)",
                                   (int)(httpResponse.statusCode),
                                   [NSHTTPURLResponse localizedStringForStatusCode:httpResponse.statusCode]];
                 error = [NSError errorWithDomain:@"HTTP Request"
                                             code:-1000
                                         userInfo:@{NSLocalizedDescriptionKey: desc}];
                 [weakSelf showErrorInMainQueue:desc error:error];
             }
         }
         else
         {
             [weakSelf showErrorInMainQueue:@"No data from server." error:error];
         }
         dispatch_async(dispatch_get_main_queue(), ^{
             [ProgressHUD dismiss];
         });
     }];
}

-(void)showErrorInMainQueue:(NSString*)msg error:(NSError*)error
{
    dispatch_async(dispatch_get_main_queue(),
    ^{
       ShowErrorMessage(msg, error);
    });
}

@end
