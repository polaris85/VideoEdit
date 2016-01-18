//
//  ViewController.m
//  dragandcircle
//
//  Created by Sky on 5/26/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import "VideoEditeController.h"
#import "DragImageView.h"
#import "SBPageFlowView.h"
#import "Filtering/DLCGrayscaleContrastFilter.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "VideoClipEditController.h"
#import "VideoUploadController.h"
#import "VideoIapViewController.h"
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "MusicMergeController.h"
#import "UIView+Genie.h"
#import "VideoPreViewController.h"

@interface VideoEditeController ()<SBPageFlowViewDelegate,SBPageFlowViewDataSource>
{
    NSArray *_filterflowimageArray;
    NSArray *_effectflowimageArray;
    
    NSInteger    _filterflowcurrentPage;
    SBPageFlowView  *_filterflowView;
}

- (void)showImage;
- (CGFloat)getRadinaByRadian:(CGFloat)radian;
- (void)addGesture;
- (void)handleSinglePan:(id)sender;
- (void)dragPoint:(CGPoint)dragPoint movePoint:(CGPoint)movePoint centerPoint:(CGPoint)centerPoint;
- (void)reviseCirclePoint;
- (void)animateWithDuration:(CGFloat)time animateDelay:(CGFloat)delay changeIndex:(NSInteger)change_index toIndex:(NSInteger)to_index circleArray:(NSMutableArray *)array clockwise:(BOOL)is_clockwise;

@end

@implementation VideoEditeController

#define animationtime 0.8
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
     _filterflowimageArray = [[NSArray alloc] initWithObjects:@"filter01.png",@"filter02.png",@"filter03.png",@"filter04.png",@"filter05.png",@"filter06.png",@"filter07.png",@"filter08.png",@"filter09.png",@"filter10.png",nil];
    // in app purchase
    if([userdefaults boolForKey:@"allfxeffect"])
    {
        _effectflowimageArray = [[NSArray alloc] initWithObjects:@"transfer1.png",@"transfer2.png",@"transfer3.png",@"transfer4.png",@"transfer5.png",@"transfer6.png",@"transfer7.png",@"transfer8.png",@"transfer9.png",@"transfer10.png",@"transfer11.png",@"transfer12.png",@"transfer13.png",@"transfer14.png",@"transfer15.png",@"transfer16.png",@"transfer17.png",@"transfer18.png",@"transfer19.png",@"transfer20.png",@"transfer21.png",@"transfer22.png",@"transfer23.png",@"transfer24.png",@"transfer25.png",@"transfer26.png",@"transfer27.png",@"transfer28.png",@"transfer29.png",@"transfer30.png",@"transfer31.png",@"transfer32.png",@"transfer33.png",@"transfer34.png",@"transfer35.png",@"transfer36.png",@"transfer37.png",@"transfer38.png",@"transfer39.png",@"transfer40.png",nil];
    }
    else
    {
        
        if([userdefaults boolForKey:@"teneffect"] && [userdefaults boolForKey:@"otherteneffect"] && [userdefaults boolForKey:@"tenfx"])
        {
            _effectflowimageArray = [[NSArray alloc] initWithObjects:@"transfer1.png",@"transfer2.png",@"transfer3.png",@"transfer4.png",@"transfer5.png",@"transfer6.png",@"transfer7.png",@"transfer8.png",@"transfer9.png",@"transfer10.png",@"transfer11.png",@"transfer12.png",@"transfer13.png",@"transfer14.png",@"transfer15.png",@"transfer16.png",@"transfer17.png",@"transfer18.png",@"transfer19.png",@"transfer20.png",@"transfer21.png",@"transfer22.png",@"transfer23.png",@"transfer24.png",@"transfer25.png",@"transfer26.png",@"transfer27.png",@"transfer28.png",@"transfer29.png",@"transfer30.png",@"transfer31.png",@"transfer32.png",@"transfer33.png",@"transfer34.png",@"transfer35.png",@"transfer36.png",@"transfer37.png",@"transfer38.png",@"transfer39.png",@"transfer40.png",nil];
        }
        else if(([userdefaults boolForKey:@"teneffect"] && [userdefaults boolForKey:@"otherteneffect"]) || ([userdefaults boolForKey:@"teneffect"] && [userdefaults boolForKey:@"tenfx"]) || ([userdefaults boolForKey:@"otherteneffect"] && [userdefaults boolForKey:@"tenfx"]))
        {
            _effectflowimageArray = [[NSArray alloc] initWithObjects:@"transfer1.png",@"transfer2.png",@"transfer3.png",@"transfer4.png",@"transfer5.png",@"transfer6.png",@"transfer7.png",@"transfer8.png",@"transfer9.png",@"transfer10.png",@"transfer11.png",@"transfer12.png",@"transfer13.png",@"transfer14.png",@"transfer15.png",@"transfer16.png",@"transfer17.png",@"transfer18.png",@"transfer19.png",@"transfer20.png",@"transfer21.png",@"transfer22.png",@"transfer23.png",@"transfer24.png",@"transfer25.png",@"transfer26.png",@"transfer27.png",@"transfer28.png",@"transfer29.png",@"transfer30.png",@"iap_icon.png",nil];
        }
        else if([userdefaults boolForKey:@"teneffect"] || [userdefaults boolForKey:@"otherteneffect"] || [userdefaults boolForKey:@"tenfx"])
        {
            _effectflowimageArray = [[NSArray alloc] initWithObjects:@"transfer1.png",@"transfer2.png",@"transfer3.png",@"transfer4.png",@"transfer5.png",@"transfer6.png",@"transfer7.png",@"transfer8.png",@"transfer9.png",@"transfer10.png",@"transfer11.png",@"transfer12.png",@"transfer13.png",@"transfer14.png",@"transfer15.png",@"transfer16.png",@"transfer17.png",@"transfer18.png",@"transfer19.png",@"transfer20.png",@"iap_icon.png",nil];
        }
        else{
            _effectflowimageArray = [[NSArray alloc] initWithObjects:@"transfer1.png",@"transfer2.png",@"transfer3.png",@"transfer4.png",@"transfer5.png",@"transfer6.png",@"transfer7.png",@"transfer8.png",@"transfer9.png",@"transfer10.png",@"iap_icon.png",nil];
        }
    }
    
    [self documentsempty];
    if(_filterflowView!=nil)
       [_filterflowView reloadData];
     NSLog(@"test=%lu", (unsigned long)[_effectflowimageArray count]);
    
    if(testimages.count>0)
    {
        [self setthumbnailimage];
    }
    
    [self getvideoduration];
}

- (void)documentsempty
{
    NSError *err = nil;
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSFileManager* fm = [[NSFileManager alloc] init];
    NSDirectoryEnumerator* en = [fm enumeratorAtPath:path];
    NSError* errr = nil;
    BOOL res;
    NSString* file;
    while (file = [en nextObject]) {
        if ([file rangeOfString:@".sqlite"].location == NSNotFound) {
            res = [fm removeItemAtPath:[path stringByAppendingPathComponent:file] error:&errr];
            if (!res && err) {
                NSLog(@"oops: %@", err);
            }
        }
    }

}

- (void)getvideoduration
{
    if(testimages.count>0)
    {
        int seconds;
        video_all_time = 0.0f;
        for(int i=0;i<testimages.count;i++)
        {
            testdictionary = [testimages objectAtIndex:i];
            NSString *stringUrl = [NSTemporaryDirectory() stringByAppendingPathComponent:[testdictionary objectForKey:@"real_url"]];
            NSURL *vidURL = [NSURL fileURLWithPath:stringUrl];
            AVAsset *asset = [AVAsset assetWithURL:vidURL];
           
            seconds = CMTimeGetSeconds(asset.duration);;
            [testdictionary setValue:[NSString stringWithFormat:@"%d", seconds] forKeyPath:@"video_duration"];
            video_all_time = video_all_time + seconds;
           
        }
        int videotime = (int)ceilf(video_all_time );
        [_remaintimelbl setText:[self timeFormatted:videotime]];
    }
    
}



