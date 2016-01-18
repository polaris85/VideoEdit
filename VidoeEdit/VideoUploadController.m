
//
//  VideoUploadController.m
//  VidoeEdit
//
//  Created by PSJ on 7/1/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import "VideoUploadController.h"
#import "VideoPreViewController.h"
#import "AppDelegate.h"
#import "ShareKit.h"
#import "GDataServiceGoogleYouTube.h"
#import "GDataEntryYouTubeUpload.h"

#import "SHK.h"
#import "SHKAccountsViewController.h"
#import "SHKUploadsViewController.h"

#define DEVELOPER_KEY @"AI39si5a2ET4_7tRnqlsVOeTWsw5spjqEZwIrW7ZJejFuMyTLTKXhN1oKfcxHuf--GJgtZIjglKn3zKZSYiErExhKxYr_zC45Q"
#define CLIENT_ID @"914182920782-dq20c8v22qhbbc82fjo5ll98jieejctd.apps.googleusercontent.com" // ID of your registered app at Google
#define GooglMessage @"The email or password you entered is incorrect."

@interface VideoUploadController ()
- (GDataServiceTicket *)uploadTicket;
- (void)setUploadTicket:(GDataServiceTicket *)ticket;
- (GDataServiceGoogleYouTube *)youTubeService;
@end

@implementation VideoUploadController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     NSLog(@"url=%@", _savefilestr);
    googleviewflag = false;
    [_google_view setHidden:YES];
    _googlecancel_btn.layer.cornerRadius = 7;
    _googlesignin_btn.layer.cornerRadius = 7;
    _googlecancel_btn.clipsToBounds = YES;
    _googlesignin_btn.clipsToBounds = YES;
    
    _google_view.layer.cornerRadius = 10;
    _google_view.layer.masksToBounds = YES;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(authDidFinish:)
                                                 name:@"SHKAuthDidFinish"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sendDidCancel:)
                                                 name:@"SHKSendDidCancel"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sendDidStart:)
                                                 name:@"SHKSendDidStartNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sendDidFinish:)
                                                 name:@"SHKSendDidFinish"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sendDidFailWithError:)
                                                 name:@"SHKSendDidFailWithError"
                                               object:nil];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backbtnclick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)facebookupload:(id)sender
{
    SHKItem *item = nil;
    bool doShare = YES;
    NSString *filePath = _savefilestr;
    item = [SHKItem filePath:filePath title:@"Afrodita - video"];
     item.tags = [NSArray arrayWithObjects:@"video", @"share", nil];
    SHKSharer* sharer = [[NSClassFromString(@"SHKiOSFacebook") alloc] init];
    [sharer loadItem:item];
    
    if (self.shareDelegate != nil && [self.shareDelegate respondsToSelector:@selector(aboutToShareItem:withSharer:)])
    {
        doShare = [self.shareDelegate aboutToShareItem:item withSharer:sharer];
    }
    if(doShare)
        [sharer share];
}



- (IBAction)twitterupload:(id)sender
{
    SHKItem *item = nil;
    bool doShare = YES;
    NSString *filePath = _savefilestr;
    item = [SHKItem filePath:filePath title:@"Afrodita - video"];
     item.tags = [NSArray arrayWithObjects:@"video", nil];
    SHKSharer* sharer = [[NSClassFromString(@"SHKiOSTwitter") alloc] init];
    [sharer loadItem:item];
    
    if (self.shareDelegate != nil && [self.shareDelegate respondsToSelector:@selector(aboutToShareItem:withSharer:)])
    {
        doShare = [self.shareDelegate aboutToShareItem:item withSharer:sharer];
    }
    if(doShare)
        [sharer share];

}

- (IBAction)youtubeupload:(id)sender
{
    [self buttonsfalse];
    [UIView beginAnimations:@"bucketsOff" context:nil];
    [UIView setAnimationDuration:0.7];
    [UIView setAnimationDelegate:self];
    //position off screen
    [_google_view setHidden:NO];
    
    //animate off screen
    [UIView commitAnimations];
}

- (IBAction)tumblrupload:(id)sender
{
    SHKItem *item = nil;
    bool doShare = YES;
    NSString *filePath = _savefilestr;
    item = [SHKItem filePath:filePath title:@"Afrodita - video"];
     item.tags = [NSArray arrayWithObjects:@"video", nil];
    SHKSharer* sharer = [[NSClassFromString(@"SHKTumblr") alloc] init];
    [sharer loadItem:item];
    
    if (self.shareDelegate != nil && [self.shareDelegate respondsToSelector:@selector(aboutToShareItem:withSharer:)])
    {
        doShare = [self.shareDelegate aboutToShareItem:item withSharer:sharer];
    }
    if(doShare)
        [sharer share];
    
}


