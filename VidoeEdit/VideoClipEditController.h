//
//  VideoEditeController.h
//  VidoeEdit
//
//  Created by PSJ on 6/11/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "SAVideoRangeSlider.h"

@interface VideoClipEditController : UIViewController<SAVideoRangeSliderDelegate>
{
    BOOL trim_flag;
}
@property (strong, nonatomic) NSString *videopathstr;
@property (strong, nonatomic) NSString *tmpVideoPath;
@property (strong, nonatomic) SAVideoRangeSlider *mySAVideoRangeSlider;

@property (strong, nonatomic) MPMoviePlayerController *movieController;
@property (strong, nonatomic) AVAssetExportSession *exportSession;
@property (nonatomic) CGFloat startTime;
@property (nonatomic) CGFloat stopTime;

@property (strong, nonatomic) IBOutlet UIView *slideview;
@property (nonatomic, retain) IBOutlet UIButton *backbtn;
@property (nonatomic, retain) IBOutlet UIButton *trimbtn;
@property (nonatomic, retain) IBOutlet UIButton *savebtn;
@property (strong, nonatomic) IBOutlet UIView *videoview;

- (IBAction)backclick:(id)sender;
//- (IBAction)playclick:(id)sender;
- (IBAction)trimclick:(id)sender;
- (IBAction)saveclick:(id)sender;
@end
