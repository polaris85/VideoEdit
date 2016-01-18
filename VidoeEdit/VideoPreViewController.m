//
//  VideoPreViewController.m
//  VidoeEdit
//
//  Created by PSJ on 7/6/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import "VideoPreViewController.h"

@interface VideoPreViewController ()

@end

@implementation VideoPreViewController

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
    NSURL *videourl = [NSURL fileURLWithPath:_videopathstr];
    self.video_player = [[MPMoviePlayerController alloc]initWithContentURL:videourl];
    self.video_player.controlStyle = MPMovieControlStyleEmbedded;
    self.video_player.fullscreen = YES;
    [self.video_player prepareToPlay];
    self.video_player.shouldAutoplay = NO;
    
    self.video_player.view.frame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
    
    [self.view addSubview:self.video_player.view];
    [self.view bringSubviewToFront:_backbtn];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backevent:(id)sender
{
    [self.video_player stop];
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
