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
#import "SVProgressHUD.h"

@interface VideoEditeController ()<SBPageFlowViewDelegate,SBPageFlowViewDataSource>
{
    NSArray *_filterflowimageArray;
    
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    filter_coverflag = false;
    process_closeflag = false;
    filterbtn_coverflag_close = false;
    effectbtn_coverflag_close = false;
    filter_click_flag = false;
    bProcessing = YES;
    animation_count = 0;
    startpoint = CGPointMake(self.view.frame.size.height/2, 285);
    longclickpoint = CGPointMake(0, 0);
    center = CGPointMake(self.view.frame.size.height/2, 160);
	// Do any additional setup after loading the view, typically from a nib.
    testimages = [[NSMutableArray alloc]init];
    testimages1 = [[NSMutableArray alloc]init];
    
    NSString *stringUrl = @"output.mov";
    NSURL *vidURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent :stringUrl]];
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:vidURL options:nil];
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
    [workingDictionary setObject:@"" forKey:@"filter_url"];
    
     selectimageview = [[GPUImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width)];
    
    [self.view addSubview:selectimageview];
    
    [testimages addObject:workingDictionary];
    [self showImage];
   
    //     videoeffectfilter = [[GPUImageContrastFilter alloc] init];
    
    trashimageview = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.height/2-25, self.view.frame.size.width/2-25, 50, 50)];
    [self.view addSubview:trashimageview];
    trashimageview.image = [UIImage imageNamed:@"trash.png"];
    [self.view bringSubviewToFront:trashimageview];
    [self.view bringSubviewToFront:_importbtn];
    [self.view bringSubviewToFront:_effectsbtn];
    [self.view bringSubviewToFront:_filtersbtn];
    [self.view bringSubviewToFront:_rightbackbtn];
    [self.view bringSubviewToFront:_leftbackbtn];
    [self.view bringSubviewToFront:_importmusicbtn];
    self.ActivityView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.frame.size.height/2-35, self.view.frame.size.width/2-35, 70, 70)];
    [self.view addSubview:self.ActivityView];
    [self.view bringSubviewToFront:_ActivityView];

    
    
    // music import
    self.musicpicker = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeMusic];
    self.musicpicker.delegate						= self;
    self.musicpicker.allowsPickingMultipleItems	= YES;
    self.musicpicker.prompt						= NSLocalizedString (@"Add songs to play", "Prompt in media item picker");
    [self.musicpicker setAllowsPickingMultipleItems:NO];
}



- (IBAction)filerchoose:(id)sender;
{
     if(!filterbtn_coverflag_close)
    {
        process_closeflag = true;
        [self filterviewhide];
        filterbtn_coverflag_close = true;
        filter_coverflag = false;
        _filterflowimageArray = [[NSArray alloc] initWithObjects:@"filter1.png",@"filter2.png",@"filter3.png",@"filter4.png",@"filter5.png",@"filter6.png",@"filter7.png",@"filter8.png",@"filter9.png",@"filter10.png",nil];
    
        _filterflowcurrentPage = 0;
    
        NSLog(@"test=%f", self.view.frame.size.height);
        _filterflowView = [[SBPageFlowView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-self.view.frame.size.width/3-30, self.view.frame.size.height/2-60, self.view.frame.size.width-120, 120)];
        _filterflowView.delegate = self;
        _filterflowView.dataSource = self;
        _filterflowView.minimumPageAlpha = 0.9;
        _filterflowView.minimumPageScale = 0.8;
        _filterflowView.defaultImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"filter1.png"]];
        [self.view addSubview:_filterflowView];
        [_filterflowView reloadData];
    }
    else
    {
        filterbtn_coverflag_close = false;
        [self filterviewhide];
        UIAlertView *filteralert = [[UIAlertView alloc]initWithTitle:@"Alarm" message:@"Did you apply this filter to video?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        filteralert.tag = 500;
        filteralert.delegate = self;
        [filteralert show];
    }
    
}

#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    filter_click_flag = false;
    if(alertView.tag == 500 )
    {
        if(buttonIndex == 1)
        {
            NSLog(@"test=%@", @"close");
            [_ActivityView startAnimating];
            waitTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                     target:self
                                                   selector:@selector(waitfor:)
                                                   userInfo:nil
                                                    repeats:YES];
            
            
        }
        else
        {
            [[testimages objectAtIndex:0] setObject:@"" forKey:@"filter_url"];
            process_closeflag = false;
        }
    }
    if(alertView.tag == 501)
    {
        if(buttonIndex == 1)
        {
            NSLog(@"test=%@", @"close");
            [_ActivityView startAnimating];
            waitTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                     target:self
                                                   selector:@selector(waitfor:)
                                                   userInfo:nil
                                                    repeats:YES];
        }
        else
        {
            [[testimages objectAtIndex:0] setValue:@"" forKey:@"filter_url"];
            process_closeflag = false;
        }
    }
}

#pragma mark - UIPopoverListViewDataSource

- (UITableViewCell *)popoverListView:(UIPopoverListView *)popoverListView
                    cellForIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:identifier];
    
    int row = (int)indexPath.row;
    
    if(row == 0){
        cell.textLabel.text = @"Effects";
        cell.imageView.image = [UIImage imageNamed:@"ic_facebook.png"];
    }else if (row == 1){
        cell.textLabel.text = @"Filters";
        cell.imageView.image = [UIImage imageNamed:@"ic_twitter.png"];
    }else
    {
        cell.textLabel.text = @"Exit";
        cell.imageView.image = [UIImage imageNamed:@"ic_google_plus.png"];
    }
    return cell;
}

