//
//  YouTubeUploader.h
//  YouTubeSample_iOS
//
//  Created by Manuel Carrasco Molina on 08.01.12.
//  Copyright (c) 2012 Pomcast. All rights reserved.
//

// +----------------------------------------------------------------------------------------+
// | See http://hoishing.wordpress.com/2011/08/23/gdata-objective-c-client-setup-in-xcode-4 |
// +----------------------------------------------------------------------------------------+




#import "MBAlertView.h"
#import "MBHUDView.h"
#import <Foundation/Foundation.h>
#import "GData.h"
#import "GTMOAuth2Authentication.h"
//#import "GoogleCredentials.h"
// This "GoogleCredentials.h" file contains


 


 #define DEV_KEY          @"AI39si5a2ET4_7tRnqlsVOeTWsw5spjqEZwIrW7ZJejFuMyTLTKXhN1oKfcxHuf--GJgtZIjglKn3zKZSYiErExhKxYr_zC45Q"
 #define CLIENT_ID        @"914182920782-dq20c8v22qhbbc82fjo5ll98jieejctd.apps.googleusercontent.com"
 #define CLIENT_SECRET    @"pI4DYqPFRmpm9HiS0CaROjKF"
// The Google API console is also where you can set your Product Name and Logo (Image) that will be used in the Modal OAuth Window.

// Localizable Strings Variables
#define UPLOADED_VIDEO_TITLE            @"UPLOADED_VIDEO_TITLE"
#define UPLOADED_VIDEO_MESSAGE          @"UPLOADED_VIDEO_MESSAGE"
#define ERROR_UPLOAD_VIDEO_TITLE        @"ERROR_UPLOAD_VIDEO_TITLE"

@interface YouTubeUploader : NSObject {
    NSString *filepath;
    MBHUDView *linkingHud;
   
}
@property(nonatomic,retain)    NSString *filepath;
@property (retain, nonatomic) UIProgressView *uploadProgressView;
@property (assign) UIViewController *delegate;

- (void)logout;
- (void)uploadVideoFile:(NSString*)path;

-(void)lookforUTubeLinking;
@end
