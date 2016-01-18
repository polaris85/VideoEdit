//
//  TutorialMenuController.h
//  VidoeEdit
//
//  Created by PSJ on 8/7/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialMenuController : UITableViewController<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *tutorialmenuarray;
}
@property (nonatomic, retain)IBOutlet UITableView *tutorialtb;
@end