- (void)setthumbnailimage
{
    NSString *videourlstr = @"";
    if(testimages.count>0)
    {
        for(int i=0;i<testimages.count;i++)
        {
            videourlstr = [NSTemporaryDirectory() stringByAppendingPathComponent:[[testimages objectAtIndex:i] objectForKey:@"real_url"]];
            NSLog(@"video_path=%@", videoPathstr);
            NSURL *vidURL = [NSURL fileURLWithPath:videourlstr];
            AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:vidURL options:nil];
            AVAssetImageGenerator *generate = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        
            NSError *err = NULL;
                CMTime time = CMTimeMake(1, 60);
        
            CGImageRef imgRef = [generate copyCGImageAtTime:time actualTime:NULL error:&err];
            UIImage *thumbnail = [UIImage imageWithCGImage:imgRef];
            DragImageView *dragImageView = [[testimages objectAtIndex:i] objectForKey:@"virtual_image"];
            dragImageView.image = thumbnail;
        }
    }

}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
     userdefaults = [NSUserDefaults standardUserDefaults];
   
      
    videoPathstr = @"";
    tempvideoPathstr = @"";
    merged_video_number = 0;
    _HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    _HUD.delegate = self;
    [_HUD setLabelText:@"loading....."];
    
    NSError *err = nil;
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSFileManager* fm = [[NSFileManager alloc] init];
    NSDirectoryEnumerator* en = [fm enumeratorAtPath:path];
    NSError* errr = nil;
    BOOL res;
    NSString* file;
    while (file = [en nextObject]) {
            if ([file rangeOfString:@".sqlite"].location == NSNotFound) {
                res = [fm removeItemAtPath:[path stringByAppendingPathComponent:file] error:&errr];
                if (!res && err) {
                    NSLog(@"oops: %@", err);
                }
            }
     }
            filter_coverflag = false;
            process_closeflag = false;
            filter_clickable = true;
       
            bProcessing = YES;
            filterbtn_showhide = false;
            effectbtn_showhide = false;
            merged_video_checkflag = false;
    
            animation_count = 0;
            startpoint = CGPointMake(self.view.frame.size.height/2, 285);
            longclickpoint = CGPointMake(0, 0);
            center = CGPointMake(self.view.frame.size.height/2, 160);
            _selectimageview = [[GPUImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width)];
            
     
            [self.view addSubview:_selectimageview];
    
            // Do any additional setup after loading the view, typically from a nib.
            testimages = [[NSMutableArray alloc]init];
            testimages1 = [[NSMutableArray alloc]init];
            saveprojectarray = [[NSMutableArray alloc]init];
    
            self.movieController = [[MPMoviePlayerController alloc] init];
            [self.movieController.view setFrame:CGRectMake ( 0, 0, 0 , 0)];
            //    [self.movieController setRepeatMode:MPMovieRepeatModeOne];
            [self.view addSubview: self.movieController.view];

            if([_chooseproject isEqualToString:@"recordproject"])
            {
               
                NSArray *filePathsArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:NSTemporaryDirectory() error:NULL];
                filePathsArray = [filePathsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.mov'"]];
                NSLog(@"array=%@", filePathsArray);
               
                float seconds;
                for(int i=0;i<filePathsArray.count;i++)
                {
                    
                        NSString *stringUrl = [filePathsArray objectAtIndex:i];
                        NSLog(@"stringUrl=%@", stringUrl);
                        NSURL *vidURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent :stringUrl]];
                        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:vidURL options:nil];
                        CMTime video_time = [asset duration];
                        seconds = ceil(video_time.value/video_time.timescale);
                        AVAssetImageGenerator *generate = [[AVAssetImageGenerator alloc] initWithAsset:asset];
                
                        NSError *err = NULL;
                        CMTime time = CMTimeMake(1, 60);
                
                        CGImageRef imgRef = [generate copyCGImageAtTime:time actualTime:NULL error:&err];
                        UIImage *thumbnail = [UIImage imageWithCGImage:imgRef];
                        DragImageView *testimageview = [[DragImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
                        testimageview.image = thumbnail;
                
                        NSMutableDictionary *workingDictionary = [[NSMutableDictionary alloc] init];
                        [workingDictionary setObject:stringUrl forKey:@"real_url"];
                        [workingDictionary setObject:testimageview forKey:@"virtual_image"];
                        [workingDictionary setObject:@"ALAssetTypeVideo" forKey:@"url_type"];
                        [workingDictionary setObject:[NSString stringWithFormat:@"%f",seconds] forKey:@"video_duration"];
                        [workingDictionary setObject:@"" forKey:@"filter_url"];
                    
                
                        [testimages addObject:workingDictionary];
                        [saveprojectarray addObject:stringUrl];
                }
                
                
                [self projectsave];
        
            }
            else if([_chooseproject isEqualToString:@"createproject"])
            {
                NSArray* tmpDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:NSTemporaryDirectory() error:NULL];
                for (NSString *file in tmpDirectory) {
                    [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), file] error:NULL];
                }
                [self projectsave];
            }
            else if([_chooseproject isEqualToString:@"importproject"])
            {
                NSArray *videoarray = [userdefaults objectForKey:@"videolinkurl"];
                NSLog(@"oops: %@", videoarray);
        
                NSArray* tmpDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:NSTemporaryDirectory() error:NULL];
                BOOL othervideo_check;
                for (NSString *file in tmpDirectory) {
                    othervideo_check = false;
                    for(int i=0;i<videoarray.count;i++)
                {
                    if([file isEqualToString:[videoarray objectAtIndex:i]])
                    {
                        othervideo_check = false;
                        break;
                    }
                    else
                        othervideo_check = true;
                    }
                    if(othervideo_check)
                    {
                        [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), file] error:NULL];
                    }
                }
                
                float seconds;
        
                for(int i=0;i<videoarray.count;i++)
                {
                    NSString *stringUrl = [videoarray objectAtIndex:i];
                    NSURL *vidURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent :stringUrl]];
                    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:vidURL options:nil];
                    AVAssetImageGenerator *generate = [[AVAssetImageGenerator alloc] initWithAsset:asset];
            
                    NSError *err = NULL;
                    CMTime time = CMTimeMake(1, 60);
                    CMTime video_time = [asset duration];
                    seconds = ceil(video_time.value/video_time.timescale);
                    CGImageRef imgRef = [generate copyCGImageAtTime:time actualTime:NULL error:&err];
                    UIImage *thumbnail = [UIImage imageWithCGImage:imgRef];
                    DragImageView *testimageview = [[DragImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
                    testimageview.image = thumbnail;
            
                    NSMutableDictionary *workingDictionary = [[NSMutableDictionary alloc] init];
                    [workingDictionary setObject:stringUrl forKey:@"real_url"];
                    [workingDictionary setObject:testimageview forKey:@"virtual_image"];
                    [workingDictionary setObject:@"ALAssetTypeVideo" forKey:@"url_type"];
                    [workingDictionary setObject:[NSString stringWithFormat:@"%f",seconds] forKey:@"video_duration"];
                    [workingDictionary setObject:@"" forKey:@"filter_url"];
                    
                    [testimages addObject:workingDictionary];

                }
                
            }
            [self showImage];
             [_HUD hide:YES];
            
            trashimageview = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.height/2-35, self.view.frame.size.width/2-30, 70, 70)];
            [self.view addSubview:trashimageview];
            trashimageview.image = [UIImage imageNamed:@"trash_unable.png"];
            [self.view bringSubviewToFront:trashimageview];
    
            _backgroundview.alpha = 0.7;
            [self.view bringSubviewToFront:_backgroundview];
            [self.view bringSubviewToFront:_importbtn];
            [self.view bringSubviewToFront:_effectsbtn];
            [self.view bringSubviewToFront:_filtersbtn];
            [self.view bringSubviewToFront:_rightbackbtn];
            [self.view bringSubviewToFront:_leftbackbtn];
            [self.view bringSubviewToFront:_importmusicbtn];
            [self.view bringSubviewToFront:_remaintimelbl];
    
    
            // music import
            self.musicpicker = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeMusic];
            self.musicpicker.delegate						= self;
            self.musicpicker.allowsPickingMultipleItems	= YES;
            self.musicpicker.prompt						= NSLocalizedString (@"Add songs to play", "Prompt in media item picker");
            [self.musicpicker setAllowsPickingMultipleItems:NO];
    
            flowviewcheck[1] = 0;
            flowviewcheck[0] = 0;
            [self buttonsinit];
    
    
//        });
    
//      });
}

#pragma mark -Button Click events

- (IBAction)photochoose:(id)sender
{
    [self.movieController stop];
    [self processinginit];
    if (!self.assets)
        self.assets = [[NSMutableArray alloc] init];
    
    CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
    picker.assetsFilter         = [ALAssetsFilter allAssets];
    picker.showsCancelButton    = (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad);
    picker.delegate             = self;
//    picker.selectedAssets       = [NSMutableArray arrayWithArray:self.assets];
    
    
    [self presentViewController:picker animated:YES completion:nil];
}


- (IBAction)leftbtnevent:(id)sender
{
     [self.movieController stop];
    [self.movieController stop];
    if(process_closeflag)
        [_filterflowView scrollBackPage];
    else
    {
        [self processinginit];
        [_filterflowView removeFromSuperview];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)rightbtnevent:(id)sender
{
    [self.movieController stop];
    [self.movieController stop];
    if(process_closeflag)
        [_filterflowView scrollToNextPage];
    else
    {
        if(testimages.count==0)
        {
            UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"Error" message:@"You don't have any video now, please import videos and photos." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertview show];
        }
        else
        {
             NSLog(@"video_merge");
            [self processinginit];
            if([tempvideoPathstr isEqualToString:@""])
                {
                    if([videoPathstr isEqualToString:@""])
                        [self performSelectorInBackground:@selector(videosmerges) withObject:nil];
                    else
                    {
                        AVURLAsset* videoAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:videoPathstr] options:nil];
                        CMTime videoDuration = videoAsset.duration;
                        float videoDurationSeconds = CMTimeGetSeconds(videoDuration);
                        if(videoDurationSeconds>60)
                        {
                            NSString* message;
                            message = @"Video Length is over than 60 seconds, you can have only video within 60 seconds, please try again";
                            self.alert = [[UIAlertView alloc] initWithTitle:@"Done!"
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
                            [self.alert show];
                        }
                        else
                        {
                            [self.movieController stop];
                            UIStoryboard  *storyboard;
                            if(IS_IPHONE_5)
                                storyboard = [UIStoryboard storyboardWithName:@"Main"  bundle:nil];
                            else
                                storyboard = [UIStoryboard storyboardWithName:@"Main4"  bundle:nil];
                            VideoUploadController *uploadcontroller = [storyboard  instantiateViewControllerWithIdentifier:@"VideoUploadController"];
                            uploadcontroller.savefilestr = videoPathstr;
                            [self.navigationController pushViewController:uploadcontroller animated:YES];
                        }

                    }
            }
            else
            {
                [self.movieController stop];
                UIStoryboard  *storyboard;
                if(IS_IPHONE_5)
                    storyboard = [UIStoryboard storyboardWithName:@"Main"  bundle:nil];
                else
                    storyboard = [UIStoryboard storyboardWithName:@"Main4"  bundle:nil];
                VideoUploadController *uploadcontroller = [storyboard  instantiateViewControllerWithIdentifier:@"VideoUploadController"];
                uploadcontroller.savefilestr = tempvideoPathstr;
                [self.navigationController pushViewController:uploadcontroller animated:YES];
            }
        }
        
    }
}


- (IBAction)effectchoose:(id)sender
{
    
    [self.movieController stop];
    [self controlerhide];
    [_effectsbtn setEnabled:true];
    [_leftbackbtn setEnabled:true];
    [_rightbackbtn setEnabled:true];
    if(!effectbtn_showhide)
    {
        if(filter_clickable)               // when any filter is selected....
        {
            [self processinginit];
            effectbtn_showhide = true;
            filter_coverflag = true;
            process_closeflag = true;;
            _filterflowcurrentPage = 0;
            flowviewcheck[1] = 10;
            flowviewcheck[0] = 0;
            
            // flow view
            _filterflowView = [[SBPageFlowView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-self.view.frame.size.width/3-30, self.view.frame.size.height/2-60, self.view.frame.size.width-120, 120)];
            _filterflowView.delegate = self;
            _filterflowView.dataSource = self;
            _filterflowView.minimumPageAlpha = 0.9;
            _filterflowView.minimumPageScale = 0.8;
            [self.view addSubview:_filterflowView];
            _filterflowView.defaultImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"transfer1.png"]];
            [self.view bringSubviewToFront:_filterflowView];
            [_filterflowView reloadData];
            [_filterflowView genieOutTransitionWithDuration:animationtime startRect:CGRectMake(self.view.frame.size.width, self.view.frame.size.height/2, 0, 0) startEdge:BCRectEdgeLeft completion:
             ^{
             }];

        }
    }
    else
    {
        [self filterviewhide];
        [self controlershow];
        process_closeflag = false;
        effectbtn_showhide = false;
        filter_clickable = true;
    }
}


- (IBAction)filerchoose:(id)sender;
{
    [self.movieController stop];
    [self controlerhide];
    [_filtersbtn setEnabled:true];
    [_leftbackbtn setEnabled:true];
    [_rightbackbtn setEnabled:true];
   
    if(!filterbtn_showhide)
    {
        if(filter_clickable)                             // when any filter is selected....
        {
            [self processinginit];
            filterbtn_showhide = true;
            filter_coverflag = false;
            process_closeflag = true;                      // filter processing
            flowviewcheck[0] = 10;
            flowviewcheck[1] = 0;
            
            
            // flow view
            _filterflowView = [[SBPageFlowView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-self.view.frame.size.width/3-30, self.view.frame.size.height/2-60, self.view.frame.size.width-120, 120)];
            _filterflowView.delegate = self;
            _filterflowView.dataSource = self;
            _filterflowView.minimumPageAlpha = 0.9;
            _filterflowView.minimumPageScale = 0.8;
            [self.view addSubview:_filterflowView];
            _filterflowcurrentPage = 0;
            NSLog(@"test=%f", self.view.frame.size.height);
            _filterflowView.defaultImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"filter01.png"]];
           [self.view bringSubviewToFront:_filterflowView];
            [_filterflowView reloadData];
            [_filterflowView genieOutTransitionWithDuration:animationtime startRect:CGRectMake(self.view.frame.size.width, self.view.frame.size.height/2, 0, 0) startEdge:BCRectEdgeLeft completion:
             ^{
              }];
        }
    }
    else
    {
        [self filterviewhide];
        [self controlershow];
        process_closeflag = false;
        filterbtn_showhide = false;
    }
}

