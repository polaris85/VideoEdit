//
//  ViewController.h
//  VidoeEdit
//
//  Created by Sky on 5/14/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIAlertViewDelegate>
{
    NSArray *videoarray;
    NSUserDefaults *userDefaults;
}
- (IBAction)Videorecordevent:(id)sender;
- (IBAction)Projectimportevent:(id)sender;
@end
