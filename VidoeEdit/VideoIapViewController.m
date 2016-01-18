//
//  IAPViewController.m
//  VidoeEdit
//
//  Created by PSJ on 7/1/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import "VideoIapViewController.h"

#import "AppDelegate.h"
@interface VideoIapViewController ()

@end

@implementation VideoIapViewController

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
    app = [[UIApplication sharedApplication]delegate];
     userdefalts = [NSUserDefaults standardUserDefaults];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)teneffectevent:(id)sender
{
    [[MKStoreManager sharedManager] buyMag:tenfx];
    app.comeoutpurchasestr = tenfx;
    iaptimer = [NSTimer scheduledTimerWithTimeInterval: 1
                                                target: self
                                              selector:@selector(purchaseupdate)
                                              userInfo: nil repeats:YES];

}

- (IBAction)otherteneffectevent:(id)sender
{
    [[MKStoreManager sharedManager] buyMag:othertenfx];
    app.comeoutpurchasestr = othertenfx;
    iaptimer = [NSTimer scheduledTimerWithTimeInterval: 1
                                                target: self
                                              selector:@selector(purchaseupdate)
                                              userInfo: nil repeats:YES];

}

- (IBAction)tenfxevent:(id)sender
{
    [[MKStoreManager sharedManager] buyMag:tentransition];
    app.comeoutpurchasestr = tentransition;
    iaptimer = [NSTimer scheduledTimerWithTimeInterval: 1
                                                target: self
                                              selector:@selector(purchaseupdate)
                                              userInfo: nil repeats:YES];

}

- (IBAction)allfxevent:(id)sender
{
    [[MKStoreManager sharedManager] buyMag:allfxtransition];
    app.comeoutpurchasestr = allfxtransition;
    iaptimer = [NSTimer scheduledTimerWithTimeInterval: 1
                                                     target: self
                                                   selector:@selector(purchaseupdate)
                                                   userInfo: nil repeats:YES];
}

- (IBAction)backevent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)buttonfalse
{
    [_back_btn setEnabled:FALSE];
    [_tenefect_btn setEnabled:FALSE];
    [_otherteneffect_btn setEnabled:FALSE];
    [_tecfx_btn setEnabled:FALSE];
    [_all_btn setEnabled:FALSE];
}

-(void)buttontrue
{
    [_back_btn setEnabled:TRUE];
    [_tenefect_btn setEnabled:TRUE];
    [_otherteneffect_btn setEnabled:TRUE];
    [_tecfx_btn setEnabled:TRUE];
    [_all_btn setEnabled:TRUE];
}

-(void)purchaseupdate
{
    if([userdefalts boolForKey:@"purchaseflage"])
    {
        [self buttontrue];
        [userdefalts setBool:false forKey:@"purchaseflage"];
        [userdefalts synchronize];
        [iaptimer invalidate];
        iaptimer = nil;
        
        UIAlertView *alert;
        NSString *message;
        if([app.comeinpurchasestr isEqualToString:@"teneffect"])
        {
            [userdefalts setBool:true forKey:@"teneffect"];
            message = @"You purchassed item successfully";
            [userdefalts synchronize];
        }
        else if([app.comeinpurchasestr isEqualToString:@"otherteneffect"])
        {
            [userdefalts setBool:true forKey:@"otherteneffect"];
            message = @"You purchassed item successfully";
            [userdefalts synchronize];
        }
        else if([app.comeinpurchasestr isEqualToString:@"tenfx"])
        {
            [userdefalts setBool:true forKey:@"tenfx"];
            message = @"You purchassed item successfully";
            [userdefalts synchronize];
        }
        else if([app.comeinpurchasestr isEqualToString:@"allfxeffect"])
        {
            [userdefalts setBool:true forKey:@"allfxeffect"];
            message = @"You purchassed item successfully";
            [userdefalts synchronize];
        }
        else
        {
            message = @"Purchase is faied, Please try again now";
        }
        
        alert = [[UIAlertView alloc]initWithTitle:@"Purchase" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        app.comeinpurchasestr = @"";
        app.comeoutpurchasestr = @"";
        
    }
    else
        [self buttonfalse];
}


@end