#pragma mark -
#pragma mark - Music merge

- (IBAction)musicmerge:(id)sender
{
    
    [self.movieController stop];
    if([tempvideoPathstr isEqualToString:@""])
    {
        if([videoPathstr isEqualToString:@""])
        {
            UIAlertView *alertview  = [[UIAlertView alloc]initWithTitle:@"Remember" message:@"Caution to do this all the clips will merged(fuzzing)" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
            alertview.tag = 3999;
            
            [alertview show];

        }
        else
        {
            [self processinginit];
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
            [self presentViewController:self.musicpicker animated:YES completion:^
             {
                 [self.musicpicker setNeedsStatusBarAppearanceUpdate];
                 
             }];
            music_flag = false;
        }
    }
    else
    {
        [self processinginit];
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        [self presentViewController:self.musicpicker animated:YES completion:^
        {
            [self.musicpicker setNeedsStatusBarAppearanceUpdate];
            
        }];
        music_flag = false;
    }

}

#pragma mark Media item picker delegate methods
- (void) mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
    
    NSString *tempPath = NSTemporaryDirectory();
    int i=1;
    for (MPMediaItem *theItem in mediaItemCollection.items) {
        NSURL *url = [theItem valueForProperty:MPMediaItemPropertyAssetURL];
        AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:url options:nil];
        AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset: songAsset presetName: AVAssetExportPresetPassthrough];
        exporter.outputFileType = @"com.apple.coreaudio-format";
        NSString *fname = @"music.caf";
        ++i;
        NSString *exportFile = [tempPath stringByAppendingPathComponent: fname];
        exporter.outputURL = [NSURL fileURLWithPath:exportFile];
        [exporter exportAsynchronouslyWithCompletionHandler:^{
            NSLog(@"done_done= %@", exportFile);
           
             dispatch_async(dispatch_get_main_queue(), ^(void){
                 UIStoryboard  *storyboard;
                 if(IS_IPHONE_5)
                     storyboard = [UIStoryboard storyboardWithName:@"Main"  bundle:nil];
                 else
                     storyboard = [UIStoryboard storyboardWithName:@"Main4"  bundle:nil];
                 MusicMergeController *musiccontroller = [storyboard instantiateViewControllerWithIdentifier:@"MusicMergeController"];
                 if([tempvideoPathstr isEqualToString:@""])
                     musiccontroller.videoPathstr = videoPathstr;
                 else
                     musiccontroller.videoPathstr = tempvideoPathstr;
                  musiccontroller.audiopathstr = [NSTemporaryDirectory() stringByAppendingPathComponent:fname];
                 [self.navigationController pushViewController:musiccontroller animated:YES];
                 [self processinginit];
                  [self.musicpicker dismissViewControllerAnimated:YES completion:Nil];
             });
        }];
    }
 }

-(void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    NSLog(@"Picker Canceled");
    [self.musicpicker dismissViewControllerAnimated:YES completion:Nil];
}


#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    filter_clickable = true;
    if(alertView.tag == 900 )
    {
         [_HUD hide:YES];
        if(buttonIndex == 1)
        {
            UIStoryboard  *storyboard;
            if(IS_IPHONE_5)
                storyboard = [UIStoryboard storyboardWithName:@"Main"  bundle:nil];
            else
                storyboard = [UIStoryboard storyboardWithName:@"Main4"  bundle:nil];
            VideoPreViewController *previewcontroller = [storyboard  instantiateViewControllerWithIdentifier:@"VideoPreViewController"];
            previewcontroller.videopathstr = tempvideoPathstr;
            [self.navigationController pushViewController:previewcontroller animated:YES];

        }

        
        for(int i =0;i<testimages.count;i++)
        {
            DragImageView *imageview = [[testimages objectAtIndex:i] objectForKey:@"virtual_image"];
            [imageview removeFromSuperview];
        }
        
            [testimages removeAllObjects];
            [testimages1 removeAllObjects];
            
            NSURL *vidURL = [NSURL fileURLWithPath:videoPathstr];
            AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:vidURL options:nil];
            CMTime video_time = [asset duration];
            float seconds = ceil(video_time.value/video_time.timescale);
            AVAssetImageGenerator *generate = [[AVAssetImageGenerator alloc] initWithAsset:asset];
            
            NSError *err = NULL;
            CMTime time = CMTimeMake(1, 60);
            
            CGImageRef imgRef = [generate copyCGImageAtTime:time actualTime:NULL error:&err];
        
            DragImageView *testimageview = [[DragImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
            testimageview.image = [UIImage imageWithCGImage:imgRef];
        
        
            NSMutableDictionary *workingDictionary = [[NSMutableDictionary alloc] init];
            [workingDictionary setObject:[NSString stringWithFormat:(@"merge_video%d.mp4"), (merged_video_number-1)] forKey:@"real_url"];
            [workingDictionary setObject:testimageview forKey:@"virtual_image"];
            [workingDictionary setObject:@"ALAssetTypeVideo" forKey:@"url_type"];
            [workingDictionary setObject:[NSString stringWithFormat:@"%f",seconds] forKey:@"video_duration"];
            [workingDictionary setObject:tempvideoPathstr forKey:@"filter_url"];
        
            [testimages addObject:workingDictionary];
            [self showImage];
         }
    if(alertView.tag == 1000 )
    {
        if(buttonIndex == 0)  exit(0);
    }
  
    if(alertView.tag == 1999)
    {
        if(buttonIndex ==1)
           [self fxfunction];
    }
    if(alertView.tag == 2999)
    {
        if(buttonIndex ==1)
          [self filterfunction];
    }
    if(alertView.tag == 3999)
    {
        if(buttonIndex ==1)
        {
            music_flag = true;
            filter_flag = false;
            fx_transition_flag = false;
            [self documentsempty];
            [self processinginit];
            [self performSelectorInBackground:@selector(videosmerges) withObject:nil];
        }
        else
            music_flag = false;
    }
    

}

- (void)filterfunction
{
    filter_flag = true;
    fx_transition_flag = false;
    music_flag = false;
    if([videoPathstr isEqualToString:@""])
    {
        [self processinginit];
       [self performSelectorInBackground:@selector(videosmerges) withObject:nil];
    }
    else
    {
        _HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        _HUD.delegate = self;
        [_HUD setLabelText:@"Processing..."];
        [self setFilter:fx_transition_index];
        [self preparevideofilter:videoPathstr];

    }
}

- (void)fxfunction
{
    fx_transition_flag = true;
    filter_flag = false;
    music_flag = false;
    if([videoPathstr isEqualToString:@""])
    {
        [self processinginit];
        [self performSelectorInBackground:@selector(videosmerges) withObject:nil];
    }
    else
    {
        _HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        _HUD.delegate = self;
        [_HUD setLabelText:@"Processing..."];
        [self setEffects:videoPathstr :fx_transition_index];
    }

}

- (void)filterviewhide
{
    filter_coverflag = false;
    [_filterflowView genieInTransitionWithDuration:animationtime destinationRect:CGRectMake(0, self.view.frame.size.height/2, 0, 0) destinationEdge:BCRectEdgeRight completion:
     ^{
         [_filterflowView removeFromSuperview];
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}

#pragma mark - Assets Picker Delegate
- (void)pickercontroller
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            for(int i=0;i<[self.assets count];i++)
            {
                videoPathstr = @"";
                tempvideoPathstr = @"";
                ALAsset *asset = [self.assets objectAtIndex:i];
                double remain_timevalue = [[asset valueForProperty:ALAssetPropertyDuration] doubleValue];
                if(remain_timevalue ==0.0)
                    remain_timevalue = 3.0;
                DragImageView *testimageview = [[DragImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
                testimageview.image = [UIImage imageWithCGImage:asset.thumbnail];
                NSString *video_url = [self videoAssetURLToTempFile:[asset valueForProperty:ALAssetPropertyAssetURL] selectimage:[UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]]];
                NSMutableDictionary *workingDictionary = [[NSMutableDictionary alloc] init];
                [workingDictionary setObject:testimageview forKey:@"virtual_image"];
                [workingDictionary setObject:video_url forKey:@"real_url"];
                [workingDictionary setObject:[NSString stringWithFormat:@"%f",remain_timevalue] forKey:@"video_duration"];
                [workingDictionary setObject:@"" forKey:@"filter_url"];
                [workingDictionary setObject:@"ALAssetTypeVideo" forKey:@"url_type"];
                
                
                NSLog(@"test=%@", [workingDictionary objectForKey:@"real_url"]);
                [testimages addObject:workingDictionary];
                
                [saveprojectarray addObject:video_url];
            }
            [self projectsave];
        });
        [NSThread sleepForTimeInterval:2.0f];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_HUD hide:YES];
            if (testimages.count > 0) {
                //        [self addGesture];
                [self showImage];
            }else{
                return;
            }
            
        });
    });
    
}


- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
  
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
     self.assets = [NSMutableArray arrayWithArray:assets];
    int total_count = (int)[self.assets count] + (int)[testimages count];
    
    if(total_count<21)
    {
        _HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        _HUD.delegate = self;
        [_HUD setLabelText:@"importing....."];
        [self performSelectorInBackground:@selector(pickercontroller) withObject:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Waring" message:@"You can only import 20 vidoes or images, please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

-(NSString *) videoAssetURLToTempFile:(NSURL*)url selectimage:(UIImage *)image
{
    BOOL photo_videoflag = NO;
    NSString * surl = [url absoluteString];
    NSString * ext = [surl substringFromIndex:[surl rangeOfString:@"ext="].location + 4];
    
    if([[ext uppercaseString] isEqualToString:@"JPG"])
    {
        NSString *myString = [url absoluteString];
        photo_videoflag = YES;
        myString = [myString stringByReplacingOccurrencesOfString:@"JPG"
                                                       withString:@"mp4"];
        url = [NSURL URLWithString:myString];
        surl = [url absoluteString];
        ext=@"mp4";
    }
    
    else if([[ext uppercaseString] isEqualToString:@"PNG"])
    {
        NSString *myString = [url absoluteString];
        photo_videoflag = YES;
        myString = [myString stringByReplacingOccurrencesOfString:@"PNG"
                                                       withString:@"mp4"];
        url = [NSURL URLWithString:myString];
        surl = [url absoluteString];
        ext=@"mp4";
    }
    
    
    NSString * testsurl = [surl substringFromIndex:[surl rangeOfString:@"id="].location + 3];
    NSString *str = [testsurl substringToIndex:[testsurl rangeOfString:@"&ext="].location];
    NSArray *Array = [str componentsSeparatedByString:@"."];
    NSString *fileString =[[NSString alloc]initWithString:[Array objectAtIndex:0]];
    
    NSString * filename = [NSString stringWithFormat: @"%@.%@",fileString,ext];;
    
    NSString * tmpfile = [NSTemporaryDirectory() stringByAppendingPathComponent:filename];
    NSLog(@"tempfileurl=%@",tmpfile);
    if(photo_videoflag)
    {
        UIImage *mixedimage;
        NSArray* testImageArray;
        if(image.size.height >image.size.width)
        {
            mixedimage = [UIImage mergeImage:[UIImage imageNamed:@"blackscreen.png"] withImage:image imagesize:self.view.frame.size];
            testImageArray = [[NSArray alloc] initWithObjects:
                              mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,mixedimage,
                              nil];
        }
        else
            testImageArray = [[NSArray alloc] initWithObjects:
                                   image,image,image,image,image,image,image,image,image,image,image,image,image,image,image,image,
                                   image,image,image,image,image,image,image,image,image,image,image,image,image,image,image,image,
                                   image,image,image,image,image,image,image,image,image,image,image,image,image,image,image,image,
                                   image,image,image,image,image,image,image,image,image,image,image,image,image,image,image,image,
                                   image,image,image,image,image,image,image,image,
                                   nil];
        photo_videoflag = NO;
        CGSize videosize = CGSizeMake(1136, 720);;
        
        [self writeImageAsMovie:testImageArray toPath:tmpfile size:videosize duration:1];
        
    }
    else
    {
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
        {
            
            ALAssetRepresentation * rep = [myasset defaultRepresentation];
            NSUInteger size = [rep size];
            const int bufferSize = 8192;
            
            
            //NSLog(@"Writing to %@",tmpfile);
            FILE* f = fopen([tmpfile cStringUsingEncoding:1], "wb+");
            if (f == NULL) {
                NSLog(@"Can not create tmp file.");
                return;
            }
            Byte * buffer = (Byte*)malloc(bufferSize);
            int read = 0, offset = 0, written = 0;
            NSError* err;
            if (size != 0) {
                do {
                    read = [rep getBytes:buffer
                              fromOffset:offset
                                  length:bufferSize
                                   error:&err];
                    written = fwrite(buffer, sizeof(char), read, f);
                    offset += read;
                } while (read != 0);
            }
            fclose(f);
        };
        
        ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
        {
            NSLog(@"Can not get asset - %@",[myerror localizedDescription]);
        };
        
        if(url)
        {
            ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
            [assetslibrary assetForURL:url
                           resultBlock:resultblock
                          failureBlock:failureblock];
        }
        
        
    }
    
    return filename;
}

-(void)writeImageAsMovie:(NSArray *)array toPath:(NSString*)path size:(CGSize)size duration:(float)duration
{
    [[NSFileManager defaultManager] removeItemAtPath:path error: nil];
    
    NSError *error = nil;
    AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:path]
                                                           fileType:AVFileTypeQuickTimeMovie
                                                              error:&error];
    NSParameterAssert(videoWriter);
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                   AVVideoCodecH264, AVVideoCodecKey,
                                   [NSNumber numberWithInt:size.width], AVVideoWidthKey,
                                   [NSNumber numberWithInt:size.height], AVVideoHeightKey,
                                   nil];
    AVAssetWriterInput* writerInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo
                                                                         outputSettings:videoSettings] ;
    AVAssetWriterInputPixelBufferAdaptor *adaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput
                                                                                                                     sourcePixelBufferAttributes:nil];
    NSParameterAssert(writerInput);
    NSParameterAssert([videoWriter canAddInput:writerInput]);
    [videoWriter addInput:writerInput];
    //Start a session:
    [videoWriter startWriting];
    [videoWriter startSessionAtSourceTime:kCMTimeZero];
    CVPixelBufferRef buffer = NULL;
    
    //UIImage* im =[UIImage imageWithContentsOfFile:[array objectAtIndex:0]];
    buffer = [self pixelBufferFromCGImage:[[array objectAtIndex:0] CGImage] size:size];
    CVPixelBufferPoolCreatePixelBuffer (NULL, adaptor.pixelBufferPool, &buffer);
    
    // [adaptor appendPixelBuffer:buffer withPresentationTime:kCMTimeZero];
    UIImage* im = [self resizeImage:[array objectAtIndex:0] toSize:size];
    int i = 1;
    while (1)
    {
		if(writerInput.readyForMoreMediaData){
			CMTime frameTime = CMTimeMake(1, 24);
			CMTime lastTime=CMTimeMake(i, 24);
			CMTime presentTime=CMTimeAdd(lastTime, frameTime);
			if (i >= [array count])
			{
				buffer = NULL;
			}
			else
			{
                
                CVPixelBufferRelease(buffer);
                buffer = [self pixelBufferFromCGImage:[im CGImage] size:size];
			}
			if (buffer)
			{
				// append buffer
				[adaptor appendPixelBuffer:buffer withPresentationTime:presentTime];
				i++;
            }
			else
			{
				//Finish the session:
				[writerInput markAsFinished];
                //If change to fininshWritingWith... Cause Zero bytes file. I'm Trying to fix.
				[videoWriter finishWriting];
                
				CVPixelBufferPoolRelease(adaptor.pixelBufferPool);
				NSLog (@"Done");
				break;
			}
		}
    }
}


-(CVPixelBufferRef) pixelBufferFromCGImage: (CGImageRef) image  size:(CGSize)imageSize
{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             nil];
    CVPixelBufferRef pxbuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, imageSize.width,
                                          imageSize.height, kCVPixelFormatType_32ARGB, (__bridge CFDictionaryRef) options,
                                          &pxbuffer);
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata, imageSize.width,
                                                 imageSize.height, 8, 4*imageSize.width, rgbColorSpace,
                                                 kCGImageAlphaNoneSkipFirst);
    NSParameterAssert(context);
    //    CGContextConcatCTM(context, frameTransform);
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image),
                                           CGImageGetHeight(image)), image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}

-(UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 1);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}



- (void)showImage{
    
    if(testimages.count>0)
    {
        CGFloat fRadina;
        video_all_time = 0.0f;
        average_radina = 2*M_PI/testimages.count;
        DragImageView *dragImageView = [[testimages objectAtIndex:0] objectForKey:@"virtual_image"];
        CGFloat width = dragImageView.frame.size.height;
        CGFloat heigh = dragImageView.frame.size.width;
        //计算半径
        radius = MIN(self.view.frame.size.width-width-30, self.view.frame.size.height-heigh-30)/2.0;
//         radius = MIN(self.view.frame.size.height-heigh-30, self.view.frame.size.width-width-30)/2.0;
        for (int i=0; i<testimages.count; i++) {
            fRadina = [self getRadinaByRadian:i*average_radina];
            CGPoint point = [self getPointByRadian:fRadina centreOfCircle:center radiusOfCircle:radius];
            NSLog(@"pointx =%f",point.x);
            NSLog(@"pointy =%f",point.y);
            testdictionary = [testimages objectAtIndex:i];
            DragImageView *imageview = [testdictionary objectForKey:@"virtual_image"];
            video_all_time = video_all_time + [[testdictionary objectForKey:@"video_duration"] floatValue];
            imageview.center = CGPointMake(point.x, point.y);
            imageview.layer.cornerRadius = 20;
            imageview.clipsToBounds = YES;
            imageview.current_index = i;
            imageview.current_radian = fRadina;
            imageview.radian = fRadina;
            imageview.tag = i;
            imageview.view_point = point;
            imageview.lng_view_point = point;
            imageview.current_animation_radian = [self getAnimationRadianByRadian:fRadina];
            imageview.userInteractionEnabled = YES;
            imageview.animation_radian = [self getAnimationRadianByRadian:fRadina];
            [self.view addSubview:imageview];
            
            if(CGPointEqualToPoint(imageview.center, startpoint))
            {
                if([[testdictionary objectForKey:@"url_type"] isEqualToString:@"ALAssetTypeVideo"])
                {
                
                    [self setFilter:(int)index];
                    if([[testdictionary objectForKey:@"filter_url"] isEqualToString:@""])
                        [self preshoweffects:[NSTemporaryDirectory() stringByAppendingPathComponent:[testdictionary objectForKey:@"real_url"]]];
                    else
                        [self preshoweffects:[testdictionary objectForKey:@"filter_url"]];
                }
            }
        
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(dragtest:)];
        
            longPress.delegate = self;
            [imageview addGestureRecognizer:longPress];
        
            UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSinglePan:)];
            panGesture.delegate = self;
        
            [imageview addGestureRecognizer:panGesture];
        
            UITapGestureRecognizer *double_tap_recognizer;
            double_tap_recognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector (doubleclick_videoclip:)];
            double_tap_recognizer.delegate = self;
            double_tap_recognizer.numberOfTapsRequired = 2;
            [imageview addGestureRecognizer:double_tap_recognizer];
        
            [panGesture requireGestureRecognizerToFail: double_tap_recognizer];
        }
        int videotime = (int)ceilf(video_all_time );
        [_remaintimelbl setText:[self timeFormatted:videotime]];
        [self buttonsinit];
    }   
}

- (NSString *)timeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}


- (IBAction)doubleclick_videoclip:(UITapGestureRecognizer *)index
{
    [self processinginit];
    [self.movieController stop];
    
    NSLog(@"gesture id is %ld", (long)index.view.tag);
    UIStoryboard  *storyboard;
    if(IS_IPHONE_5)
        storyboard = [UIStoryboard storyboardWithName:@"Main"  bundle:nil];
    else
        storyboard = [UIStoryboard storyboardWithName:@"Main4"  bundle:nil];
    VideoClipEditController *clipeditviewcontroller = [storyboard instantiateViewControllerWithIdentifier:@"VideoClipEditController"];
  if([tempvideoPathstr isEqualToString:@""])
  {
    if([videoPathstr isEqualToString:@""])
       clipeditviewcontroller.videopathstr = [NSTemporaryDirectory() stringByAppendingPathComponent:[[testimages objectAtIndex:index.view.tag] objectForKey:@"real_url"]];
    else
        clipeditviewcontroller.videopathstr = videoPathstr;
  }
  else
  {
      clipeditviewcontroller.videopathstr = tempvideoPathstr;
  }
   [self.navigationController pushViewController:clipeditviewcontroller animated:YES];

}

- (void) trashiconchange: (UIImageView *)imageview
{
    if(CGRectContainsPoint(trashimageview.frame, imageview.center))
         trashimageview.image = [UIImage imageNamed:@"trash.png"];
    else
        trashimageview.image = [UIImage imageNamed:@"trash_unable.png"];
}

