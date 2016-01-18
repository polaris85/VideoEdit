//
//  UIDragButton.m
//  Draging
//
//  Created by makai on 13-1-8.
//  Copyright (c) 2013年 makai. All rights reserved.
//

#import "UIDragImageView.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIDragImageView
@synthesize location;
@synthesize lastCenter;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame andImage:(UIImage *)image inView:(UIView *)view
{
    self = [super initWithFrame:frame];
    if (self) {
        self.lastCenter = CGPointMake(frame.origin.x + frame.size.width / 2, frame.origin.y + frame.size.height / 2);
        superView = view;
        [self setBackgroundImage:image forState:UIControlStateNormal];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(drag:)];
        [self addGestureRecognizer:longPress];
        [longPress release];
        
    }
    return self;
}


- (void)drag:(UILongPressGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:superView];
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            [self setAlpha:0.7];
            lastPoint = point;
            [self.layer setShadowColor:[UIColor grayColor].CGColor];
            [self.layer setShadowOpacity:1.0f];
            [self.layer setShadowRadius:10.0f];
            [self startShake];
            break;
        case UIGestureRecognizerStateChanged:
        {
            float offX = point.x - lastPoint.x;
            float offY = point.y - lastPoint.y;
            [self setCenter:CGPointMake(self.center.x + offX, self.center.y + offY)];
            if (self.center.y <= 850) {
                if (self.frame.size.width != 100) {
                    //down->up
                    [self setLastCenter:CGPointMake(0, 0)];
                    [self setLocation:up];
                    [delegate arrangeDownButtonsWithButton:self andAdd:NO];
                    [UIView animateWithDuration:.2 animations:^{
                        [self setFrame:CGRectMake(self.center.x + offX - 50, self.center.y + offY - 50, 100, 100)];
                    }];
                }
            }else{
                if (self.frame.size.width != 80) {
                    //up->down
                    [self setLastCenter:CGPointMake(0, 0)];
                    [self setLocation:down];
                    [delegate arrangeUpButtonsWithButton:self andAdd:NO];
                    [delegate setDownButtonsFrameWithAnimate:YES withoutShakingButton:self];
                    [UIView animateWithDuration:.2 animations:^{
                        [self setFrame:CGRectMake(self.center.x + offX - 40, self.center.y + offY - 40, 80, 80)];
                    }];
                }
            }
            lastPoint = point;
            [delegate checkLocationOfOthersWithButton:self];
            break;
        }
        case UIGestureRecognizerStateEnded:
            [self stopShake];
            [self setAlpha:1];
            
            switch ( self.location) {
                case up:
                        self.location = up;
                        [UIView animateWithDuration:.5 animations:^{
                            if (self.lastCenter.x == 0) {
                                [delegate arrangeUpButtonsWithButton:self andAdd:YES];
                            }else{
                                [self setFrame:CGRectMake(lastCenter.x - 50, lastCenter.y - 50, 100, 100)];
                            }
                            
                        } completion:^(BOOL finished) {
                            [self.layer setShadowOpacity:0];
                        }];
                    break;
                case down:
                        [self setLocation:down];
                        [UIView animateWithDuration:0.5 animations:^{
                            if (self.lastCenter.x == 0) {
                                [delegate arrangeDownButtonsWithButton:self andAdd:YES];
                            }else{
                                [self setFrame:CGRectMake(lastCenter.x - 40, lastCenter.y - 40, 80, 80)];
                            }
                        } completion:^(BOOL finished) {
                            [self.layer setShadowOpacity:0];
                        }];
                    break;
                default:
                    break;
            }

            break;
        case UIGestureRecognizerStateCancelled:
            [self stopShake];
            [self setAlpha:1];
            break;
        case UIGestureRecognizerStateFailed:
            [self stopShake];
            [self setAlpha:1];
            break;
        default:
            break;
    }
}


- (void)startShake
{
    CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    shakeAnimation.duration = 0.08;
    shakeAnimation.autoreverses = YES;
    shakeAnimation.repeatCount = MAXFLOAT;
    shakeAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, -0.1, 0, 0, 1)];
    shakeAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, 0.1, 0, 0, 1)];
    
    [self.layer addAnimation:shakeAnimation forKey:@"shakeAnimation"];
}

- (void)stopShake
{
    [self.layer removeAnimationForKey:@"shakeAnimation"];
}

@end
