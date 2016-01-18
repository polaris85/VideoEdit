//
//  VideoEditeController.h
//  VidoeEdit
//
//  Created by PSJ on 6/11/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"
#import "DragImageView.h"
#import "CTAssetsPickerController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MBProgressHUD.h"
#import "UIImage+CJImageMerge.h"

@interface VideoEditeController : UIViewController<UIGestureRecognizerDelegate, CTAssetsPickerControllerDelegate,  AVAudioPlayerDelegate,MPMediaPickerControllerDelegate, UIAlertViewDelegate, UINavigationControllerDelegate, MBProgressHUDDelegate>
{
    NSMutableArray *testimages;
    NSMutableArray *testimages1;
    NSDictionary *testdictionary;
    AVAssetExportSession *exportador;
    NSMutableArray *saveprojectarray;
@private
    CGFloat radius;
    CGPoint center;
    CGFloat average_radina;
    CGPoint pointDrag;
    NSInteger step;
    
    CGPoint lastPoint;                    // drag temp point
    
    // variable for swip between images
    CGPoint swipepoint;
    CGPoint longclickpoint;
    
    CGRect swiperect;
    UIImageView *trashimageview;     // trash image view
    int swap_position;
    int animation_count;    // image count foranimation
    
    CGPoint startpoint;          // drag view begin point
    NSInteger    _currentPage;   // coverflow center page number
    BOOL filter_coverflag;       // which filter, filter or effect?
    
    
    // photo filter processing
    GPUImagePicture *sourcePicture;
    GPUImageOutput<GPUImageInput> *photofilter;
//    GPUImageAlphaBlendFilter *videofilter;
    GPUImageOutput<GPUImageInput> *videofilter;
    
    UIImage* inputImage;
    int selectedFilter;
    DragImageView *selectfilterimageview;
    
    // video filter processing
    GPUImageMovie *orgmoviefilerFile;
    GPUImageMovie *orgmovieeffectFile;
    GPUImageMovie *movie2;
    
    
    NSURL *orgmovieUrl;
    GPUImageMovie *filtermovieFile;
    NSURL *orgfilterurl;
    //    GPUImageFilter *videoeffectfilter;
    GPUImageMovieWriter *moviefilterWriter;
    GPUImageMovieWriter *movieeffectWriter;

    NSURL *exportURL;
    BOOL bProcessing;
    NSTimer *waitTimer;
    
    BOOL process_closeflag;          // left and right button distinguish, coz buttons have two funtions
    BOOL filter_clickable;            // filter or effect video choose.
    
    BOOL filterbtn_showhide ;
    BOOL effectbtn_showhide ;
      
    int flowviewcheck[2];
    // project save
    NSUserDefaults *userdefaults;
    
    
    BOOL music_flag;
    BOOL fx_transition_flag;
    BOOL filter_flag;
    int fx_transition_index;
    // final video(merged) path variable
    NSString *videoPathstr;
    NSString *tempvideoPathstr;
  
    float video_all_time;
    
    
    int merged_video_number;
    BOOL merged_video_checkflag;
}

// contorller call variable
@property (nonatomic, strong)  NSString *chooseproject;
@property (nonatomic, retain) MBProgressHUD *HUD;

// music import
@property (nonatomic, strong)  MPMediaPickerController *musicpicker;
@property (nonatomic, copy) NSArray *assets;

// video player
@property (strong, nonatomic) MPMoviePlayerController *movieController;
@property (strong, nonatomic) GPUImageView *selectimageview;         // self background imageview

@property (retain, nonatomic) __block UIAlertView* alert;
@property (nonatomic, retain) UIActivityIndicatorView *ActivityView;
@property BOOL isMerging;
@property int fileEndingNumber;

@property (nonatomic, assign) CGPoint lastCenter;
@property(nonatomic, retain) IBOutlet UIButton *importbtn;
@property(nonatomic, retain) IBOutlet UIButton *importmusicbtn;
@property(nonatomic, retain) IBOutlet UIButton *effectsbtn;
@property(nonatomic, retain) IBOutlet UIButton *filtersbtn;
@property (nonatomic, retain) IBOutlet UIButton *leftbackbtn;
@property (nonatomic, retain) IBOutlet UIButton *rightbackbtn;
@property (nonatomic, retain) IBOutlet UILabel *remaintimelbl;
@property (nonatomic, retain) IBOutlet UIImageView *backgroundview;



- (IBAction)photochoose:(id)sender;
- (IBAction)filerchoose:(id)sender;
- (IBAction)effectchoose:(id)sender;
- (IBAction)musicmerge:(id)sender;
- (IBAction)leftbtnevent:(id)sender;
- (IBAction)rightbtnevent:(id)sender;
- (void)videosmerges;
- (void)pickercontroller;
@end