- (void)dragtest:(UILongPressGestureRecognizer *)sender
{
    if(!process_closeflag)
    {
        [self.movieController stop];
        testdictionary = [testimages objectAtIndex:sender.view.tag];
        DragImageView *imageview = [testdictionary objectForKey:@"virtual_image"];
    
        swiperect = imageview.frame;
      
        CGPoint point = [sender locationInView:self.view];
    
        switch (sender.state) {
            case UIGestureRecognizerStateBegan:
                [imageview setAlpha:0.7];
                lastPoint = point;
                [imageview.layer setShadowColor:[UIColor grayColor].CGColor];
                [imageview.layer setShadowOpacity:1.0f];
                [imageview.layer setShadowRadius:10.0f];
                [self startShake:imageview];
                break;
            case UIGestureRecognizerStateChanged:
            {
                [self trashiconchange:imageview];
                float offX = point.x - lastPoint.x;
                float offY = point.y - lastPoint.y;
                [imageview setCenter:CGPointMake(imageview.center.x + offX, imageview.center.y + offY)];
                [self setLastCenter:CGPointMake(0, 0)];
            
            }
                lastPoint = point;
                [self checkLocationOfOthersWithButton:imageview];
                break;
            case UIGestureRecognizerStateEnded:
            {
                if(CGRectContainsPoint(trashimageview.frame, imageview.center))
                {
                    [testimages removeObject:testdictionary];
                    [imageview removeFromSuperview];
                    
                
                    videoPathstr = @"";
                    tempvideoPathstr = @"";
                    
                    [UIView animateWithDuration:.5 animations:^{
                    if(testimages.count>0)
                        [self showImage];
                    } completion:^(BOOL finished) {
                        [imageview.layer setShadowOpacity:0];
                    }];
                    [self buttonsinit];
                
                }
                else
                {
                    [self stopShake:imageview];
                    [imageview setAlpha:1];
                
                    [UIView animateWithDuration:.5 animations:^{
                        [imageview setCenter:imageview.lng_view_point];
                        [testimages1 removeAllObjects];
                        int count = 0;
                        while(count<testimages.count)
                        {
                            for(int i=0;i<testimages.count;i++)
                            {
                                testdictionary = [testimages objectAtIndex:i];
                                DragImageView *testimageview = [testdictionary objectForKey:@"virtual_image"];
                                if(count == testimageview.current_index)
                                {
                                    [testimages1 addObject:testdictionary];
                                    break;
                                }
                             }
                            count++;
                        }
                        [testimages removeAllObjects];
                        [self reshowImage];
                    
                    } completion:^(BOOL finished) {
                        [imageview.layer setShadowOpacity:0];
                    }];
                
                }
                longclickpoint = CGPointMake(0, 0);
            }
                break;
            case UIGestureRecognizerStateCancelled:
                [self stopShake:imageview];
                [imageview setAlpha:1];
                break;
            case UIGestureRecognizerStateFailed:
                [self stopShake:imageview];
                [imageview setAlpha:1];
                break;
            default:
                break;
        }
    }
}


- (void)reshowImage{

    CGFloat fRadina;
    video_all_time = 0.0f;
    average_radina = 2*M_PI/testimages1.count;
    testdictionary = [testimages1 objectAtIndex:0];
    DragImageView *dragImageView = [testdictionary objectForKey:@"virtual_image"];
    
    CGFloat width = dragImageView.frame.size.width;
    CGFloat heigh = dragImageView.frame.size.height;
    [saveprojectarray removeAllObjects];
    //计算半径
    radius = MIN(self.view.frame.size.width-width-30, self.view.frame.size.height-heigh-30)/2.0;
    for (int i=0; i<testimages1.count; i++) {
        fRadina = [self getRadinaByRadian:i*average_radina];
        CGPoint point = [self getPointByRadian:fRadina centreOfCircle:center radiusOfCircle:radius];
     
        testdictionary = [testimages1 objectAtIndex:i];
        video_all_time = video_all_time + [[testdictionary objectForKey:@"video_duration"] floatValue];
        DragImageView *imageview = [testdictionary objectForKey:@"virtual_image"];
        imageview.center = point;
        imageview.current_index = i;
        imageview.current_radian = fRadina;
        imageview.radian = fRadina;
        imageview.tag = i;
        imageview.view_point = point;
        imageview.lng_view_point = point;
        imageview.current_animation_radian = [self getAnimationRadianByRadian:fRadina];
        imageview.userInteractionEnabled = YES;
        imageview.animation_radian = [self getAnimationRadianByRadian:fRadina];
        [testimages addObject:testdictionary];
        
        [saveprojectarray addObject:[testdictionary objectForKey:@"real_url"]];
        if(CGPointEqualToPoint(imageview.center, startpoint))
        {
            if([[testdictionary objectForKey:@"url_type"] isEqualToString:@"ALAssetTypeVideo"])
            {
                
                [self setFilter:(int)index];
                if([[testdictionary objectForKey:@"filter_url"] isEqualToString:@""])
                    [self preshoweffects:[NSTemporaryDirectory() stringByAppendingPathComponent:[testdictionary objectForKey:@"real_url"]]];
                else
                    [self preshoweffects:[testdictionary objectForKey:@"filter_url"]];
                
            }
            
            
        }
        
    }
    int videotime = (int)ceilf(video_all_time );
    [_remaintimelbl setText:[self timeFormatted:videotime]];
    [self projectsave];
    [self buttonsinit];
}

- (void)projectsave
{
    if(!merged_video_checkflag)
    {
        [userdefaults setObject:saveprojectarray forKey:@"videolinkurl"];
        [userdefaults synchronize];
    }
}

- (void)checkLocationOfOthersWithButton:(DragImageView *)shakingimageview
{
    int indexOfShakingButton = 0;
    
    for ( int i = 0; i < [testimages count]; i++) {
        testdictionary = [testimages objectAtIndex:i];
        DragImageView *imageviewcm = [testdictionary objectForKey:@"virtual_image"];
        if (imageviewcm.tag == shakingimageview.tag) {
            indexOfShakingButton = i;
            break;
        }
    }
    for (int i = 0; i < [testimages count]; i++) {
        testdictionary = [testimages objectAtIndex:i];
        DragImageView *imageview = [testdictionary objectForKey:@"virtual_image"];
        if (imageview.tag != shakingimageview.tag){
            if (CGRectIntersectsRect(shakingimageview.frame, imageview.frame)) {
                [UIView animateWithDuration:0.4 animations:^{
                    swap_position = (int)imageview.current_index;
                    imageview.center = shakingimageview.lng_view_point;
                    imageview.current_index = shakingimageview.current_index;
                    longclickpoint = imageview.lng_view_point;
                    imageview.lng_view_point = imageview.center;
                    shakingimageview.lng_view_point = longclickpoint;
                    shakingimageview.current_index = swap_position;
                    
                }];
                break;
            }
        }
    }
    
}

- (void)startShake:(UIImageView*)imageview
{
    CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    shakeAnimation.duration = 0.08;
    shakeAnimation.autoreverses = YES;
    shakeAnimation.repeatCount = MAXFLOAT;
    shakeAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(imageview.layer.transform, -0.1, 0, 0, 1)];
    shakeAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(imageview.layer.transform, 0.1, 0, 0, 1)];
    
    [imageview.layer addAnimation:shakeAnimation forKey:@"shakeAnimation"];
}

- (void)stopShake:(UIImageView*)imageview
{
    [imageview.layer removeAnimationForKey:@"shakeAnimation"];
}



- (CGFloat)getRadinaByRadian:(CGFloat)radian
{
    if(radian > 2 * M_PI)
        return (radian - floorf(radian / (2.0f * M_PI)) * 2.0f * M_PI);
    
    if(radian < 0.0f)
        return (2.0f * M_PI + radian - ceilf(radian / (2.0f * M_PI)) * 2.0f * M_PI);
    
    return radian;
}


- (CGPoint)getPointByRadian:(CGFloat)radian centreOfCircle:(CGPoint)circle_point radiusOfCircle:(CGFloat)circle_radius
{
    CGFloat c_x = sinf(radian) * circle_radius + circle_point.x;
    CGFloat c_y = cosf(radian) * circle_radius + circle_point.y;
    
    return CGPointMake(c_x, c_y);
}

- (CGFloat)getAnimationRadianByRadian:(CGFloat)radian
{
    
    CGFloat an_r = 2.0f * M_PI -  radian + M_PI_2;
    
    if(an_r < 0.0f)
        an_r =  - an_r;
    
    return an_r;
}

- (void)addGesture{
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSinglePan:)];
    panGesture.delegate = self;
    [self.view addGestureRecognizer:panGesture];
    
}

- (void)handleSinglePan:(id)sender{
   [self processinginit];
    if(!process_closeflag)
    {
        [self.movieController stop];
        UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *)sender;
        switch (panGesture.state) {
            case UIGestureRecognizerStateBegan:
            {
                pointDrag = [panGesture locationInView:self.view];
            }
                break;
            case UIGestureRecognizerStateChanged:
            {
                CGPoint pointMove = [panGesture locationInView:self.view];
                [self dragPoint:pointDrag movePoint:pointMove centerPoint:center];
                pointDrag = pointMove;
            }
                break;
            case UIGestureRecognizerStateEnded:
            {
                CGPoint pointMove = [panGesture locationInView:self.view];
                [self dragPoint:pointDrag movePoint:pointMove centerPoint:center];
                [self reviseCirclePoint];
            }
                break;
            case UIGestureRecognizerStateFailed:
            {
                CGPoint pointMove = [panGesture locationInView:self.view];
                [self dragPoint:pointDrag movePoint:pointMove centerPoint:center];
                [self reviseCirclePoint];
            }
                break;
            
            default:
                break;
        }
    }
}


- (void)startimage
{
    
    int beginpoint = 0;
    [testimages1 removeAllObjects];
    for (int i=0;i<testimages.count;i++)
    {
        testdictionary = [testimages objectAtIndex:i];
        DragImageView *imageview = [testdictionary objectForKey:@"virtual_image"];
        if(CGPointEqualToPoint(imageview.center, startpoint))
        {
            beginpoint = i;
            break;
        }
    }
    
    for(int j=beginpoint;j<testimages.count;j++)
    {
        testdictionary = [testimages objectAtIndex:j];
        [testimages1 addObject:testdictionary];
    }
    
    for(int k=0;k<beginpoint;k++)
    {
        testdictionary = [testimages objectAtIndex:k];
        
        [testimages1 addObject:testdictionary];
    }
    [testimages removeAllObjects];
    [self reshowImage];
}


- (void)dragPoint:(CGPoint)dragPoint movePoint:(CGPoint)movePoint centerPoint:(CGPoint)centerPoint{
    CGFloat drag_radian   = [self schAtan2f:dragPoint.x - centerPoint.x theB:dragPoint.y - centerPoint.y];
    
    CGFloat move_radian   = [self schAtan2f:movePoint.x - centerPoint.x theB:movePoint.y - centerPoint.y];
    
    CGFloat change_radian = (move_radian - drag_radian);
    for (int i=0; i<testimages.count; i++) {
        testdictionary = [testimages objectAtIndex:i];
        DragImageView *imageview = [testdictionary objectForKey:@"virtual_image"];
        imageview.center = [self getPointByRadian:(imageview.current_radian+change_radian) centreOfCircle:center radiusOfCircle:radius];
        
        imageview.current_radian = [self getRadinaByRadian:imageview.current_radian + change_radian];;
        imageview.current_animation_radian = [self getAnimationRadianByRadian:imageview.current_radian];
    }
}