- (IBAction)flickrupload:(id)sender
{
    SHKItem *item = nil;
    bool doShare = YES;
    NSString *filePath = _savefilestr;
    item = [SHKItem filePath:filePath title:@"Afrodita - video"];
    item.tags = [NSArray arrayWithObjects:@"video", @"share", nil];
    SHKSharer* sharer = [[NSClassFromString(@"SHKFlickr") alloc] init];
    [sharer loadItem:item];
    
    if (self.shareDelegate != nil && [self.shareDelegate respondsToSelector:@selector(aboutToShareItem:withSharer:)])
    {
        doShare = [self.shareDelegate aboutToShareItem:item withSharer:sharer];
    }
    if(doShare)
        [sharer share];
}



- (IBAction)mailupload:(id)sender
{
    SHKItem *item = nil;
    bool doShare = YES;
    NSString *filePath = _savefilestr;
    item = [SHKItem filePath:filePath title:@"Afrodita - video"];
     item.tags = [NSArray arrayWithObjects:@"video", @"share", nil];
    SHKSharer* sharer = [[NSClassFromString(@"SHKMail") alloc] init];
    [sharer loadItem:item];
    
    if (self.shareDelegate != nil && [self.shareDelegate respondsToSelector:@selector(aboutToShareItem:withSharer:)])
    {
        doShare = [self.shareDelegate aboutToShareItem:item withSharer:sharer];
    }
    if(doShare)
        [sharer share];
}
- (IBAction)videopreshowview:(id)sender
{
    UIStoryboard  *storyboard;
    if(IS_IPHONE_5)
        storyboard = [UIStoryboard storyboardWithName:@"Main"  bundle:nil];
    else
        storyboard = [UIStoryboard storyboardWithName:@"Main4"  bundle:nil];
    VideoPreViewController *previewcontroller = [storyboard  instantiateViewControllerWithIdentifier:@"VideoPreViewController"];
    previewcontroller.videopathstr = _savefilestr;
    [self.navigationController pushViewController:previewcontroller animated:YES];
}

- (IBAction)gotostartevent:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)gallerysave:(id)sender
{
    _HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    _HUD.delegate = self;
    [_HUD setLabelText:@"Saving...."];
    NSURL *url = [NSURL fileURLWithPath:_savefilestr];
    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
    [assetLibrary writeVideoAtPathToSavedPhotosAlbum:url completionBlock:^(NSURL *assetURL, NSError *error){
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"Success!"
                                                            message:@"You saved video successfully"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        dispatch_async(dispatch_get_main_queue(), ^(void){
               [alertview show];
                [_HUD hide:YES];
        });
    }];
}

- (IBAction)googlecancelevent:(id)sender
{
    [_google_view setHidden:YES];
    [self buttonstrue];
}

- (IBAction)googlesigninevent:(id)sender
{
    if([_username_txt.text isEqualToString:@""])
    {
        [_google_loginalarm setText:@"Enter your email address."];
        return;
    }
    if([_password_txt.text isEqualToString:@""])
    {
        [_google_loginalarm setText:@"Enter your password."];
        return;
    }
    
    googleviewflag = false;
    _HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    _HUD.delegate = self;
    [_HUD setLabelText:@"Signing...."];
    
    [_google_loginalarm setText:@""];

    GDataServiceGoogleYouTube *service = [self youTubeService];
    [service setYouTubeDeveloperKey:DEVELOPER_KEY];
    NSURL *url = [GDataServiceGoogleYouTube youTubeUploadURLForUserID:@"default"
                                                             clientID:CLIENT_ID];
    NSData *data = [NSData dataWithContentsOfFile:_savefilestr];
    NSString *titleStr = @"MyVideo";
    GDataMediaTitle *title = [GDataMediaTitle textConstructWithString:titleStr];
    
    NSString *categoryStr = @"Entertainment";
    GDataMediaCategory *category = [GDataMediaCategory mediaCategoryWithString:categoryStr];
    [category setScheme:kGDataSchemeYouTubeCategory];
    
    NSString *descStr = @"video share , video edit";
    GDataMediaDescription *desc = [GDataMediaDescription textConstructWithString:descStr];
    
    NSString *keywordsStr = @"video edit";
    GDataMediaKeywords *keywords = [GDataMediaKeywords keywordsWithString:keywordsStr];
    
    BOOL isPrivate = mIsPrivate;
    
    GDataYouTubeMediaGroup *mediaGroup = [GDataYouTubeMediaGroup mediaGroup];
    [mediaGroup setMediaTitle:title];
    [mediaGroup setMediaDescription:desc];
    [mediaGroup addMediaCategory:category];
    [mediaGroup setMediaKeywords:keywords];
    [mediaGroup setIsPrivate:isPrivate];
    
    NSString *mimeType = [GDataUtilities MIMETypeForFileAtPath:_savefilestr
                                               defaultMIMEType:@"video/mp4"];
    
    GDataEntryYouTubeUpload *entry;
    entry = [GDataEntryYouTubeUpload uploadEntryWithMediaGroup:mediaGroup
                                                          data:data
                                                      MIMEType:mimeType
                                                          slug:@"Good Video"];
    
    SEL progressSel = @selector(ticket:hasDeliveredByteCount:ofTotalByteCount:);
    [service setServiceUploadProgressSelector:progressSel];
    
    GDataServiceTicket *ticket;
    ticket = [service fetchEntryByInsertingEntry:entry
                                      forFeedURL:url
                                        delegate:self
                               didFinishSelector:@selector(uploadTicket:finishedWithEntry:error:)];
    
    [self setUploadTicket:ticket];

}

