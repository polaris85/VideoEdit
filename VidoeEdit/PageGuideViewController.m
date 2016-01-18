//
//  PageGuideViewController.m
//  VidoeEdit
//
//  Created by PSJ on 8/7/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import "PageGuideViewController.h"

@interface PageGuideViewController ()

@end

@implementation PageGuideViewController
@synthesize scrollView;

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
    [self.navigationController.navigationBar setHidden:YES];
    // Do any additional setup after loading the view.
    scrollView.delegate = self;
    CGRect frame = self.view.frame;
    
    if([_tutorilaindex isEqualToString:@"EDIT"])
        imagearray = [NSArray arrayWithObjects:@"EDITH00.png",@"EDITH01.png",@"EDITH02.png",@"EDITH03.png", nil];
    else if([_tutorilaindex isEqualToString:@"HOME"])
        imagearray = [NSArray arrayWithObjects:@"HOME01.png",@"HOME02.png",@"HOME03.png",@"HOME04.png", nil];
    else if([_tutorilaindex isEqualToString:@"MUSIC"])
        imagearray = [NSArray arrayWithObjects:@"MUSIC00.png", nil];
    else if([_tutorilaindex isEqualToString:@"REC"])
        imagearray = [NSArray arrayWithObjects:@"REC01.png",@"REC02.png",@"REC03.png",@"REC04.png",@"REC05.png", nil];
    else if([_tutorilaindex isEqualToString:@"SOCIAL"])
        imagearray = [NSArray arrayWithObjects:@"SOC01.png", nil];
    else if([_tutorilaindex isEqualToString:@"TIPS"])
        imagearray = [NSArray arrayWithObjects:@"TED01.png",@"TED02.png",@"TED03.png",@"TED04.png",@"TED05.png", nil];
    else
        imagearray = [NSArray arrayWithObjects:@"TRIM01.png", nil];

    
    
    
    
    for (int i = 0; i < imagearray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[imagearray objectAtIndex:i]]];
        imageView.layer.cornerRadius = 10;
        imageView.clipsToBounds = YES;
        imageView.frame = CGRectMake(frame.size.height * i+2, 0, frame.size.height-4, frame.size.width );
        
        [self.scrollView addSubview:imageView];
    }
    self.scrollView.contentSize = CGSizeMake(frame.size.height * imagearray.count, frame.size.width);
}

- (IBAction)gotoclick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