- (NSInteger)popoverListView:(UIPopoverListView *)popoverListView
       numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

#pragma mark - UIPopoverListViewDelegate
- (void)popoverListView:(UIPopoverListView *)popoverListView
     didSelectIndexPath:(NSIndexPath *)indexPath
{
    process_closeflag = true;
    [_effectsbtn setEnabled:true];
    [self filterviewhide];
    switch (indexPath.row) {
        case 0:
        {
            video_fx_transflag = true;
            filter_coverflag = true;
            _filterflowimageArray = [[NSArray alloc] initWithObjects:@"transfer1.png",@"transfer2.png",@"transfer3.png",@"transfer4.png",@"transfer5.png",@"transfer6.png",@"transfer7.png",@"transfer8.png",@"transfer9.png",@"transfer10.png",@"transfer11.png",@"transfer12.png",@"transfer13.png",@"transfer14.png",@"transfer15.png",@"transfer16.png",@"transfer17.png",@"transfer18.png",@"transfer19.png",@"transfer20.png",nil];
            
            _filterflowcurrentPage = 0;
            
            NSLog(@"test=%f", self.view.frame.size.height);
            _filterflowView = [[SBPageFlowView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-self.view.frame.size.width/3-30, self.view.frame.size.height/2-60, self.view.frame.size.width-120, 120)];
            _filterflowView.delegate = self;
            _filterflowView.dataSource = self;
            _filterflowView.minimumPageAlpha = 0.9;
            _filterflowView.minimumPageScale = 0.8;
            _filterflowView.defaultImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"transfer1.png"]];
            [self.view addSubview:_filterflowView];
            [_filterflowView reloadData];
            
            
          }
            break;
        case 1:
        {
            video_fx_transflag = false;
            filter_coverflag = true;
            _filterflowimageArray = [[NSArray alloc] initWithObjects:@"fx1.png",@"fx2.png",@"fx3.png",@"fx4.png",@"fx5.png",@"fx6.png",@"fx7.png",@"fx8.png",@"fx9.png",@"fx10.png",@"fx11.png",@"fx12.png",@"fx13.png",@"fx14.png",@"fx15.png",@"fx16.png",@"fx17.png",@"fx18.png",@"fx19.png",@"fx20.png",nil];
            
            _filterflowcurrentPage = 0;
            
            NSLog(@"test=%f", self.view.frame.size.height);
            _filterflowView = [[SBPageFlowView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-self.view.frame.size.width/3-30, self.view.frame.size.height/2-60, self.view.frame.size.width-120, 120)];
            _filterflowView.delegate = self;
            _filterflowView.dataSource = self;
            _filterflowView.minimumPageAlpha = 0.9;
            _filterflowView.minimumPageScale = 0.8;
            _filterflowView.defaultImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fx1.png"]];
            [self.view addSubview:_filterflowView];
            [_filterflowView reloadData];
        }
            
            break;
        default:
        {
            process_closeflag = false;
            filter_coverflag = false;
            effectbtn_coverflag_close = false;
            [self filterviewhide];
        }
            break;
    }
    // your code here
}

- (void)filterviewhide
{
    filter_coverflag = false;
    _filterflowimageArray = nil;
    [_filterflowView removeFromSuperview];
  
}

- (CGFloat)popoverListView:(UIPopoverListView *)popoverListView
   heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

