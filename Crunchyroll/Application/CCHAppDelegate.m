//
//  CCHAppDelegate.m
//  Crunchyroll
//
//  Created by Genry on 6/1/14.
//  Copyright (c) 2014 Genry. All rights reserved.
//

#import "CCHAppDelegate.h"

@implementation CCHAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.rootController = [[CCHMenuViewController alloc] init];
    self.window.rootViewController = self.rootController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
