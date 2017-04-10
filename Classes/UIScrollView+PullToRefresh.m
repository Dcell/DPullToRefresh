//
//  UIScrollView+PullToRefresh.m
//  pulltoRefresh
//
//  Created by ding_qili on 2017/3/8.
//  Copyright © 2017年 ding_qili. All rights reserved.
//
#import <objc/runtime.h>
#import "UIScrollView+PullToRefresh.h"
#import "PullToRefresh.h"
#import "DefaultRefreshView.h"

static char UIScrollViewTopPullToRefreshView;
static char UIScrollViewBottomPullToRefreshView;
@implementation UIScrollView (PullToRefresh)

@dynamic topPullToRefreshView, bottomPullToRefreshView;

- (void)setTopPullToRefreshView:(PullToRefresh *)pullToRefreshView {
    [self willChangeValueForKey:@"TopPullToRefreshView"];
    objc_setAssociatedObject(self, &UIScrollViewTopPullToRefreshView,
                             pullToRefreshView,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"TopPullToRefreshView"];
}

- (PullToRefresh *)topPullToRefreshView {
    return objc_getAssociatedObject(self, &UIScrollViewTopPullToRefreshView);
}


- (void)setBottomPullToRefreshView:(PullToRefresh *)pullToRefreshView {
    [self willChangeValueForKey:@"BottomPullToRefreshView"];
    objc_setAssociatedObject(self, &UIScrollViewBottomPullToRefreshView,
                             pullToRefreshView,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"BottomPullToRefreshView"];
}

- (PullToRefresh *)bottomPullToRefreshView {
    return objc_getAssociatedObject(self, &UIScrollViewBottomPullToRefreshView);
}


-(void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler refreshView:(UIView<PullToRefreshViewAnimator> *)refreshView {
    PullToRefresh *pullToRefresh  = [[PullToRefresh alloc] initWithFrame:refreshView.frame];
    [pullToRefresh setTranslatesAutoresizingMaskIntoConstraints:NO];
    pullToRefresh.scrollView = self;
    pullToRefresh.refreshView = refreshView;
    pullToRefresh.position = PullToRefreshPosition_Top;
    pullToRefresh.action = actionHandler;
    self.topPullToRefreshView = pullToRefresh;
    [self addSubview:pullToRefresh];
    
    CGFloat insetTop = self.contentInset.top;
    
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:pullToRefresh attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:pullToRefresh attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-insetTop];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:pullToRefresh attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:refreshView.frame.size.width];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:pullToRefresh attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:refreshView.frame.size.height];
    
    [self addConstraints:@[centerX,bottom,width,height]];
    
    [pullToRefresh addSubview:refreshView];
    pullToRefresh.showsPullToRefresh = YES;
    
}
-(void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler{
    DefaultRefreshView *defaultRefreshView = [[DefaultRefreshView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    [self addPullToRefreshWithActionHandler:actionHandler refreshView:defaultRefreshView];
}
-(void)triggerPullToRefresh{
    [self.topPullToRefreshView startRefreshing];
}
    
    
-(void)addInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler refreshView:(UIView<PullToRefreshViewAnimator> *)refreshView {
    PullToRefresh *pullToRefresh  = [[PullToRefresh alloc] initWithFrame:refreshView.frame];
    pullToRefresh.scrollView = self;
    pullToRefresh.action = actionHandler;
    pullToRefresh.position = PullToRefreshPosition_Bottom;
    pullToRefresh.refreshView = refreshView;
    self.bottomPullToRefreshView = pullToRefresh;
    refreshView.frame = CGRectMake(0, 0, self.frame.size.width, refreshView.frame.size.height);
    [self addSubview:pullToRefresh];
    [pullToRefresh addSubview:refreshView];
    pullToRefresh.showsPullToRefresh = YES;
}
-(void)addInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler{
    DefaultRefreshView *defaultRefreshView = [[DefaultRefreshView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    [self addInfiniteScrollingWithActionHandler:actionHandler refreshView:defaultRefreshView];
}
-(void)triggerInfiniteScrolling{
    [self.bottomPullToRefreshView startRefreshing];
}

@end