- (CGFloat)schAtan2f:(CGFloat)a theB:(CGFloat)b
{
    CGFloat rd = atan2f(a,b);
    
    if(rd < 0.0f)
        rd = M_PI * 2 + rd;
    
    return rd;
}

- (void)reviseCirclePoint{
    BOOL isClockwise;
    testdictionary = [testimages objectAtIndex:0];
    DragImageView *imageviewFirst = [testdictionary objectForKey:@"virtual_image"];
    
    CGFloat temp_value = [self getRadinaByRadian:imageviewFirst.current_radian]/average_radina;
    
    NSInteger iCurrent = (NSInteger)(floorf(temp_value));
    temp_value = temp_value - floorf(temp_value);
    
    step = iCurrent;
    if (temp_value > 0.5f) {
        isClockwise = NO;
        step ++;
    }else{
        isClockwise = YES;
    }
    
    for (int i=0; i<testimages.count; i++) {
        NSInteger iDest = i+step;
        if (iDest >= testimages.count) {
            iDest = iDest%testimages.count;
        }
        [self animateWithDuration:0.25f * (temp_value/average_radina)  animateDelay:0.0f changeIndex:i toIndex:iDest circleArray:testimages clockwise:isClockwise];
    }
    
}

//平衡动画
- (void)animateWithDuration:(CGFloat)time animateDelay:(CGFloat)delay changeIndex:(NSInteger)change_index toIndex:(NSInteger)to_index circleArray:(NSMutableArray *)array clockwise:(BOOL)is_clockwise{
    
    
    DragImageView *change_cell = [[array objectAtIndex:change_index] objectForKey:@"virtual_image"];
    DragImageView *to_cell = [[array objectAtIndex:to_index] objectForKey:@"virtual_image"];
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:[NSString stringWithFormat:@"position"]];
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL,change_cell.layer.position.x,change_cell.layer.position.y);
    
    int clockwise = is_clockwise?0:1;
    
	CGPathAddArc(path,nil,
                 center.x, center.y,
                 radius,
                 change_cell.current_animation_radian, to_cell.animation_radian,
                 clockwise
                 );
	animation.path = path;
	CGPathRelease(path);
    animation.fillMode            = kCAFillModeForwards;
	animation.repeatCount         = 1;
    animation.removedOnCompletion = NO;
 	animation.calculationMode     = @"paced";
    
    
    CAAnimationGroup *anim_group  = [CAAnimationGroup animation];
    anim_group.animations          = [NSArray arrayWithObjects:animation, nil];
    anim_group.duration            = time + delay;
    anim_group.delegate            = self;
    anim_group.fillMode            = kCAFillModeForwards;
    anim_group.removedOnCompletion = NO;
    
    [change_cell.layer addAnimation:anim_group forKey:[NSString stringWithFormat:@"anim_group_%ld",(long)change_index]];
    
    
    change_cell.current_animation_radian = to_cell.animation_radian;
    change_cell.current_radian           = to_cell.radian;
}

- (void) buttonsinit{
    if ([testimages count]==0) {
        _remaintimelbl.text = @"00:00";
        [_importbtn setEnabled:true];
        [_importmusicbtn setEnabled:false];
        [_effectsbtn setEnabled:false];
        [_filtersbtn setEnabled:false];
        [_leftbackbtn setEnabled:true];
        [_rightbackbtn setEnabled:false];
        [self processinginit];
        [_selectimageview setHidden:YES];
    }
    else
    {
        [_selectimageview setHidden:NO];
        if(!effectbtn_showhide && !filterbtn_showhide)
            [self controlershow];
        trashimageview.image = [UIImage imageNamed:@"trash_unable.png"];
    }
    
}

#pragma mark -
#pragma mark - animation delegate

- (void)animationDidStart:(CAAnimation *)anim
{
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    animation_count ++;
    
    for (int i = 0; i < testimages.count; ++i)
    {
        NSInteger iDest = i+step;
        if (iDest >= testimages.count) {
            iDest = iDest%testimages.count;
        }
        
        testdictionary = [testimages objectAtIndex:i];
        DragImageView *change_cell = [testdictionary objectForKey:@"virtual_image"];
        testdictionary = [testimages objectAtIndex:iDest];
        DragImageView *to_cell     = [testdictionary objectForKey:@"virtual_image"];
        [change_cell.layer removeAllAnimations];
        
        change_cell.center    = to_cell.view_point;
        change_cell.lng_view_point = to_cell.view_point;
        
    }
    
    if(animation_count == testimages.count)
    {
        [self startimage];
        animation_count = 0;
    }
    
}


#pragma mark - PagedFlowView Datasource

- (NSInteger)numberOfPagesInFlowView:(SBPageFlowView *)flowView{
    int index=0;
    for(int i =0;i<2;i++)
    {
        if(flowviewcheck[i] == 10)
        {
            index = i;
            break;
        }
    }
    if(index == 0)
    {
        NSLog(@"test = %lu", (unsigned long)[_filterflowimageArray count]);
        return [_filterflowimageArray count];
    }
    else
    {
        NSLog(@"test = %lu", (unsigned long)[_effectflowimageArray count]);
        return [_effectflowimageArray count];
    }
}

- (CGSize)sizeForPageInFlowView:(SBPageFlowView *)flowView;{
    return CGSizeMake(150, 120);
}


- (UIView *)flowView:(SBPageFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    UIImageView *imageView = (UIImageView *)[flowView dequeueReusableCell];
    if (!imageView) {
        imageView = [[UIImageView alloc] init];
        imageView.layer.masksToBounds = YES;
    }
    
    int flowviewindex=0;
    for(int i =0;i<2;i++)
    {
        if(flowviewcheck[i] == 10)
        {
            flowviewindex = i;
            break;
        }
    }

    imageView.layer.cornerRadius = 10;
    imageView.clipsToBounds = YES;
    if(flowviewindex == 0)
        imageView.image = [UIImage imageNamed:[_filterflowimageArray objectAtIndex:index]];
    else
        imageView.image = [UIImage imageNamed:[_effectflowimageArray objectAtIndex:index]];
    return imageView;
}

#pragma mark - PagedFlowView Delegate
- (void)didReloadData:(UIView *)cell cellForPageAtIndex:(NSInteger)index
{
    UIImageView *imageView = (UIImageView *)cell;
    int flowviewindex=0;
    for(int i =0;i<2;i++)
    {
        if(flowviewcheck[i] == 10)
        {
            flowviewindex = i;
            break;
        }
    }
    if(flowviewindex == 0)
        imageView.image = [UIImage imageNamed:[_filterflowimageArray objectAtIndex:index]];
    else
        imageView.image = [UIImage imageNamed:[_effectflowimageArray objectAtIndex:index]];
   
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(SBPageFlowView *)flowView {
    NSLog(@"Scrolled to page # %ld", (long)pageNumber);
    _currentPage = pageNumber;
}

- (void)didSelectItemAtIndex:(NSInteger)index inFlowView:(SBPageFlowView *)flowView
{
     NSLog(@"didSelectItemAtIndex: %ld", (long)index);
    testdictionary = [testimages objectAtIndex:0];
    
     filter_clickable = false;
    
    if(!filter_coverflag)                                 // when user choose filter
    {
        fx_transition_index = (int) index;
        if([videoPathstr isEqualToString:@""])
        {
            UIAlertView *alertview  = [[UIAlertView alloc]initWithTitle:@"Remember" message:@"Caution to do this all the clips will merged(fuzzing)" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
            alertview.tag = 2999;
            
            [alertview show];
        }
        else
        {
           [self filterfunction];
        }
    }
    else                                                  // when user choose effect or fx
    {
        if(_effectflowimageArray.count == 11 && index == 10)                      // in app purchase
        {
            [self processinginit];
            UIStoryboard  *storyboard;
            if(IS_IPHONE_5)
                storyboard = [UIStoryboard storyboardWithName:@"Main"  bundle:nil];
            else
                storyboard = [UIStoryboard storyboardWithName:@"Main4"  bundle:nil];
            VideoIapViewController *iapviewcontroller = [storyboard  instantiateViewControllerWithIdentifier:@"VideoIapViewController"];
            [self.navigationController pushViewController:iapviewcontroller animated:YES];
            
        }
        else if(_effectflowimageArray.count == 21 && index == 20)                 // in app purchase
        {
           [self processinginit];
            UIStoryboard  *storyboard;
            if(IS_IPHONE_5)
                storyboard = [UIStoryboard storyboardWithName:@"Main"  bundle:nil];
            else
                storyboard = [UIStoryboard storyboardWithName:@"Main4"  bundle:nil];
            VideoIapViewController *iapviewcontroller = [storyboard  instantiateViewControllerWithIdentifier:@"VideoIapViewController"];
            [self.navigationController pushViewController:iapviewcontroller animated:YES];
        }
        else if(_effectflowimageArray.count == 31 && index == 30)                 // in app purchase
        {
            [self processinginit];
            UIStoryboard  *storyboard;
            if(IS_IPHONE_5)
                storyboard = [UIStoryboard storyboardWithName:@"Main"  bundle:nil];
            else
                storyboard = [UIStoryboard storyboardWithName:@"Main4"  bundle:nil];
            VideoIapViewController *iapviewcontroller = [storyboard  instantiateViewControllerWithIdentifier:@"VideoIapViewController"];
            [self.navigationController pushViewController:iapviewcontroller animated:YES];
        }

        else
        {
            fx_transition_index = (int) index;
            if([videoPathstr isEqualToString:@""])
            {
                UIAlertView *alertview  = [[UIAlertView alloc]initWithTitle:@"Remember" message:@"Caution to do this all the clips will merged(fuzzing)" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
                alertview.tag = 1999;
            
                [alertview show];
            }
            else
                [self fxfunction];
       }
    }
}


#pragma mark -
#pragma mark - image and video filter processing

- (void)preshoweffects:(NSString*)urlstr
{
    NSLog(@"url=%@", urlstr);
    if([[NSFileManager defaultManager] fileExistsAtPath:urlstr])
    {
        bProcessing = YES;
        
        orgmovieUrl = [NSURL fileURLWithPath:urlstr];
        
        [self processinginit];
        
        [self.movieController stop];
        [self.movieController setContentURL:orgmovieUrl];
        [self.movieController play];
        
        orgmoviefilerFile = [[GPUImageMovie alloc] initWithURL:orgmovieUrl];
        photofilter = [[GPUImageFilter alloc] init];
        
        orgmoviefilerFile.runBenchmark = YES;
        orgmoviefilerFile.playAtActualSpeed = YES;
        orgmoviefilerFile.shouldRepeat = NO;
        
        [orgmoviefilerFile addTarget:photofilter];
        [photofilter addTarget:_selectimageview];
        
        [orgmoviefilerFile startProcessing];
    }
    else
    {
        UIAlertView *filteralert = [[UIAlertView alloc]initWithTitle:@"Alarm" message:@"Can not find this video now, please try again after." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [filteralert show];
    }
}


- (void)preparevideofilter:(NSString*)urlstr
{
    bProcessing = YES;
    orgmovieUrl = [NSURL fileURLWithPath:urlstr];
    
    [self processinginit];
    [photofilter removeAllTargets];
  
    orgmoviefilerFile = [[GPUImageMovie alloc] initWithURL:orgmovieUrl];
    
    orgmoviefilerFile.runBenchmark = YES;
    orgmoviefilerFile.playAtActualSpeed = YES;
    orgmoviefilerFile.shouldRepeat = YES;
    
    [orgmoviefilerFile addTarget:photofilter];
    [photofilter addTarget:_selectimageview];
    
    
    tempvideoPathstr = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:(@"tmp/tempmerge_video%d.mp4"), (merged_video_number-1)]];
    
    NSString *pathToMovie = tempvideoPathstr;
    unlink([pathToMovie UTF8String]);
    
    if([[NSFileManager defaultManager] fileExistsAtPath:pathToMovie])
    {
        [[NSFileManager defaultManager] removeItemAtPath:pathToMovie error:nil];
        
    }

    exportURL = [NSURL fileURLWithPath:pathToMovie];
    moviefilterWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:exportURL size:CGSizeMake(1280.0, 720.0)];
    [photofilter addTarget:moviefilterWriter];
    moviefilterWriter.shouldPassthroughAudio = YES;
    
    AVAsset *anAsset = [AVAsset assetWithURL:orgmovieUrl ];
    if ([[anAsset tracksWithMediaType:AVMediaTypeAudio] count] > 0){
        
        orgmoviefilerFile.audioEncodingTarget = moviefilterWriter;
        NSLog(@"music sound");
    } else {//no audio
        orgmoviefilerFile.audioEncodingTarget = nil;
        NSLog(@"music unsound");
    }
    [orgmoviefilerFile enableSynchronizedEncodingUsingMovieWriter:moviefilterWriter];
    
//    [photofilter prepareForImageCapture];
    
    [moviefilterWriter startRecording];
    [orgmoviefilerFile startProcessing];
    
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Successfully processed video, do you want to play video now?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    alert.tag = 900;
    
    [moviefilterWriter setCompletionBlock:^{
        [photofilter removeTarget:moviefilterWriter];
        [[testimages objectAtIndex:0] setValue:pathToMovie forKey:@"filter_url"];
        [_HUD hide:YES];
        [orgmovieeffectFile endProcessing];
        [orgmoviefilerFile endProcessing];
        [movie2 endProcessing];
        [moviefilterWriter finishRecording];
        bProcessing = NO;
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [alert show];
        });
    }];
}

 // photo filter
