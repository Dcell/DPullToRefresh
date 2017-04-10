//
//  UIScrollView+PullToRefresh.h
//  pulltoRefresh
//
//  Created by ding_qili on 2017/3/8.
//  Copyright © 2017年 ding_qili. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefresh.h"

@interface UIScrollView (PullToRefresh)

@property (nonatomic, strong, readonly) PullToRefresh *topPullToRefreshView;//Top pullToRefreshView
@property (nonatomic, strong, readonly) PullToRefresh *bottomPullToRefreshView;//Buttom pullToRefreshView

//add a PullToRefresh
- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler;
-(void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler refreshView:(UIView<PullToRefreshViewAnimator> *)refreshView;
//add a Infinite
- (void)addInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler;
-(void)addInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler refreshView:(UIView<PullToRefreshViewAnimator> *)refreshView;
//PullToRefresh by yourself
- (void)triggerPullToRefresh __deprecated_msg("use topPullToRefreshView.startRefreshing");
//Infinite by yourself
- (void)triggerInfiniteScrolling __deprecated_msg("use bottomPullToRefreshView.startRefreshing");
@end
