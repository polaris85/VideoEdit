//
//  MusicMergeController.h
//  VidoeEdit
//
//  Created by PSJ on 7/10/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAssetExportSession.h>
#import "MRBarChart.h"
#import "VideoRangeSlider.h"
#import <MediaPlayer/MediaPlayer.h>

@interface MusicMergeController : UIViewController<MRBarChartDataSource, MRBarChartDelegate>
{
    AVAssetExportSession *exportador;
    BOOL playbtnclickflag;
}

@property (nonatomic, strong) NSString *audiopathstr;
@property (strong, nonatomic) NSString *videoPathstr;
@property (nonatomic, retain) IBOutlet UIButton *playbtn;
@property (nonatomic, retain) IBOutlet UIButton *savebtn;

@property (strong, nonatomic) VideoRangeSlider *mySAVideoRangeSlider;
@property (strong, nonatomic) MPMoviePlayerController *movieController;

@property (strong, nonatomic) IBOutlet MRBarChart *barChart;
@property (strong, nonatomic) IBOutlet UIView *videoview;
@property (strong, nonatomic) IBOutlet UIView *slideview;
- (IBAction)playbtnclick:(id)sender;
- (IBAction)savebtnclick:(id)sender;
- (IBAction)backbtnclick:(id)sender;
- (void) buttonfalse;
- (void) buttontrue;
@end