-(void) setFilter:(int) index {
    NSString *filename = @"";
    if(index<9)
    {
        filename = [NSString stringWithFormat:@"filter0%d", index+1];
    }
    else
        filename = [NSString stringWithFormat:@"filter%d", index+1];
    if(index!=9)
        photofilter = [[GPUImageToneCurveFilter alloc] initWithACV:filename];
    else
        photofilter = [[DLCGrayscaleContrastFilter alloc] init];
}

#pragma mark - Video effects processing

-(void) setEffects:(NSString*)movieurl :(int)index{
   
    tempvideoPathstr = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:(@"tmp/tempmerge_video%d.mp4"), (merged_video_number-1)]];
    NSString *pathToMovie = tempvideoPathstr;
    unlink([pathToMovie UTF8String]);

        NSURL *url = [NSURL fileURLWithPath:movieurl];
        NSString *filename = @"";
        if(index<9)
        {
            filename = [NSString stringWithFormat:@"Bokeh0%d", index+1];
        }
        else
            filename = [NSString stringWithFormat:@"Bokeh%d", index+1];
        NSURL *url2 = [[NSBundle mainBundle] URLForResource:filename withExtension:@"mov"];
        [self videoeffectprocess:url effecturl:url2 savemoviepath:pathToMovie];
}

- (void)videoeffectprocess:(NSURL*)movieurl effecturl:(NSURL *)url2 savemoviepath:(NSString*)pathToMovie
{
    bProcessing = YES;
    orgmovieeffectFile = [[GPUImageMovie alloc] initWithURL:movieurl];
    orgmovieeffectFile.runBenchmark = YES;
    orgmovieeffectFile.playAtActualSpeed = YES;
    orgmovieeffectFile.shouldRepeat = YES;
    
    movie2 = [[GPUImageMovie alloc] initWithURL:url2];
    movie2.runBenchmark = YES;
    movie2.playAtActualSpeed = YES;
    movie2.shouldRepeat = YES;
   
    //GPUImageAddBlendFilter   ,  GPUImageScreenBlendFilter
    //GPUImageAlphaBlendFilter    ,GPUImageDissolveBlendFilter
    //GPUImageExclusionBlendFilter,  GPUImageSoftLightBlendFilter
    videofilter = [[GPUImageScreenBlendFilter alloc] init];
 
    [orgmovieeffectFile addTarget:videofilter];
    [movie2 addTarget:videofilter];
    
    
    exportURL = [NSURL fileURLWithPath:pathToMovie];
    movieeffectWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:exportURL size:CGSizeMake(1280, 720)];
    
    GPUImageView *filterView = (GPUImageView *) _selectimageview;
    [videofilter addTarget:filterView];
    
    [videofilter addTarget:movieeffectWriter];
    
    movieeffectWriter.shouldPassthroughAudio = YES;
    AVAsset *anAsset = [AVAsset assetWithURL:movieurl];
    if ([[anAsset tracksWithMediaType:AVMediaTypeAudio] count] > 0){
        
        orgmovieeffectFile.audioEncodingTarget = movieeffectWriter;
    } else {//no audio
        orgmovieeffectFile.audioEncodingTarget = nil;
    }
    [orgmovieeffectFile enableSynchronizedEncodingUsingMovieWriter:movieeffectWriter];
    
//    [videofilter prepareForImageCapture];
    
    [movieeffectWriter startRecording];
    [orgmovieeffectFile startProcessing];
    [movie2 startProcessing];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Successfully processed video, do you want to play video now?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    alert.tag = 900;
    
    [movieeffectWriter setCompletionBlock:^{
        [videofilter removeTarget:movieeffectWriter];
        [orgmovieeffectFile endProcessing];
        [orgmoviefilerFile endProcessing];
        [movie2 endProcessing];
        [movieeffectWriter finishRecording];
        [_HUD hide:YES];
         bProcessing = NO;
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [alert show];
        });
    }];


}



#pragma mark -
#pragma mark - Video merge


- (void)videosmerges
{
    dispatch_async(dispatch_get_main_queue(), ^(void){
    _HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    _HUD.delegate = self;
    [_HUD setLabelText:@"fuzing videos now..."];
    });

    self.isMerging = YES;
    NSMutableArray* assetList = [[NSMutableArray alloc] init];
    int final_count = (int)[testimages count];
    int error = 0;
    for(int i=0;i<final_count;i++)
    {
        NSURL *sourceMovieURL ;
        if([[[testimages objectAtIndex:i] objectForKey:@"filter_url"] isEqualToString:@""])
             sourceMovieURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:[[testimages objectAtIndex:i] objectForKey:@"real_url"]]];
        else
            sourceMovieURL = [NSURL fileURLWithPath:[[testimages objectAtIndex:i] objectForKey:@"filter_url"]];
        NSLog(@"source_url=%@", sourceMovieURL);
        AVURLAsset* asset = [AVURLAsset URLAssetWithURL:sourceMovieURL options:nil];
        [self formatVideoTrack:asset withFinalArray:assetList];
    }
    while ([assetList count] < final_count );
   
    [self finishMerge:assetList withError: error];
    
}

- (void)formatVideoTrack: (AVAsset*)asset withFinalArray: (NSMutableArray*) array{
    
    AVMutableComposition *composition = [AVMutableComposition composition];
    [composition  addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    
    // input clip
    AVAssetTrack *clipVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    
    // make it square
    AVMutableVideoComposition* videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.renderSize = CGSizeMake(clipVideoTrack.naturalSize.height, clipVideoTrack.naturalSize.height);
   
    NSLog(@"test=%f", videoComposition.renderSize.height);
    NSLog(@"test=%f", videoComposition.renderSize.width);
    
    videoComposition.frameDuration = CMTimeMake(1, 30);
    
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(60, 30) );
    
    
    // rotate to portrait
    AVMutableVideoCompositionLayerInstruction* transformer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:clipVideoTrack];
    
    CGAffineTransform t1 = CGAffineTransformMakeTranslation(clipVideoTrack.naturalSize.height, -(clipVideoTrack.naturalSize.width - clipVideoTrack.naturalSize.height) /2 );
    
    CGAffineTransform t2 = CGAffineTransformRotate(t1, M_PI_2);
    
    
    
    CGAffineTransform finalTransform = t2;
    if([self orientationForTrack:clipVideoTrack] == UIInterfaceOrientationPortrait)
        [transformer setTransform:finalTransform atTime:kCMTimeZero];
    instruction.layerInstructions = [NSArray arrayWithObject:transformer];
    videoComposition.instructions = [NSArray arrayWithObject: instruction];
    
    // export
    
    NSString* documentsDirectory= [self applicationDocumentsDirectory];
    NSString* outputString = [documentsDirectory stringByAppendingPathComponent:@"temp_video"];
    outputString = [NSString stringWithFormat:@"%@%i%@", outputString, self.fileEndingNumber++, @".mp4"];
    NSURL* outputPath = [[NSURL alloc] initFileURLWithPath: outputString];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:outputString])
    {
        [[NSFileManager defaultManager] removeItemAtPath:outputString error:nil];
        
    }
    
    AVAssetExportSession* exporter = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetHighestQuality] ;
//    exporter.videoComposition = videoComposition;
    exporter.outputURL=outputPath;
    exporter.outputFileType=AVFileTypeQuickTimeMovie;
    
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        BOOL success = false;
        switch ([exporter status]) {
            case AVAssetExportSessionStatusCompleted:
                success = true;
                NSLog(@"Export Completed");
                break;
            case AVAssetExportSessionStatusWaiting:
                NSLog(@"Export Waiting");
                break;
            case AVAssetExportSessionStatusExporting:
                NSLog(@"Export Exporting");
                break;
            case AVAssetExportSessionStatusFailed:
            {
                NSError *error = [exporter error];
                NSLog(@"Export failed: %@", [error localizedDescription]);
                
                break;
            }
            case AVAssetExportSessionStatusCancelled:
                NSLog(@"Export canceled");
                
                break;
            default:
                break;
        }
        
        if (success == true) {
            AVAsset* new_asset = [AVAsset assetWithURL:outputPath];
            [array addObject:new_asset];
        }
        else {
            [array addObject:asset];
        }
    }];
}