- (IBAction)leftbtnevent:(id)sender
{
    if(process_closeflag)
        [_filterflowView scrollBackPage];
    else
    {
        [movieWriter cancelRecording];
        [orgmovieeffectFile cancelProcessing];
        [orgmoviefilerFile cancelProcessing];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)rightbtnevent:(id)sender
{
    if(process_closeflag)
        [_filterflowView scrollToNextPage];
    else
    {
        [movieWriter cancelRecording];
        [orgmovieeffectFile cancelProcessing];
        [orgmoviefilerFile cancelProcessing];
        [self videosmerges];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)photochoose:(id)sender
{
    if (!self.assets)
        self.assets = [[NSMutableArray alloc] init];
    
    CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
    picker.assetsFilter         = [ALAssetsFilter allAssets];
    picker.showsCancelButton    = (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad);
    picker.delegate             = self;
    picker.selectedAssets       = [NSMutableArray arrayWithArray:self.assets];

    
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - Assets Picker Delegate

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
  
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
     self.assets = [NSMutableArray arrayWithArray:assets];
   
   
        for(int i=0;i<[self.assets count];i++)
        {
            ALAsset *asset = [self.assets objectAtIndex:i];
            DragImageView *testimageview = [[DragImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
            testimageview.image = [UIImage imageWithCGImage:asset.thumbnail];
            NSMutableDictionary *workingDictionary = [[NSMutableDictionary alloc] init];
            [workingDictionary setObject:testimageview forKey:@"virtual_image"];
            [workingDictionary setObject:[self videoAssetURLToTempFile:[asset valueForProperty:ALAssetPropertyAssetURL] selectimage:[UIImage imageWithCGImage:asset.thumbnail]] forKey:@"real_url"];
        
            [workingDictionary setObject:@"" forKey:@"filter_url"];
//        if([[asset valueForProperty:ALAssetPropertyType] isEqualToString:@"ALAssetTypePhoto"])
//            [workingDictionary setObject:@"ALAssetTypePhoto" forKey:@"url_type"];
//        else if([[asset valueForProperty:ALAssetPropertyType] isEqualToString:@"ALAssetTypeVideo"])
            [workingDictionary setObject:@"ALAssetTypeVideo" forKey:@"url_type"];
        
            NSLog(@"test=%@", [workingDictionary objectForKey:@"real_url"]);
            [testimages addObject:workingDictionary];
        }
     
        if (testimages.count > 0) {
            //        [self addGesture];
            [self showImage];
        }else{
            return;
        }
     
}

-(NSString *) videoAssetURLToTempFile:(NSURL*)url selectimage:(UIImage *)image
{
    BOOL photo_videoflag = NO;
    NSString * surl = [url absoluteString];
    NSString * ext = [surl substringFromIndex:[surl rangeOfString:@"ext="].location + 4];
    
    if([ext isEqualToString:@"JPG"])
    {
        NSString *myString = [url absoluteString];
        photo_videoflag = YES;
        myString = [myString stringByReplacingOccurrencesOfString:@"JPG"
                                                       withString:@"mp4"];
        url = [NSURL URLWithString:myString];
        surl = [url absoluteString];
        ext=@"mp4";
    }
    else if([ext isEqualToString:@"PNG"])
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
        NSArray* testImageArray = [[NSArray alloc] initWithObjects:
                                   image,image,image,
                                    nil];
        photo_videoflag = NO;
        [self writeImageAsMovie:testImageArray toPath:tmpfile size:CGSizeMake(720, 560) duration:3.0f];
        
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

-(void)writeImageAsMovie:(NSArray *)images toPath:(NSString*)output size:(CGSize)size duration:(float)duration
{
    NSError *error;
    NSURL *output_url = [NSURL fileURLWithPath:output];
    AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL:output_url fileType:AVFileTypeMPEG4 error: &error];
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                   AVVideoCodecH264, AVVideoCodecKey,
                                   [NSNumber numberWithInt:size.width], AVVideoWidthKey,
                                   [NSNumber numberWithInt:size.height], AVVideoHeightKey,
                                   nil];
    
    
    AVAssetWriterInput* videoWriterInput = [AVAssetWriterInput
                                            assetWriterInputWithMediaType:AVMediaTypeVideo
                                            outputSettings:videoSettings];
    
    
    AVAssetWriterInputPixelBufferAdaptor *adaptor = [AVAssetWriterInputPixelBufferAdaptor
                                                     
                                                     assetWriterInputPixelBufferAdaptorWithAssetWriterInput: videoWriterInput
                                                     
                                                     sourcePixelBufferAttributes:nil];
    [videoWriter addInput: videoWriterInput];
    [videoWriter startWriting];
    [videoWriter startSessionAtSourceTime:kCMTimeZero];
    
    
    CVPixelBufferRef buffer = NULL;
    //convert uiimage to CGImage.
    
    //convert uiimage to CGImage.
    NSInteger fps = 1000;
    int frameCount = 0;
    
    for(UIImage *img  in images)
    {
        //for(VideoFrame * frm in imageArray)
        NSLog(@"**************************************************");
        //UIImage * img = frm._imageFrame;
        buffer = [self pixelBufferFromCGImage:[img CGImage] size:size];
        double numberOfSecondsPerFrame = duration / images.count;
        double frameDuration = fps * numberOfSecondsPerFrame;
        
        BOOL append_ok = NO;
        int j = 0;
        while (!append_ok && j < fps)
        {
            if (adaptor.assetWriterInput.readyForMoreMediaData)
            {
                //print out status:
                NSLog(@"Processing video frame (%d,%lu)",frameCount,(unsigned long)[images count]);
                
                CMTime frameTime = CMTimeMake(frameCount*frameDuration,(int32_t) fps);
                append_ok = [adaptor appendPixelBuffer:buffer withPresentationTime:frameTime];
                if(!append_ok)
                {
                    NSError *error = videoWriter.error;
                    if(error!=nil) {
                        NSLog(@"Unresolved error %@,%@.", error, [error userInfo]);
                    }
                }
            }
            else
            {
                printf("adaptor not ready %d, %d\n", frameCount, j);
                [NSThread sleepForTimeInterval:0.1];
            }
            j++;
        }
        if (!append_ok)
        {
            printf("error appending image %d times %d\n, with error.", frameCount, j);
        }
        frameCount++;
        NSLog(@"**************************************************");
    }
    
    [videoWriterInput markAsFinished];
    [videoWriter finishWriting];
    
    videoWriter = nil;
    if(buffer != NULL)
        CVPixelBufferRelease(buffer);
    NSLog(@"************ write standard video successful ************");

}
-(CVPixelBufferRef) pixelBufferFromCGImage: (CGImageRef) image  size:(CGSize)size
{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             nil];
    CVPixelBufferRef pxbuffer = NULL;
    
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, size.width,
                                          size.height, kCVPixelFormatType_32ARGB, (__bridge CFDictionaryRef) options,
                                          &pxbuffer);
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata, size.width,
                                                 size.height, 8, 4*size.width, rgbColorSpace,
                                                 kCGImageAlphaPremultipliedFirst);
    NSParameterAssert(context);
    CGContextConcatCTM(context, CGAffineTransformMakeRotation(0));
    CGContextDrawImage(context, CGRectMake(0, 0, size.width,
                                           size.height), image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;}

-(UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 1);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}



