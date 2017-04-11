//
//  DefaultRefreshView.m
//  pulltoRefresh
//
//  Created by ding_qili on 2017/3/9.
//  Copyright © 2017年 ding_qili. All rights reserved.
//

#import "DefaultRefreshView.h"

@interface DefaultRefreshView()
@property (strong,nonatomic) UIActivityIndicatorView * indicatorView;
@end

@implementation DefaultRefreshView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.indicatorView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:self.indicatorView];
        NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self.indicatorView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
        NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self.indicatorView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
        [self addConstraint:centerX];
        [self addConstraint:centerY];
        
    }
    return self;
}

-(void)animator:(PullToRefreshState)state any:(_Nullable id)any{
    switch (state) {
        case PullToRefreshState_initial:
            [self.indicatorView stopAnimating];
            break;
        case PullToRefreshState_releasing:
            self.indicatorView.hidden = NO;
            if (any != nil) {
                NSNumber *number = (NSNumber *)any;
                CGFloat progress = number.floatValue;
                CGAffineTransform transform  = CGAffineTransformIdentity;
                CGAffineTransformScale(transform, progress, progress);
                CGAffineTransformRotate(transform, M_PI * progress * 2);
                self.indicatorView.transform = transform;
            }
            break;
        case PullToRefreshState_loading:
             [self.indicatorView startAnimating];
            break;
            
        default:
            break;
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self setupFrame:self.superview];
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    [self setupFrame:self.superview];
}

-(void)setupFrame:(UIView *)newSuperview{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, newSuperview.frame.size.width, self.frame.size.height);
}


@end
