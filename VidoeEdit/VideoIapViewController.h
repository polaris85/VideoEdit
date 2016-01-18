//
//  IAPViewController.h
//  VidoeEdit
//
//  Created by PSJ on 7/1/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "MKStoreManager.h"
@interface VideoIapViewController : UIViewController<SKProductsRequestDelegate>
{
    NSTimer *iaptimer;
    NSUserDefaults *userdefalts;
    AppDelegate *app;
}
@property(nonatomic, retain) IBOutlet UIButton *back_btn;
@property(nonatomic, retain) IBOutlet UIButton *tenefect_btn;
@property(nonatomic, retain) IBOutlet UIButton *otherteneffect_btn;
@property(nonatomic, retain) IBOutlet UIButton *tecfx_btn;
@property(nonatomic, retain) IBOutlet UIButton *all_btn;

- (IBAction)teneffectevent:(id)sender;
- (IBAction)otherteneffectevent:(id)sender;
- (IBAction)tenfxevent:(id)sender;
- (IBAction)allfxevent:(id)sender;
- (IBAction)backevent:(id)sender;

@end