- (UIInterfaceOrientation)orientationForTrack:(AVAssetTrack *)videoTrack
{
    
    CGSize size = [videoTrack naturalSize];
    CGAffineTransform txf = [videoTrack preferredTransform];
    
    if (size.width == txf.tx && size.height == txf.ty)
        return UIInterfaceOrientationLandscapeRight;
    else if (txf.tx == 0 && txf.ty == 0)
        return UIInterfaceOrientationLandscapeLeft;
    else if (txf.tx == 0 && txf.ty == size.width)
        return UIInterfaceOrientationPortraitUpsideDown;
    else
        return UIInterfaceOrientationPortrait;
}



- (void)finishMerge:(NSArray*)assetList withError:(int)error{
    AVMutableComposition *composition = [AVMutableComposition composition];
    
    
    AVMutableCompositionTrack *compositionVideoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    
    videoComposition.frameDuration = CMTimeMake(1,30);
    
    videoComposition.renderScale = 1.0;
    
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    
    AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTrack];
    
    AVMutableCompositionTrack *compositionAudioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    
    float time = 0;
    
    
    for (AVAsset* sourceAsset in assetList) {
        
        NSError *error = nil;
        
        id videoTrack = [sourceAsset tracksWithMediaType:AVMediaTypeVideo];
        id audioTrack = [sourceAsset tracksWithMediaType:AVMediaTypeAudio];
        
        AVAssetTrack *sourceVideoTrack;
        AVAssetTrack *sourceAudioTrack;
        
        CMTime current_time = [composition duration];
        
        if(time == 0)
        {
            [compositionVideoTrack setPreferredTransform:sourceAsset.preferredTransform];
        }
        
        if(videoTrack) {
            
            sourceVideoTrack = [videoTrack objectAtIndex:0];
            [compositionVideoTrack insertTimeRange:sourceVideoTrack.timeRange ofTrack:sourceVideoTrack atTime:current_time error:&error];
        }
        if(audioTrack) {
            if([[sourceAsset tracksWithMediaType:AVMediaTypeAudio] count]>0)
            {
                sourceAudioTrack = [audioTrack objectAtIndex:0];
                [compositionAudioTrack insertTimeRange:sourceAudioTrack.timeRange ofTrack:sourceAudioTrack atTime:current_time error:&error];
            }
        }
        
        time += CMTimeGetSeconds(sourceVideoTrack.timeRange.duration);
        
    }
    
    
    
    instruction.layerInstructions = [NSArray arrayWithObject:layerInstruction];
    instruction.timeRange = compositionVideoTrack.timeRange;
    
    
    videoComposition.instructions = [NSArray arrayWithObject:instruction];
    
    NSString* documentsDirectory= [self applicationDocumentsDirectory];
    
    NSString* myDocumentPath= [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:(@"tmp/merge_video%d.mp4"), merged_video_number]];
    unlink([myDocumentPath UTF8String]);
    
    if([[NSFileManager defaultManager] fileExistsAtPath:myDocumentPath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:myDocumentPath error:nil];
        
    }

    int count = 1;
    while ([[NSFileManager defaultManager] fileExistsAtPath:myDocumentPath]) {
        NSString* myDocumentPath= [documentsDirectory stringByAppendingPathComponent:@"merge_video"];
        myDocumentPath = [NSString stringWithFormat:@"%@%i%@", myDocumentPath, count++, @".mp4"];
    }
    NSURL *url = [[NSURL alloc] initFileURLWithPath: myDocumentPath];
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetHighestQuality];
    
    
    
    exporter.outputURL=url;
    exporter.shouldOptimizeForNetworkUse = YES;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    //exporter.shouldOptimizeForNetworkUse = YES;
    
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        BOOL success = false;
        switch ([exporter status]) {
            case AVAssetExportSessionStatusCompleted:
                success = true;
                NSLog(@"Export Completed");
                break;
            case AVAssetExportSessionStatusWaiting:
                NSLog(@"Export Waiting");
                break;
            case AVAssetExportSessionStatusExporting:
                NSLog(@"Export Exporting");
                break;
            case AVAssetExportSessionStatusFailed:
            {
                NSError *error = [exporter error];
                NSLog(@"Export failed: %@", [error localizedDescription]);
                
                break;
            }
            case AVAssetExportSessionStatusCancelled:
                NSLog(@"Export canceled");
                
                break;
            default:
                break;
        }
        if (success == true) {
            
             NSString* message;
            if (error) {
                
                message = @"Films have been fuzed!But some parts of the video might be corrupted!, Please try again";
                self.alert = [[UIAlertView alloc] initWithTitle:@"Done!"
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [_HUD hide:YES];
                    [self.alert show];
                    
                });
                
            }
            else {
                
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    
                    [_HUD hide:YES];
                    merged_video_checkflag = true;
                    videoPathstr = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:(@"tmp/merge_video%d.mp4"), merged_video_number]];
                    
                    
                    merged_video_number++;
                    if(music_flag)
                    {
                             [self processinginit];
                            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
                            [self presentViewController:self.musicpicker animated:YES completion:^
                             {
                                 [self.musicpicker setNeedsStatusBarAppearanceUpdate];
                             
                             }];
                            music_flag = false;
                        
                        for(int i =0;i<testimages.count;i++)
                        {
                            DragImageView *imageview = [[testimages objectAtIndex:i] objectForKey:@"virtual_image"];
                            [imageview removeFromSuperview];
                        }
                        
                        [testimages removeAllObjects];
                        [testimages1 removeAllObjects];
                        
                        NSURL *vidURL = [NSURL fileURLWithPath:videoPathstr];
                        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:vidURL options:nil];
                        CMTime video_time = [asset duration];
                        float seconds = ceil(video_time.value/video_time.timescale);
                        AVAssetImageGenerator *generate = [[AVAssetImageGenerator alloc] initWithAsset:asset];
                        
                        NSError *err = NULL;
                        CMTime time = CMTimeMake(1, 60);
                        
                        CGImageRef imgRef = [generate copyCGImageAtTime:time actualTime:NULL error:&err];
                        
                        DragImageView *testimageview = [[DragImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
                        testimageview.image = [UIImage imageWithCGImage:imgRef];
                        
                        
                        NSMutableDictionary *workingDictionary = [[NSMutableDictionary alloc] init];
                        [workingDictionary setObject:[NSString stringWithFormat:(@"merge_video%d.mp4"), (merged_video_number-1)] forKey:@"real_url"];
                        [workingDictionary setObject:testimageview forKey:@"virtual_image"];
                        [workingDictionary setObject:@"ALAssetTypeVideo" forKey:@"url_type"];
                        [workingDictionary setObject:[NSString stringWithFormat:@"%f",seconds] forKey:@"video_duration"];
                        [workingDictionary setObject:tempvideoPathstr forKey:@"filter_url"];
                        
                        [testimages addObject:workingDictionary];
                        [self showImage];

                   }
                    else if(fx_transition_flag)
                    {
                        _HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                        _HUD.delegate = self;
                        [_HUD setLabelText:@"Processing....."];
                        
                        fx_transition_flag = false;
                        [self setEffects:videoPathstr :fx_transition_index];
                    }
                    else if(filter_flag)
                    {
                        _HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                        _HUD.delegate = self;
                        [_HUD setLabelText:@"Processing....."];
                        
                        filter_flag = false;
                        [self setFilter:fx_transition_index];
                        [self preparevideofilter:videoPathstr];
                    }
                    else
                    {
                        AVURLAsset* videoAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:videoPathstr] options:nil];
                        CMTime videoDuration = videoAsset.duration;
                        float videoDurationSeconds = CMTimeGetSeconds(videoDuration);
                        if(videoDurationSeconds>60)
                        {
                            NSString* message;
                            message = @"Video Length is over than 60 seconds, you can have only video within 60 seconds, please try again";
                            self.alert = [[UIAlertView alloc] initWithTitle:@"Done!"
                                                                message:message
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                            [self.alert show];
                        }
                        else
                        {
                            [self.movieController stop];
                            UIStoryboard  *storyboard;
                            if(IS_IPHONE_5)
                                storyboard = [UIStoryboard storyboardWithName:@"Main"  bundle:nil];
                            else
                                storyboard = [UIStoryboard storyboardWithName:@"Main4"  bundle:nil];
                            VideoUploadController *uploadcontroller = [storyboard  instantiateViewControllerWithIdentifier:@"VideoUploadController"];
                            uploadcontroller.savefilestr = videoPathstr;
                            [self.navigationController pushViewController:uploadcontroller animated:YES];
                        }
                    }
                });
            }
        }
        else {
            
            if (self.alert) {
                [self.alert dismissWithClickedButtonIndex:0 animated:YES];
                self.alert = nil;
            }
            self.alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                    message:@"Something went wrong!, Please try again"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [_HUD hide:YES];
                [self.alert show];
                
            });
        }
        self.isMerging = NO;
        
    }];
    
}


- (NSString*) applicationDocumentsDirectory
{
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
    
}


#pragma mark -
#pragma mark - Video filter processing

- (void) waitfor: (NSTimer *)tim {
    if(!bProcessing)
    {
        [waitTimer invalidate];
         waitTimer = nil;
         bProcessing = YES;
        
        [NSThread sleepForTimeInterval:3.0f];
        [_HUD hide:YES];
        [self controlershow];
     
//        if([[NSFileManager defaultManager] fileExistsAtPath:[[testimages objectAtIndex:0] objectForKey:@"filter_url"]])
//        {
//            if([[[testimages objectAtIndex:0] objectForKey:@"filter_url"] isEqualToString:@""])
//                [self preshoweffects:[NSTemporaryDirectory() stringByAppendingPathComponent:[[testimages objectAtIndex:0] objectForKey:@"real_url"]]];
//            else
//            {
//               [self setthumbnailimage:[[testimages objectAtIndex:0] objectForKey:@"filter_url"]];
//               [self preshoweffects:[[testimages objectAtIndex:0] objectForKey:@"filter_url"]];
//            }
//            
//        }
//        else
//        {
//            UIAlertView *filteralert = [[UIAlertView alloc]initWithTitle:@"Alarm" message:@"Can not filter this video now, please try again after." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//             [filteralert show];
//        }
    }
    else
    {
        [self controlerhide];
    }
}

#pragma mark -
#pragma mark -Processing Init

- (void) controlershow
{
    [_importbtn setEnabled:true];
    [_importmusicbtn setEnabled:true];
    [_effectsbtn setEnabled:true];
    [_filtersbtn setEnabled:true];
    [_leftbackbtn setEnabled:true];
    [_rightbackbtn setEnabled:true];
}

- (void) controlerhide
{
    [_importbtn setEnabled:false];
    [_importmusicbtn setEnabled:false];
    [_effectsbtn setEnabled:false];
    [_filtersbtn setEnabled:false];
    [_leftbackbtn setEnabled:false];
    [_rightbackbtn setEnabled:false];
}

- (void) processinginit
{
    [moviefilterWriter cancelRecording];
    [movieeffectWriter cancelRecording];
    
    [orgmovieeffectFile cancelProcessing];
    [orgmoviefilerFile cancelProcessing];
    [movie2 cancelProcessing];
    
}

@end
