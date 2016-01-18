//
//  TutorialMenuController.m
//  VidoeEdit
//
//  Created by PSJ on 8/7/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import "TutorialMenuController.h"
#import "PageGuideViewController.h"
@interface TutorialMenuController ()

@end

@implementation TutorialMenuController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTitle:@"Tutorials"];
    tutorialmenuarray = [NSArray arrayWithObjects:@"EDITION", @"HOME",@"MUSIC",@"REC",@"SOCIAL MEDIA",@"TIPS EDITH",@"TRIM",nil];
    [self.navigationController.navigationBar setHidden:NO];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSUInteger count = [tutorialmenuarray count];
    return count > 0 ? count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier11 = @"TutorialCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier11];
    
    UILabel *tutorilatitle = (UILabel*)[cell viewWithTag:100];
    tutorilatitle.text =  [tutorialmenuarray objectAtIndex:indexPath.row];
    
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard  *storyboard;
    if(IS_IPHONE_5)
        storyboard = [UIStoryboard storyboardWithName:@"Main"  bundle:nil];
    else
        storyboard = [UIStoryboard storyboardWithName:@"Main4"  bundle:nil];
    
    PageGuideViewController *pageviewcontroller = [storyboard instantiateViewControllerWithIdentifier:@"PageGuideViewController"];
    switch (indexPath.row) {
        case 0:
            pageviewcontroller.tutorilaindex = @"EDIT";
            break;
        case 1:
            pageviewcontroller.tutorilaindex = @"HOME";
            break;
        case 2:
            pageviewcontroller.tutorilaindex = @"MUSIC";
            break;
        case 3:
            pageviewcontroller.tutorilaindex = @"REC";
            break;
        case 4:
            pageviewcontroller.tutorilaindex = @"SOCIAL";
            break;
        case 5:
            pageviewcontroller.tutorilaindex = @"TIPS";
            break;
        case 6:
            pageviewcontroller.tutorilaindex = @"TRIM";
            break;
            
        default:
            break;
    }
    [self.navigationController pushViewController:pageviewcontroller animated:YES];
}
@end
