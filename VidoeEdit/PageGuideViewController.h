//
//  PageGuideViewController.h
//  VidoeEdit
//
//  Created by PSJ on 8/7/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageGuideViewController : UIViewController<UIScrollViewDelegate>
{
    NSArray *imagearray;
}
@property (strong, nonatomic) NSString *tutorilaindex;
@property (strong,nonatomic)IBOutlet UIScrollView *scrollView;

- (IBAction)gotoclick:(id)sender;
@end
