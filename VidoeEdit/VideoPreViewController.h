//
//  VideoPreViewController.h
//  VidoeEdit
//
//  Created by PSJ on 7/6/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomMoviePlayerViewController.h"
@interface VideoPreViewController : UIViewController

@property(nonatomic, retain) IBOutlet UIButton *backbtn;
@property(nonatomic, strong) NSString *videopathstr;
@property(strong, nonatomic) MPMoviePlayerController *video_player;

- (IBAction)backevent:(id)sender;
@end
