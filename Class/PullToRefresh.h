//
//  PullToRefresh.h
//  pulltoRefresh
//
//  Created by ding_qili on 2017/3/8.
//  Copyright © 2017年 ding_qili. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PullToRefreshPosition_Top,
    PullToRefreshPosition_Bottom,
} PullToRefreshPosition;


typedef enum : NSUInteger {
    PullToRefreshState_initial,
    PullToRefreshState_releasing,
    PullToRefreshState_loading,
    PullToRefreshState_finished,
} PullToRefreshState;

@protocol PullToRefreshViewAnimator <NSObject>

-(void)animator:(PullToRefreshState)state any:(_Nullable id)any;

@end

@interface PullToRefresh : UIView

@property(nonatomic,assign) PullToRefreshPosition position;
@property(weak,nonatomic) UIScrollView * _Nullable scrollView;
@property(nonatomic,weak) id <PullToRefreshViewAnimator> refreshView;
@property (nonatomic, copy,nullable) void (^action)(void);
@property (nonatomic, assign) BOOL showsPullToRefresh;

-(void)startRefreshing;
-(void)endRefreshing;

@end
