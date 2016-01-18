//
//  ViewController.m
//  VidoeEdit
//
//  Created by Sky on 5/14/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import "ViewController.h"
#import "VideoEditeController.h"
#import "VideoUploadController.h"
#import "AVCamViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    userDefaults = [NSUserDefaults standardUserDefaults];
    videoarray= [userDefaults objectForKey:@"videolinkurl"];
    [self.navigationController.navigationBar setHidden:YES];
    
//   [self.navigationController setNavigationBarHidden:YES];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Videorecordevent:(id)sender
{
    if(videoarray.count>0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Waring" message:@"You have last edit project now, Do you want to remove it?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
        alert.delegate = self;
        alert.tag = 501;
        [alert show];
    }
    else
    {
        // directory init
        NSArray* tmpDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:NSTemporaryDirectory() error:NULL];
        for (NSString *file in tmpDirectory) {
            [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), file] error:NULL];
        }

       UIStoryboard  *storyboard;
        if(IS_IPHONE_5)
       storyboard = [UIStoryboard storyboardWithName:@"Main"  bundle:nil];
        else
            storyboard = [UIStoryboard storyboardWithName:@"Main4"  bundle:nil];
    
        AVCamViewController *recordviewcontroller = [storyboard instantiateViewControllerWithIdentifier:@"AVCamViewController"];
        [self.navigationController pushViewController:recordviewcontroller animated:YES];
    }
}

- (IBAction)Projectimportevent:(id)sender
{
    
    if(videoarray.count==0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Waring" message:@"You don't have last project now, please create new project." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
       
        UIStoryboard  *storyboard;
        if(IS_IPHONE_5)
            storyboard = [UIStoryboard storyboardWithName:@"Main"  bundle:nil];
        else
            storyboard = [UIStoryboard storyboardWithName:@"Main4"  bundle:nil];
        VideoEditeController *editviewcontroller = [storyboard  instantiateViewControllerWithIdentifier:@"VideoEditeController"];
        editviewcontroller.chooseproject = @"importproject";
        [self.navigationController pushViewController:editviewcontroller animated:YES];
    }
}

- (IBAction)Projectcreatevent:(id)sender
{
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    VideoUploadController *editcontroller = [storyboard instantiateViewControllerWithIdentifier:@"VideoUploadController"];
//    editcontroller.savefilestr = [[NSBundle mainBundle] pathForResource:@"demo_video_share" ofType:@"mov"];
//
//    [self.navigationController pushViewController:editcontroller animated:YES];

    if(videoarray.count>0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Waring" message:@"You have last edit project now, Do you want to remove it?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
        alert.delegate = self;
        alert.tag = 502;
        [alert show];
    }
    else
    {
        UIStoryboard  *storyboard;
        if(IS_IPHONE_5)
            storyboard = [UIStoryboard storyboardWithName:@"Main"  bundle:nil];
        else
            storyboard = [UIStoryboard storyboardWithName:@"Main4"  bundle:nil];
        VideoEditeController *editcontroller = [storyboard instantiateViewControllerWithIdentifier:@"VideoEditeController"];
        editcontroller.chooseproject = @"createproject";
        [self.navigationController pushViewController:editcontroller animated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 501)
    {
        if(buttonIndex ==0)
        {
            // directory init
            NSArray* tmpDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:NSTemporaryDirectory() error:NULL];
            for (NSString *file in tmpDirectory) {
                [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), file] error:NULL];
            }
            
            UIStoryboard  *storyboard;
            if(IS_IPHONE_5)
                storyboard = [UIStoryboard storyboardWithName:@"Main"  bundle:nil];
            else
                storyboard = [UIStoryboard storyboardWithName:@"Main4"  bundle:nil];
            
            AVCamViewController *recordviewcontroller = [storyboard instantiateViewControllerWithIdentifier:@"AVCamViewController"];
            [self.navigationController pushViewController:recordviewcontroller animated:YES];
            [userDefaults setObject:nil forKey:@"videolinkurl"];
            [userDefaults synchronize];

        }
    }
    else if(alertView.tag == 502)
    {
        if(buttonIndex == 0)
        {
            UIStoryboard  *storyboard;
            if(IS_IPHONE_5)
                storyboard = [UIStoryboard storyboardWithName:@"Main"  bundle:nil];
            else
                storyboard = [UIStoryboard storyboardWithName:@"Main4"  bundle:nil];
            VideoEditeController *editcontroller = [storyboard instantiateViewControllerWithIdentifier:@"VideoEditeController"];
            editcontroller.chooseproject = @"createproject";
            [self.navigationController pushViewController:editcontroller animated:YES];
            [userDefaults setObject:nil forKey:@"videolinkurl"];
            [userDefaults synchronize];

        }
    }
}

@end
