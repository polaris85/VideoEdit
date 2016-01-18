//
//  UIDragButton.h
//  Draging
//
//  Created by makai on 13-1-8.
//  Copyright (c) 2013年 makai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum{
    up = 0,
    down = 1,
}Location;

@class UIDragImageView;

@protocol UIDragImageViewDelegate <NSObject>

- (void)arrangeUpButtonsWithButton:(UIDragImageView *)button andAdd:(BOOL)_bool;
- (void)arrangeDownButtonsWithButton:(UIDragImageView *)button andAdd:(BOOL)_bool;
- (void)setDownButtonsFrameWithAnimate:(BOOL)_bool withoutShakingButton:(UIDragImageView *)shakingButton;
- (void)checkLocationOfOthersWithButton:(UIDragImageView *)shakingButton;
- (void)removeShakingButton:(UIDragImageView *)button fromUpButtons:(BOOL)_bool;

@end

@interface UIDragImageView : UIImageView
{
    UIView *superView;
    CGPoint lastPoint;
    NSTimer *timer;
}

@property (nonatomic, assign) Location location;
@property (nonatomic, assign) CGPoint lastCenter;
@property (nonatomic, assign) id<UIDragImageViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame andImage:(UIImage *)image inView:(UIView *)view;
- (void)startShake;
- (void)stopShake;

@end