- (void)showImage{
    
    CGFloat fRadina;
    average_radina = 2*M_PI/testimages.count;
    DragImageView *dragImageView = [[testimages objectAtIndex:0] objectForKey:@"virtual_image"];
    CGFloat width = dragImageView.frame.size.width;
    CGFloat heigh = dragImageView.frame.size.height;
    //计算半径
    radius = MIN(self.view.frame.size.width-width-30, self.view.frame.size.height-heigh-30)/2.0;
    for (int i=0; i<testimages.count; i++) {
        fRadina = [self getRadinaByRadian:i*average_radina];
        CGPoint point = [self getPointByRadian:fRadina centreOfCircle:center radiusOfCircle:radius];
        testdictionary = [testimages objectAtIndex:i];
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
        [self.view addSubview:imageview];
        
        if(CGPointEqualToPoint(imageview.center, startpoint))
        {
            if([[testdictionary objectForKey:@"url_type"] isEqualToString:@"ALAssetTypePhoto"])
            {
                sourcePicture = nil;
                sourcePicture = [[GPUImagePicture alloc] initWithImage:imageview.image smoothlyScaleOutput:YES];
                selectedFilter = (int)index;
                [self setFilter:(int)index];
                [self preparephotoFilter];
            }
            else if([[testdictionary objectForKey:@"url_type"] isEqualToString:@"ALAssetTypeVideo"])
            {
                //                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                //                                                                     NSUserDomainMask, YES);
                //                NSString *documentsDirectory = [paths objectAtIndex:0];
              
//                NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:(@"Documents/temp%@"), [testdictionary objectForKey:@"real_url"]]];
//                if(filter_click_flag)
//                    [[testimages objectAtIndex:i] setValue:pathToMovie forKey:@"filter_url"];
//                else
//                    [[testimages objectAtIndex:i] setValue:@"" forKey:@"filter_url"];
                [self setFilter:(int)index];
                if([[testdictionary objectForKey:@"filter_url"] isEqualToString:@""])
                    [self preparevideofilter:[testdictionary objectForKey:@"real_url"]];
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
    }
}

- (void)dragtest:(UILongPressGestureRecognizer *)sender
{
    if(!process_closeflag)
    {
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
                    [UIView animateWithDuration:.5 animations:^{
                    if(testimages.count>0)
                        [self showImage];
                    } completion:^(BOOL finished) {
                        [imageview.layer setShadowOpacity:0];
                    }];
                
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
    average_radina = 2*M_PI/testimages1.count;
    testdictionary = [testimages1 objectAtIndex:0];
    DragImageView *dragImageView = [testdictionary objectForKey:@"virtual_image"];
    
    CGFloat width = dragImageView.frame.size.width;
    CGFloat heigh = dragImageView.frame.size.height;
    //计算半径
    radius = MIN(self.view.frame.size.width-width-30, self.view.frame.size.height-heigh-30)/2.0;
    for (int i=0; i<testimages1.count; i++) {
        fRadina = [self getRadinaByRadian:i*average_radina];
        CGPoint point = [self getPointByRadian:fRadina centreOfCircle:center radiusOfCircle:radius];
     
        testdictionary = [testimages1 objectAtIndex:i];
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
        
        if(CGPointEqualToPoint(imageview.center, startpoint))
        {
            if([[testdictionary objectForKey:@"url_type"] isEqualToString:@"ALAssetTypePhoto"])
            {
                sourcePicture = nil;
                sourcePicture = [[GPUImagePicture alloc] initWithImage:imageview.image smoothlyScaleOutput:YES];
                selectedFilter = (int)index;
                [self setFilter:(int)index];
                [self preparephotoFilter];
            }
            else if([[testdictionary objectForKey:@"url_type"] isEqualToString:@"ALAssetTypeVideo"])
            {
                //                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                //                                                                     NSUserDomainMask, YES);
                //                NSString *documentsDirectory = [paths objectAtIndex:0];
                
//                NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:(@"Documents/temp%@"), [testdictionary objectForKey:@"real_url"]]];
//                if(filter_click_flag)
//                    [[testimages objectAtIndex:i] setValue:pathToMovie forKey:@"filter_url"];
//                else
//                    [[testimages objectAtIndex:i] setValue:@"" forKey:@"filter_url"];
                [self setFilter:(int)index];
                if([[testdictionary objectForKey:@"filter_url"] isEqualToString:@""])
                    [self preparevideofilter:[testdictionary objectForKey:@"real_url"]];
                else
                    [self preshoweffects:[testdictionary objectForKey:@"filter_url"]];
                
            }
            
            
        }
        
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
                    swap_position = imageview.current_index;
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
    if(!process_closeflag)
    {
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
    return [_filterflowimageArray count];
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
    
    imageView.image = [UIImage imageNamed:[_filterflowimageArray objectAtIndex:index]];
    return imageView;
}

#pragma mark - PagedFlowView Delegate
- (void)didReloadData:(UIView *)cell cellForPageAtIndex:(NSInteger)index
{
    UIImageView *imageView = (UIImageView *)cell;
    imageView.image = [UIImage imageNamed:[_filterflowimageArray objectAtIndex:index]];
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(SBPageFlowView *)flowView {
    NSLog(@"Scrolled to page # %ld", (long)pageNumber);
    _currentPage = pageNumber;
}

- (void)didSelectItemAtIndex:(NSInteger)index inFlowView:(SBPageFlowView *)flowView
{
    NSLog(@"didSelectItemAtIndex: %ld", (long)index);
    testdictionary = [testimages objectAtIndex:0];
    if(!filter_coverflag)
    {
        if([[testdictionary objectForKey:@"url_type"] isEqualToString:@"ALAssetTypePhoto"])
        {
            sourcePicture =nil;
            selectfilterimageview = [testdictionary objectForKey:@"virtual_image"];
            sourcePicture = [[GPUImagePicture alloc] initWithImage:selectfilterimageview.image smoothlyScaleOutput:YES];
            selectedFilter = (int)index;
            [self setFilter:(int)index];
            [self preparephotoFilter];
        }
        else if([[testdictionary objectForKey:@"url_type"] isEqualToString:@"ALAssetTypeVideo"])
        {
            //        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
            //                                                             NSUserDomainMask, YES);
            //        NSString *documentsDirectory = [paths objectAtIndex:0];
            filter_click_flag = true;
//            NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:(@"Documents/temp%@"), [testdictionary objectForKey:@"real_url"]]];
//            if(filter_click_flag)
//                [[testimages objectAtIndex:0] setValue:pathToMovie forKey:@"filter_url"];
//            else
//                [[testimages objectAtIndex:0] setValue:@"" forKey:@"filter_url"];
//            
//           
            NSLog(@"url=%@", [testdictionary objectForKey:@"real_url"]);
            [self setFilter:(int)index];
            if([[testdictionary objectForKey:@"filter_url"] isEqualToString:@""])
                [self preparevideofilter:[testdictionary objectForKey:@"real_url"]];
            else
                [self preshoweffects:[testdictionary objectForKey:@"filter_url"]];

        }
    }
    else
    {
        orgmovieUrl = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:[testdictionary objectForKey:@"real_url"]]];
        
        
        [self setEffects:[testdictionary objectForKey:@"real_url"] :(int)index];
        
    }
    
    
}

#pragma mark -
#pragma mark - image and video filter processing

-(void) preparephotoFilter {
    [orgmoviefilerFile removeAllTargets];
    [photofilter removeAllTargets];
    [orgmoviefilerFile cancelProcessing];
    [photofilter forceProcessingAtSize:selectimageview.sizeInPixels];
    
    [sourcePicture addTarget:photofilter];
    [photofilter addTarget:selectimageview];
    
    [sourcePicture processImage];
}


- (void)preshoweffects:(NSString*)urlstr
{
    bProcessing = YES;
    orgmovieUrl = [NSURL fileURLWithPath:urlstr];
    
    [movieWriter cancelRecording];
    
    [orgmovieeffectFile cancelProcessing];
    [orgmoviefilerFile cancelProcessing];
    [movie2 cancelProcessing];
    orgmoviefilerFile = [[GPUImageMovie alloc] initWithURL:orgmovieUrl];
    
    
    orgmoviefilerFile.runBenchmark = YES;
    orgmoviefilerFile.playAtActualSpeed = YES;
    orgmoviefilerFile.shouldRepeat = YES;
    
    [orgmoviefilerFile addTarget:photofilter];
    [photofilter addTarget:selectimageview];
    
    [orgmoviefilerFile startProcessing];
    
}


- (void)preparevideofilter:(NSString*)urlstr
{
    bProcessing = YES;
    orgmovieUrl = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:urlstr]];
    
    [movieWriter cancelRecording];
    
    [orgmovieeffectFile cancelProcessing];
    [orgmoviefilerFile cancelProcessing];
    [movie2 cancelProcessing];
    orgmoviefilerFile = [[GPUImageMovie alloc] initWithURL:orgmovieUrl];
    
    orgmoviefilerFile.runBenchmark = YES;
    orgmoviefilerFile.playAtActualSpeed = YES;
    orgmoviefilerFile.shouldRepeat = YES;
    
    [orgmoviefilerFile addTarget:photofilter];
    [photofilter addTarget:selectimageview];

    [orgmoviefilerFile startProcessing];
   
}

 // photo filter
-(void) setFilter:(int) index {
    switch (index) {
        case 1:{
            photofilter = [[GPUImageContrastFilter alloc] init];
            [(GPUImageContrastFilter *) photofilter setContrast:1.75];
        } break;
        case 2: {
            photofilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"crossprocess"];
        } break;
        case 3: {
            photofilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"02"];
        } break;
        case 4: {
            photofilter = [[DLCGrayscaleContrastFilter alloc] init];
        } break;
        case 5: {
            photofilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"17"];
        } break;
        case 6: {
            photofilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"aqua"];
        } break;
        case 7: {
            photofilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"yellow-red"];
        } break;
        case 8: {
            photofilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"06"];
        } break;
        case 9: {
            photofilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"purple-green"];
        } break;
        default:
            photofilter = [[GPUImageFilter alloc] init];
            break;
    }
}

