//
//  AppDelegate.m
//  VidoeEdit
//
//  Created by Sky on 5/14/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "MKStoreManager.h"
#import "MKStoreObserver.h"

#import "SHKDropbox.h"
#import "SHKFacebook.h"
#import "EvernoteSDK.h"
//#import "SHKBuffer.h"
#import "PocketAPI.h"
#import "ShareKitDemoConfigurator.h"
#import "SHKConfiguration.h"
#import "SHK.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    DefaultSHKConfigurator *configurator = [[ShareKitDemoConfigurator alloc] init];
    [SHKConfiguration sharedInstanceWithConfigurator:configurator];
    
    _userDefaults = [NSUserDefaults standardUserDefaults];
    // Override point for customization after application launch.
    UIStoryboard  *storyboard;
    ViewController *viewcontroller;
    _userDefaults = [NSUserDefaults standardUserDefaults];
   [_userDefaults setBool:false forKey:@"purchaseflage"];
    [_userDefaults synchronize];
    
    _comeinpurchasestr = @"";
    _comeoutpurchasestr = @"";
    if(IS_IPHONE_5)
    {
        storyboard = [UIStoryboard storyboardWithName:@"Main"  bundle:nil];
        viewcontroller = [storyboard instantiateInitialViewController];
    }
    else
    {
        storyboard = [UIStoryboard storyboardWithName:@"Main4"  bundle:nil];
        viewcontroller = [storyboard instantiateInitialViewController];
    }
    
    self.window.rootViewController  = viewcontroller;
    [self.window makeKeyAndVisible];
    [self performSelector:@selector(testOffline) withObject:nil afterDelay:0.5];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
//    exit(0);
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)testOffline
{
	[SHK flushOfflineQueue];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	[SHKFacebook handleDidBecomeActive];
    [[EvernoteSession sharedSession] handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Save data if appropriate
	[SHKFacebook handleWillTerminate];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    NSString* scheme = [url scheme];
    if ([scheme hasPrefix:[NSString stringWithFormat:@"fb%@", SHKCONFIG(facebookAppId)]]) {
        return [SHKFacebook handleOpenURL:url];
    }
        else if ([scheme hasPrefix:[NSString stringWithFormat:@"buffer%@", SHKCONFIG(bufferClientID)]]) {
        //return [SHKBuffer handleOpenURL:url];
    }
    return YES;
}

@end