#import "VideoClipEditController.h"

@interface VideoClipEditController ()
{
 }
@end

@implementation VideoClipEditController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *tempDir = NSTemporaryDirectory();
    self.tmpVideoPath = [tempDir stringByAppendingPathComponent:@"tmpMov.mov"];
    
    self.mySAVideoRangeSlider = [[SAVideoRangeSlider alloc] initWithFrame:CGRectMake(0, 0, self.slideview.frame.size.width, self.slideview.frame.size.height) videoUrl:[NSURL fileURLWithPath:self.videopathstr]];
    
    
    NSLog(@"videopath=%@",_videopathstr);
    self.movieController = [[MPMoviePlayerController alloc] init];
    [self.movieController.view setFrame:CGRectMake(0, 0, self.videoview.frame.size.width, self.videoview.frame.size.height)];
    [self.movieController setContentURL:[NSURL fileURLWithPath:self.videopathstr]];
    [self.videoview addSubview:self.movieController.view];
    
    [self.movieController setContentURL:[NSURL fileURLWithPath:_videopathstr]];
    [self.movieController play];
    self.mySAVideoRangeSlider.delegate = self;
    
    [self.slideview addSubview:self.mySAVideoRangeSlider];
}



- (IBAction)backclick:(id)sender
{
    [self.movieController stop];
    if([[NSFileManager defaultManager] fileExistsAtPath:_tmpVideoPath])
        [[NSFileManager defaultManager] removeItemAtPath:_tmpVideoPath error:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}




- (IBAction)trimclick:(id)sender
{
    [self deleteTmpFile];
    trim_flag = true;
    NSURL *videoFileUrl = [NSURL fileURLWithPath:self.videopathstr];
    
    AVAsset *anAsset = [[AVURLAsset alloc] initWithURL:videoFileUrl options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:anAsset];
    if ([compatiblePresets containsObject:AVAssetExportPresetMediumQuality]) {
        
        self.exportSession = [[AVAssetExportSession alloc]
                              initWithAsset:anAsset presetName:AVAssetExportPresetPassthrough];
        // Implementation continues.
        
        NSURL *furl = [NSURL fileURLWithPath:self.tmpVideoPath];
        
        self.exportSession.outputURL = furl;
        self.exportSession.outputFileType = AVFileTypeQuickTimeMovie;
        
        CMTime start = CMTimeMakeWithSeconds(self.startTime, anAsset.duration.timescale);
        CMTime duration = CMTimeMakeWithSeconds(self.stopTime-self.startTime, anAsset.duration.timescale);
        CMTimeRange range = CMTimeRangeMake(start, duration);
        self.exportSession.timeRange = range;
        
        [self buttondisable];
        [self.exportSession exportAsynchronouslyWithCompletionHandler:^{
            
            switch ([self.exportSession status]) {
                case AVAssetExportSessionStatusFailed:
                    NSLog(@"Export failed: %@", [[self.exportSession error] localizedDescription]);
                    break;
                case AVAssetExportSessionStatusCancelled:
                    NSLog(@"Export canceled");
                    break;
                default:
                    NSLog(@"NONE");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self buttonenable];
                        [self.movieController stop];
                        [self.movieController setContentURL:[NSURL fileURLWithPath:_tmpVideoPath]];
                        [self.movieController play];

                    });
                    
                    break;
            }
        }];
        
    }

}

- (IBAction)saveclick:(id)sender
{
    if(trim_flag)
    {
        if([[NSFileManager defaultManager] fileExistsAtPath:_videopathstr])
            [[NSFileManager defaultManager] removeItemAtPath:_videopathstr error:nil];
    
        NSString *sourceurl = _tmpVideoPath;
        if ([[NSFileManager defaultManager] isReadableFileAtPath:sourceurl] )
        {
            [[NSFileManager defaultManager] copyItemAtURL:[NSURL fileURLWithPath:sourceurl] toURL:[NSURL fileURLWithPath:_videopathstr] error:nil];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Saved" message:@"saved video successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
}


#pragma mark - Other
-(void)deleteTmpFile{
    
    NSURL *url = [NSURL fileURLWithPath:self.tmpVideoPath];
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL exist = [fm fileExistsAtPath:url.path];
    NSError *err;
    if (exist) {
        [fm removeItemAtURL:url error:&err];
        NSLog(@"file deleted");
        if (err) {
            NSLog(@"file remove error, %@", err.localizedDescription );
        }
    } else {
        NSLog(@"no file by that name");
    }
}


#pragma mark - SAVideoRangeSliderDelegate

- (void)videoRange:(SAVideoRangeSlider *)videoRange didChangeLeftPosition:(CGFloat)leftPosition rightPosition:(CGFloat)rightPosition
{
    self.startTime = leftPosition;
    self.stopTime = rightPosition;
}

- (void)buttondisable
{
    [_trimbtn setEnabled:NO];
    [_savebtn setEnabled:NO];
    [_backbtn setEnabled:NO];
}


- (void)buttonenable
{
    [_trimbtn setEnabled:YES];
    [_savebtn setEnabled:YES];
    [_backbtn setEnabled:YES];
}

@end