#pragma mark - Video effects processing

-(void) setEffects:(NSString*)movieurl :(int)index{
    
    [movieWriter cancelRecording];
    [orgmovieeffectFile cancelProcessing];
    [orgmoviefilerFile cancelProcessing];
    [movie2 cancelProcessing];
    
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:(@"Documents/temp%@"), movieurl]];
    unlink([pathToMovie UTF8String]);
    if(video_fx_transflag)
    {
        switch (index) {
            case 0:
            {
                NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory()     stringByAppendingPathComponent:movieurl]];
                NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"Bokeh01" withExtension:@"mov"];
                [self videoeffectprocess:url effecturl:url2 savemoviepath:pathToMovie];
            }
                break;
            case 1:
            {
                NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:movieurl]];
                NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"Bokeh02" withExtension:@"mov"];
                [self videoeffectprocess:url effecturl:url2 savemoviepath:pathToMovie];
            }
                break;
            case 2:
            {
                NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory()     stringByAppendingPathComponent:movieurl]];
                NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"Bokeh03" withExtension:@"mov"];
                [self videoeffectprocess:url effecturl:url2 savemoviepath:pathToMovie];
            
            
            }
                break;
            case 3:
            {
                NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:movieurl]];
                NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"Bokeh04" withExtension:@"mov"];
                [self videoeffectprocess:url effecturl:url2 savemoviepath:pathToMovie];
            }
                break;
            case 4:
            {
                NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory()     stringByAppendingPathComponent:movieurl]];
                NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"Bokeh05" withExtension:@"mov"];
                [self videoeffectprocess:url effecturl:url2 savemoviepath:pathToMovie];
             }
                break;
            case 5:
            {
                NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:movieurl]];
                NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"Bokeh06" withExtension:@"mov"];
                [self videoeffectprocess:url effecturl:url2 savemoviepath:pathToMovie];
            }
                break;
            case 6:
            {
                NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory()     stringByAppendingPathComponent:movieurl]];
                NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"Bokeh07" withExtension:@"mov"];
                [self videoeffectprocess:url effecturl:url2 savemoviepath:pathToMovie];
             }
                break;
            case 7:
            {
                NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:movieurl]];
                NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"Bokeh08" withExtension:@"mov"];
                [self videoeffectprocess:url effecturl:url2 savemoviepath:pathToMovie];
            }
                break;
            case 8:
            {
                NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory()     stringByAppendingPathComponent:movieurl]];
                NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"Bokeh09" withExtension:@"mov"];
                [self videoeffectprocess:url effecturl:url2 savemoviepath:pathToMovie];
            }
                break;
            case 9:
            {
                NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:movieurl]];
                NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"Bokeh10" withExtension:@"mov"];
                [self videoeffectprocess:url effecturl:url2 savemoviepath:pathToMovie];
            }
                break;
            case 10:
            {
                NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory()     stringByAppendingPathComponent:movieurl]];
                NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"Bokeh11" withExtension:@"mov"];
                [self videoeffectprocess:url effecturl:url2 savemoviepath:pathToMovie];
            }
                break;
            case 11:
            {
                NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:movieurl]];
                NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"Bokeh12" withExtension:@"mov"];
                [self videoeffectprocess:url effecturl:url2 savemoviepath:pathToMovie];
            }
                break;
            case 12:
            {
                NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory()     stringByAppendingPathComponent:movieurl]];
                NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"Bokeh13" withExtension:@"mov"];
                [self videoeffectprocess:url effecturl:url2 savemoviepath:pathToMovie];
            }
                break;
            case 13:
            {
                NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:movieurl]];
                NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"Bokeh14" withExtension:@"mov"];
                [self videoeffectprocess:url effecturl:url2 savemoviepath:pathToMovie];
            }
                break;
            case 14:
            {
                NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory()     stringByAppendingPathComponent:movieurl]];
                NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"Bokeh15" withExtension:@"mov"];
                [self videoeffectprocess:url effecturl:url2 savemoviepath:pathToMovie];
            }
                break;
            case 15:
            {
                NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:movieurl]];
                NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"Bokeh16" withExtension:@"mov"];
                [self videoeffectprocess:url effecturl:url2 savemoviepath:pathToMovie];
            }
                break;
            case 16:
            {
                NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory()     stringByAppendingPathComponent:movieurl]];
                NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"Bokeh17" withExtension:@"mov"];
                [self videoeffectprocess:url effecturl:url2 savemoviepath:pathToMovie];
            }
                break;
            case 17:
            {
                NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:movieurl]];
                NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"Bokeh18" withExtension:@"mov"];
                [self videoeffectprocess:url effecturl:url2 savemoviepath:pathToMovie];
            }
                break;
            case 18:
            {
                NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory()     stringByAppendingPathComponent:movieurl]];
                NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"Bokeh19" withExtension:@"mov"];
                [self videoeffectprocess:url effecturl:url2 savemoviepath:pathToMovie];
            }
                break;
            case 19:
            {
                NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:movieurl]];
                NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"Bokeh20" withExtension:@"mov"];
                [self videoeffectprocess:url effecturl:url2 savemoviepath:pathToMovie];
            }
                break;
            default:
                break;
        }
    }
    else
    {
        switch (index) {
            case 0:
            {
                NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory()     stringByAppendingPathComponent:movieurl]];
                NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"FxTrans01" withExtension:@"mov"];
                [self videoeffectprocess:url effecturl:url2 savemoviepath:pathToMovie];
            }
                break;
            case 1:
            {
                NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:movieurl]];
                NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"FxTrans02" withExtension:@"mov"];
                [self videoeffectprocess:url effecturl:url2 savemoviepath:pathToMovie];
            }
                break;
            case 2:
            {
                NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory()     stringByAppendingPathComponent:movieurl]];
                NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"FxTrans03" withExtension:@"mov"];
                [self videoeffectprocess:url effecturl:url2 savemoviepath:pathToMovie];
                
                
            }
                break;
            case 3:
            {
                NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:movieurl]];
                NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"FxTrans04" withExtension:@"mov"];
                [self videoeffectprocess:url effecturl:url2 savemoviepath:pathToMovie];
            }
                break;
            case 4:
            {
                NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory()     stringByAppendingPathComponent:movieurl]];
                NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"FxTrans05" withExtension:@"mov"];
                [self videoeffectprocess:url effecturl:url2 savemoviepath:pathToMovie];
            }
                break;
            case 5:
            {
                NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:movieurl]];
                NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"FxTrans06" withExtension:@"mov"];
                [self videoeffectprocess:url effecturl:url2 savemoviepath:pathToMovie];
            }
                break;
            case 6:
            {
                NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory()     stringByAppendingPathComponent:movieurl]];
                NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"FxTrans07" withExtension:@"mov"];
                [self videoeffectprocess:url effecturl:url2 savemoviepath:pathToMovie];
            }
                break;
            case 7:
            {
                NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:movieurl]];
                NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"FxTrans08" withExtension:@"mov"];
                [self videoeffectprocess:url effecturl:url2 savemoviepath:pathToMovie];
            }
                break;
            case 8:
            {
                NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory()     stringByAppendingPathComponent:movieurl]];
                NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"FxTrans09" withExtension:@"mov"];
                [self videoeffectprocess:url effecturl:url2 savemoviepath:pathToMovie];
            }
                break;
            case 9:
            {
                NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:movieurl]];
                NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"FxTrans10" withExtension:@"mov"];
                [self videoeffectprocess:url effecturl:url2 savemoviepath:pathToMovie];
            }
                break;
            case 10:
            {
                NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory()     stringByAppendingPathComponent:movieurl]];
                NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"FxTrans11" withExtension:@"mov"];
                [self videoeffectprocess:url effecturl:url2 savemoviepath:pathToMovie];
            }
                break;
            case 11:
            {
                NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:movieurl]];
                NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"FxTrans12" withExtension:@"mov"];
                [self videoeffectprocess:url effecturl:url2 savemoviepath:pathToMovie];
            }
                break;
            case 12:
            {
                NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory()     stringByAppendingPathComponent:movieurl]];
                NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"FxTrans13" withExtension:@"mov"];
                [self videoeffectprocess:url effecturl:url2 savemoviepath:pathToMovie];
            }
                break;
            case 13:
            {
                NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:movieurl]];
                NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"FxTrans14" withExtension:@"mov"];
                [self videoeffectprocess:url effecturl:url2 savemoviepath:pathToMovie];
            }
                break;
            case 14:
            {
                NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory()     stringByAppendingPathComponent:movieurl]];
                NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"FxTrans15" withExtension:@"mov"];
                [self videoeffectprocess:url effecturl:url2 savemoviepath:pathToMovie];
            }
                break;
            case 15:
            {
                NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:movieurl]];
                NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"FxTrans16" withExtension:@"mov"];
                [self videoeffectprocess:url effecturl:url2 savemoviepath:pathToMovie];
            }
                break;
            case 16:
            {
                NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory()     stringByAppendingPathComponent:movieurl]];
                NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"FxTrans17" withExtension:@"mov"];
                [self videoeffectprocess:url effecturl:url2 savemoviepath:pathToMovie];
            }
                break;
            case 17:
            {
                NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:movieurl]];
                NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"FxTrans18" withExtension:@"mov"];
                [self videoeffectprocess:url effecturl:url2 savemoviepath:pathToMovie];
            }
                break;
            case 18:
            {
                NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory()     stringByAppendingPathComponent:movieurl]];
                NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"FxTrans19" withExtension:@"mov"];
                [self videoeffectprocess:url effecturl:url2 savemoviepath:pathToMovie];
            }
                break;
            case 19:
            {
                NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:movieurl]];
                NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"FxTrans20" withExtension:@"mov"];
                [self videoeffectprocess:url effecturl:url2 savemoviepath:pathToMovie];
            }
                break;
            default:
                break;
        }

    }
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
    [[testimages objectAtIndex:0] setValue:pathToMovie forKey:@"filter_url"];
    movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:exportURL size:CGSizeMake(640.0, 480.0)];
    
    GPUImageView *filterView = (GPUImageView *) selectimageview;
    [videofilter addTarget:filterView];
    
    [videofilter addTarget:movieWriter];
    
    movieWriter.shouldPassthroughAudio = YES;
    orgmovieeffectFile.audioEncodingTarget = movieWriter;
    [orgmovieeffectFile enableSynchronizedEncodingUsingMovieWriter:movieWriter];
