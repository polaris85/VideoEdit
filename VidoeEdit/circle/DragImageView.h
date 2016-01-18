//
//  DragImageView.h
//  CircleProject
//
//  Created by zbq on 13-10-30.
//  Copyright (c) 2013年 zbq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface DragImageView : UIImageView


@property(nonatomic) CGFloat current_radian;
@property(nonatomic) NSInteger current_index;
@property(nonatomic) CGFloat radian;
@property(nonatomic) CGFloat current_animation_radian;
@property(nonatomic) CGFloat animation_radian;
@property(nonatomic) CGPoint view_point;
@property(nonatomic) CGPoint lng_view_point;
@end
