//
//  VideoUploadController.h
//  VidoeEdit
//
//  Created by PSJ on 7/1/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "MBProgressHUD.h"
#import "SHKSharer.h"
#import "SHKShareItemDelegate.h"
#import "SHK.h"
#import "CTAssetsPickerController.h"
#import "GData.h"


@protocol SHKShareItemDelegate;
@interface VideoUploadController : UIViewController<MFMailComposeViewControllerDelegate, MBProgressHUDDelegate,UIAlertViewDelegate, UITextFieldDelegate>
{
    BOOL mIsPrivate;
    
    GDataServiceTicket *mUploadTicket;
    BOOL googleviewflag;
}
@property (nonatomic, retain) MBProgressHUD *HUD;
@property(nonatomic, strong) NSString *savefilestr;

@property (strong) id<SHKShareItemDelegate> shareDelegate;

@property (nonatomic, retain) IBOutlet UIButton *facebookbtn;
@property (nonatomic, retain) IBOutlet UIButton *twitterbtn;
@property (nonatomic, retain) IBOutlet UIButton *mailbtn;
@property (nonatomic, retain) IBOutlet UIButton *backbtn;
@property (nonatomic, retain) IBOutlet UIButton *previewbtn;
@property (nonatomic, retain) IBOutlet UIButton *tumblrbtn;
@property (nonatomic, retain) IBOutlet UIButton *youtubebtn;
@property (nonatomic, retain) IBOutlet UIButton *flickrbtn;
@property (nonatomic, retain) IBOutlet UIButton *okbtn;

// youtube
@property (nonatomic, retain) IBOutlet UIView *google_view;
@property (nonatomic, retain) IBOutlet UITextField *username_txt;
@property (nonatomic, retain) IBOutlet UITextField *password_txt;
@property (nonatomic, retain) IBOutlet UILabel *google_loginalarm;
@property (nonatomic, retain) IBOutlet UIButton *googlecancel_btn;
@property (nonatomic, retain) IBOutlet UIButton *googlesignin_btn;


- (IBAction)googlecancelevent:(id)sender;
- (IBAction)googlesigninevent:(id)sender;



- (IBAction)backbtnclick:(id)sender;
- (IBAction)youtubeupload:(id)sender;
- (IBAction)tumblrupload:(id)sender;
- (IBAction)googleplusupload:(id)sender;
- (IBAction)flickrupload:(id)sender;
- (IBAction)facebookupload:(id)sender;
- (IBAction)twitterupload:(id)sender;
- (IBAction)mailupload:(id)sender;
- (IBAction)videopreshowview:(id)sender;
- (IBAction)gotostartevent:(id)sender;
- (IBAction)gallerysave:(id)sender;
@end