//    [orgmovieeffectFile prepareForImageCapture];
    
    [movieWriter startRecording];
    [orgmovieeffectFile startProcessing];
    [movie2 startProcessing];
    
    [movieWriter setCompletionBlock:^{
        [videofilter removeTarget:movieWriter];
        [orgmovieeffectFile cancelProcessing];
        [orgmoviefilerFile cancelProcessing];
        [movie2 cancelProcessing];
        [movieWriter finishRecording];
         bProcessing = NO;
    }];


}

#pragma mark -
#pragma mark - Music merge

- (IBAction)musicmerge:(id)sender
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [self presentViewController:self.musicpicker animated:YES completion:^
     {
         [self.musicpicker setNeedsStatusBarAppearanceUpdate];
         
     }];

}

#pragma mark Media item picker delegate methods
- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker {
    
	[self dismissViewControllerAnimated:YES completion:nil];
}

-(void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection {
}


#pragma mark -
#pragma mark - Video merge

- (IBAction)effectchoose:(id)sender
{
    if(!effectbtn_coverflag_close)
    {
            effectbtn_coverflag_close = true;
        
            UIPopoverListView *poplistview = [[UIPopoverListView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/3,self.view.bounds.size.height/5,  200, 180)];
            poplistview.delegate = self;
            poplistview.datasource = self;
            poplistview.listView.scrollEnabled = FALSE;
            [poplistview setTitle:@"Effects and Filters"];
            [self.view addSubview:poplistview];
            [_effectsbtn setEnabled:false];
//        [self filterviewhide];
//        process_closeflag = true;
//        effectbtn_coverflag_close = true;
//        filter_coverflag = true;
//        _filterflowimageArray = [[NSArray alloc] initWithObjects:@"filter1.png",@"filter2.png",@"filter3.png",@"filter4.png",@"filter5.png",@"filter6.png",@"filter7.png",@"filter8.png",@"filter9.png",@"filter10.png",nil];
//    
//        _filterflowcurrentPage = 0;
//    
//        NSLog(@"test=%f", self.view.frame.size.height);
//        _filterflowView = [[SBPageFlowView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-self.view.frame.size.width/3-30, self.view.frame.size.height/2-60, self.view.frame.size.width-120, 120)];
//        _filterflowView.delegate = self;
//        _filterflowView.dataSource = self;
//        _filterflowView.minimumPageAlpha = 0.9;
//        _filterflowView.minimumPageScale = 0.8;
//        _filterflowView.defaultImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"filter1.png"]];
//        [self.view addSubview:_filterflowView];
//        [_filterflowView reloadData];
    }
    else
    {
        effectbtn_coverflag_close = false;
        [self filterviewhide];
        UIAlertView *filteralert = [[UIAlertView alloc]initWithTitle:@"Alarm" message:@"Did you apply this effect to video?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        filteralert.tag = 501;
        filteralert.delegate = self;
        [filteralert show];

    }
}

- (void)videosmerges
{
    if(self.isMerging) {
        if (self.alert) {
            [self.alert dismissWithClickedButtonIndex:0 animated:YES];
            self.alert = nil;
        }
        self.alert = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                message:@"Films are currently being fuzed!"
                                               delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            [self.alert show];
            
        });
    }
    else {
        if (self.alert) {
            [self.alert dismissWithClickedButtonIndex:0 animated:YES];
            self.alert = nil;
        }
        self.alert = [[UIAlertView alloc] initWithTitle:@"Merging"
                                                message:@"Films are currently fuzing!"
                                               delegate:self
                                      cancelButtonTitle:nil
                                      otherButtonTitles:nil];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            [self.alert show];
            
        });
        
    }
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
    exporter.videoComposition = videoComposition;
    exporter.outputURL=outputPath;
    exporter.outputFileType=AVFileTypeMPEG4;
    
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
            sourceAudioTrack = [audioTrack objectAtIndex:0];
            [compositionAudioTrack insertTimeRange:sourceAudioTrack.timeRange ofTrack:sourceAudioTrack atTime:current_time error:&error];
        }
        
        time += CMTimeGetSeconds(sourceVideoTrack.timeRange.duration);
        
    }
    
    
    
    instruction.layerInstructions = [NSArray arrayWithObject:layerInstruction];
    instruction.timeRange = compositionVideoTrack.timeRange;
    
    
    videoComposition.instructions = [NSArray arrayWithObject:instruction];
    
    NSString* documentsDirectory= [self applicationDocumentsDirectory];
    
    NSString* myDocumentPath= [documentsDirectory stringByAppendingPathComponent:@"merge_video.mp4"];
    
    int count = 1;
    while ([[NSFileManager defaultManager] fileExistsAtPath:myDocumentPath]) {
        NSString* myDocumentPath= [documentsDirectory stringByAppendingPathComponent:@"merge_video"];
        myDocumentPath = [NSString stringWithFormat:@"%@%i%@", myDocumentPath, count++, @".mp4"];
    }
    NSURL *url = [[NSURL alloc] initFileURLWithPath: myDocumentPath];
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetHighestQuality];
    
    
    
    exporter.outputURL=url;
    
    exporter.outputFileType = @"com.apple.quicktime-movie";
    
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
            
            ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
            [assetLibrary writeVideoAtPathToSavedPhotosAlbum:url completionBlock:^(NSURL *assetURL, NSError *error){
                NSError *removeError = nil;
                [[NSFileManager defaultManager] removeItemAtURL:url error:&removeError];
            }];
            if (self.alert) {
                [self.alert dismissWithClickedButtonIndex:0 animated:YES];
                self.alert = nil;
            }
            NSString* message;
            if (error) {
                message = @"Films have been fuzed! The final video is saved on the Camera Roll but some parts of the video might be corrupted!";
            }
            else {
                message = @"Films have been fuzed! The final video is saved on the Camera Roll.";
            }
            self.alert = [[UIAlertView alloc] initWithTitle:@"Done!"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                
                [self.alert show];
                
            });
        }
        else {
            if (self.alert) {
                [self.alert dismissWithClickedButtonIndex:0 animated:YES];
                self.alert = nil;
            }
            self.alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                    message:@"Something went wrong!"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                
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
        [self.ActivityView stopAnimating];
        [waitTimer invalidate];
         waitTimer = nil;
         bProcessing = YES;
         process_closeflag = false;
        [_importbtn setEnabled:true];
        [_importmusicbtn setEnabled:true];
        [_effectsbtn setEnabled:true];
        [_filtersbtn setEnabled:true];
        [_leftbackbtn setEnabled:true];
        [_rightbackbtn setEnabled:true];

    }
    else
    {
        [_importbtn setEnabled:false];
        [_importmusicbtn setEnabled:false];
        [_effectsbtn setEnabled:false];
        [_filtersbtn setEnabled:false];
        [_leftbackbtn setEnabled:false];
        [_rightbackbtn setEnabled:false];
    }
}



@end
