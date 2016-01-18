//
//  VideoRecordViewController.m
//  VidoeEdit
//
//  Created by Sky on 5/15/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import "VideoRecordViewController.h"
#import "VideoEditeController.h"
#import "KZCameraView.h"

@interface VideoRecordViewController ()

@property (nonatomic, strong) KZCameraView *cam;

@end

@implementation VideoRecordViewController

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
    if (IOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
   
    self.cam = [[KZCameraView alloc]initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.height, self.view.frame.size.width) withVideoPreviewFrame:CGRectMake(0.0, 0.0, self.view.frame.size.height, self.view.frame.size.width)];
    self.cam.maxDuration = 61;
    self.cam.showCameraSwitch = YES;
    [self.view addSubview:self.cam];
    
    
    UIImage *leftbtnImage = [UIImage imageNamed:@"left_btn.png"];
    self.leftbackbtn = [[UIImageView alloc]initWithImage:leftbtnImage];
    self.leftbackbtn.bounds = CGRectMake(0.0, 0.0, 40, 82);
    
    self.leftbackbtn.center = CGPointMake(60, self.view.frame.size.width/2);
    self.leftbackbtn.userInteractionEnabled = YES;
    [self.view addSubview:self.leftbackbtn];
    
    
    UITapGestureRecognizer *leftbtnGesture =
    [[UITapGestureRecognizer alloc]
     initWithTarget:self action:@selector(leftbtnevent:)];
    self.leftbackbtn.tag = 100;
    leftbtnGesture.delegate = self;
    [self.leftbackbtn addGestureRecognizer:leftbtnGesture];
    
    
    UIImage *rightbtnImage = [UIImage imageNamed:@"right_btn.png"];
    self.rightbackbtn = [[UIImageView alloc]initWithImage:rightbtnImage];
    self.rightbackbtn.bounds = CGRectMake(0.0, 0.0, 40, 82);
    
    self.rightbackbtn.center = CGPointMake(self.view.frame.size.height-60, self.view.frame.size.width/2);
    self.rightbackbtn.userInteractionEnabled = YES;
    [self.view addSubview:self.rightbackbtn];
    
    UITapGestureRecognizer *rightbtnGesture =
    [[UITapGestureRecognizer alloc]
     initWithTarget:self action:@selector(rightbtnevent:)];
    self.rightbackbtn.tag = 101;
    rightbtnGesture.delegate = self;
    [self.rightbackbtn addGestureRecognizer:rightbtnGesture];

   
	// Do any additional setup after loading the view.
}

- (IBAction)leftbtnevent:(id)sender
{
    [self.cam removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)rightbtnevent:(id)sender
{
//    if(self.cam.record_flag)
//    {
//         [self.cam saveVideoWithCompletionBlock:^(BOOL success) {
//             if (success)
//             {
    
    NSString *orgmovieUrl = [NSTemporaryDirectory() stringByAppendingPathComponent:@"output.mov"];
    if([[NSFileManager defaultManager] fileExistsAtPath:orgmovieUrl])
    {
        [[NSFileManager defaultManager] removeItemAtPath:orgmovieUrl error:nil];
        
    }

                 AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
                 
                 [device lockForConfiguration:nil];
                 
                 if(device.torchActive) {
                     [device setTorchMode:AVCaptureTorchModeOff];
                     [device setFlashMode:AVCaptureFlashModeOff];
                 }
                 dispatch_async(dispatch_get_main_queue(), ^(void){
                     UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                     VideoEditeController *editcontroller = [storyboard instantiateViewControllerWithIdentifier:@"VideoEditeController"];
                     editcontroller.chooseproject = @"recordproject";
                     [self.navigationController pushViewController:editcontroller animated:YES];
                });
//             }
//         }];
//    }
//    else
//    {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Waring" message:@"You must record video, please record video now" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