// progress callback
- (void)ticket:(GDataServiceTicket *)ticket
hasDeliveredByteCount:(unsigned long long)numberOfBytesRead
ofTotalByteCount:(unsigned long long)dataLength {
    
    if(numberOfBytesRead>5 && googleviewflag == false)
    {
        [_HUD setLabelText:@"Uploading...."];
        [self buttonsfalse];
        [UIView beginAnimations:@"bucketsOff" context:nil];
        [UIView setAnimationDuration:0.7];
        [UIView setAnimationDelegate:self];
        //position off screen
        [_google_view setHidden:YES];
        
        //animate off screen
        [UIView commitAnimations];
        googleviewflag = true;
    }
}

// upload callback
- (void)uploadTicket:(GDataServiceTicket *)ticket
   finishedWithEntry:(GDataEntryYouTubeVideo *)videoEntry
               error:(NSError *)error {
     if (error == nil) {
         [_HUD hide:YES];
         NSLog(@"Post Link: %@",videoEntry.HTMLLink.href);
         // tell the user that the add worked
         UIAlertView *alert = [[UIAlertView alloc]
                               initWithTitle:@"Success"
                               message:@"Video Is Successfully Uploaded!!!"
                               delegate:nil
                               cancelButtonTitle:@"Ok"
                               otherButtonTitles:nil];
         
         [alert show];

     }
    else {
        [_HUD hide:YES];
        [_google_loginalarm setText:GooglMessage];
    }

}


- (void)authDidFinish:(NSNotification*)notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSNumber *success = [userInfo objectForKey:@"success"];
    
    if (NO == [success boolValue]) {
        NSLog(@"authDidFinish: NO");
    } else {
        NSLog(@"authDidFinish: YES");
    }
    
}

- (void)sendDidCancel:(NSNotification*)notification
{
    NSLog(@"sendDidCancel:");
}

- (void)sendDidStart:(NSNotification*)notification
{
    NSLog(@"sendDidStart:");
    [self buttonsfalse];
}

- (void)sendDidFinish:(NSNotification*)notification
{
    NSLog(@"sendDidFinish:");
    [self buttonstrue];
}

- (void)sendDidFailWithError:(NSNotification*)notification
{
    NSLog(@"sendDidFailWithError:");
    [self buttonstrue];
}

- (void)buttonsfalse
{
    [_facebookbtn setEnabled:false];
    [_twitterbtn setEnabled:false];
    [_mailbtn setEnabled:false];
    [_backbtn setEnabled:false];
    [_previewbtn setEnabled:false];
    [_tumblrbtn setEnabled:false];
    [_youtubebtn setEnabled:false];
    [_flickrbtn setEnabled:false];
    [_okbtn setEnabled:false];
}

- (void)buttonstrue
{
    [_facebookbtn setEnabled:true];
    [_twitterbtn setEnabled:true];
    [_mailbtn setEnabled:true];
    [_backbtn setEnabled:true];
    [_previewbtn setEnabled:true];
    [_tumblrbtn setEnabled:true];
    [_youtubebtn setEnabled:true];
    [_flickrbtn setEnabled:true];
    [_okbtn setEnabled:true];
}

// youtube
#pragma mark -
#pragma mark Setters

- (GDataServiceGoogleYouTube *)youTubeService {
    
    static GDataServiceGoogleYouTube* service = nil;
    
    if (!service) {
        service = [[GDataServiceGoogleYouTube alloc] init];
        
        [service setShouldCacheDatedData:YES];
        [service setServiceShouldFollowNextLinks:YES];
        [service setIsServiceRetryEnabled:YES];
    }
    
    // update the username/password each time the service is requested
    NSString *username = [_username_txt text]; //[[mUsernameField text] stringByAppendingString:@"@gmail.com"];
    NSString *password = [_password_txt text];
    
    if ([username length] > 0 && [password length] > 0) {
        [service setUserCredentialsWithUsername:username
                                       password:password];
    } else {
        // fetch unauthenticated
        [service setUserCredentialsWithUsername:nil
                                       password:nil];
    }
    
    [service setYouTubeDeveloperKey:DEVELOPER_KEY];
    
    return service;
}

- (GDataServiceTicket *)uploadTicket {
    return mUploadTicket;
}

- (void)dealloc
{
    [super dealloc];
    [_HUD release];
    _HUD = nil;
    
    [mUploadTicket release];
    mUploadTicket = nil;
}

- (void)setUploadTicket:(GDataServiceTicket *)ticket {
    [mUploadTicket release];
    mUploadTicket = [ticket retain];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField setUserInteractionEnabled:YES];
    [textField resignFirstResponder];
    
    return  YES;
}

@end
