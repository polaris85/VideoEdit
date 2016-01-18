//
//  AppDelegate.h
//  VidoeEdit
//
//  Created by Sky on 5/14/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSString *comeinpurchasestr;
@property (nonatomic, strong) NSString *comeoutpurchasestr;

extern NSString *const FBSessionStateChangedNotification;

- (void) closeSession;

- (BOOL)sessionIsActiveAndOpen;
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
@end
