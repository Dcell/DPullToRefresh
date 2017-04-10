//
//  PullToRefresh.m
//  pulltoRefresh
//
//  Created by ding_qili on 2017/3/8.
//  Copyright © 2017年 ding_qili. All rights reserved.
//

#import "PullToRefresh.h"
#import "DefaultRefreshView.h"

NSString *KVOContext = @"PullToRefreshKVOContext";
NSString *contentOffsetKeyPath = @"contentOffset";
NSString *contentInsetKeyPath = @"contentInset";
NSString *contentSizeKeyPath = @"contentSize";

@interface PullToRefresh()
@property(nonatomic,assign) PullToRefreshState state;
@end

@implementation PullToRefresh {
    BOOL isObserving;
    CGPoint previousScrollViewOffset;
    UIEdgeInsets scrollViewDefaultInsets;
    CGFloat dragProgress;
    PullToRefreshState mState;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        previousScrollViewOffset = CGPointZero;
        scrollViewDefaultInsets = UIEdgeInsetsZero;
        dragProgress = 0.0;
        mState = PullToRefreshState_initial;
    }
    return self;
}


-(void)dealloc{
    [self removeScrollViewObserving];
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if (self.superview && newSuperview == nil) {
        [self removeUnknowSuperView:self.superview];
    }
}


-(void)startRefreshing{
    if (self.state != PullToRefreshState_initial) {
        return;
    }
    
    CGFloat offsetY;
    switch (self.position) {
        case PullToRefreshPosition_Top:
            offsetY = -(self.frame.size.height) - scrollViewDefaultInsets.top;
            break;
        case PullToRefreshPosition_Bottom:
            offsetY = self.scrollView.contentSize.height + self.frame.size.height + scrollViewDefaultInsets.bottom - self.scrollView.bounds.size.height;
            break;
            
        default:
            break;
    }
    [self.scrollView setContentOffset:CGPointMake(0, offsetY) animated:YES];
    self.state = PullToRefreshState_loading;
}

-(void)endRefreshing{
    if (self.state == PullToRefreshState_loading) {
        self.state = PullToRefreshState_finished;
    }
}


-(void)setState:(PullToRefreshState)state{
    PullToRefreshState oldValue = mState;
    mState = state;
    if (mState == PullToRefreshState_releasing) {
        [self.refreshView animator:mState any:[[NSNumber alloc] initWithFloat:dragProgress]];
    }else{
        [self.refreshView animator:mState any:nil];
    }
    switch (mState) {
        case PullToRefreshState_loading:
            if (oldValue != PullToRefreshState_loading) {
                [self animateLoadingState];
            }
            break;
        case PullToRefreshState_finished:
            if ([self isCurrentlyVisible]) {
                [self animateFinishedState];
            }else{
                self.scrollView.contentInset = scrollViewDefaultInsets;
                mState = PullToRefreshState_initial;
            }
            break;
            
        default:
            break;
    }
}

-(PullToRefreshState)state{
    return mState;
}


-(void)setShowsPullToRefresh:(BOOL)showsPullToRefresh{
    if (showsPullToRefresh) {
        [self addScrollViewObserving];
    }else{
        [self removeScrollViewObserving];
    }
}

-(void)animateLoadingState{
    if (self.scrollView == nil) {
        return;
    }    
    self.scrollView.contentOffset = previousScrollViewOffset;
    if (self.position == PullToRefreshPosition_Top) {
        [UIView animateWithDuration:0.3 animations:^{
            CGFloat insets =  self.frame.size.height + scrollViewDefaultInsets.top;
            UIEdgeInsets currentInsets = self.scrollView.contentInset;
            currentInsets.top = insets;
            [self.scrollView setContentInset:currentInsets]; //修改inset 显示出topView
            [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, -insets) animated:YES];
        }];
    }else if(self.position == PullToRefreshPosition_Bottom){
        [UIView animateWithDuration:0.3 animations:^{
            CGFloat insets = self.frame.size.height + scrollViewDefaultInsets.bottom;
            UIEdgeInsets currentInsets = self.scrollView.contentInset;
            currentInsets.bottom = insets;
            [self.scrollView setContentInset:currentInsets]; //修改inset 显示出bottomView
        }];

    }
    self.action();
    
}

-(void)animateFinishedState{
    if (self.position == PullToRefreshPosition_Top) {
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollView.contentInset = scrollViewDefaultInsets;//还原内边距
            CGPoint contentOffset =  self.scrollView.contentOffset;
            contentOffset.y = -scrollViewDefaultInsets.top;
            [self.scrollView setContentOffset:contentOffset animated:YES];
        }];

    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollView.contentInset = scrollViewDefaultInsets;//还原内边距
        }];
    }
    mState  = PullToRefreshState_initial;
}


-(BOOL)isCurrentlyVisible{
    if (self.scrollView == nil) {
        return NO;
    }
    return self.scrollView.contentOffset.y <= -scrollViewDefaultInsets.top;
}


-(void)addScrollViewObserving{
    if (self.scrollView == nil || isObserving) {
        return;
    }
    [self.scrollView addObserver:self forKeyPath:contentOffsetKeyPath options:NSKeyValueObservingOptionInitial context:&KVOContext];
    [self.scrollView addObserver:self forKeyPath:contentSizeKeyPath options:NSKeyValueObservingOptionInitial context:&KVOContext];
    [self.scrollView addObserver:self forKeyPath:contentInsetKeyPath options:NSKeyValueObservingOptionInitial context:&KVOContext];
    isObserving = YES;
}

-(void)removeScrollViewObserving{
    if (self.scrollView == nil || !isObserving) {
        return;
    }
    [self.scrollView removeObserver:self forKeyPath:contentOffsetKeyPath];
    [self.scrollView removeObserver:self forKeyPath:contentSizeKeyPath];
    [self.scrollView removeObserver:self forKeyPath:contentInsetKeyPath];
    isObserving = NO;
}

-(void)removeUnknowSuperView:(NSObject *)object{
    [object removeObserver:self forKeyPath:contentOffsetKeyPath];
    [object removeObserver:self forKeyPath:contentSizeKeyPath];
    [object removeObserver:self forKeyPath:contentInsetKeyPath];
    isObserving = NO;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    previousScrollViewOffset.y = self.scrollView.contentOffset.y;
    if (context == &KVOContext) {
        if (keyPath == contentOffsetKeyPath) {
            CGFloat offset;
            switch (self.position) {
                case PullToRefreshPosition_Top:
                    offset = previousScrollViewOffset.y + scrollViewDefaultInsets.top;
                    break;
                case PullToRefreshPosition_Bottom:
                    if (self.scrollView.contentSize.height > self.scrollView.bounds.size.height) {
                        offset = self.scrollView.contentSize.height - previousScrollViewOffset.y - self.scrollView.bounds.size.height;
                    } else {
                        offset =  - previousScrollViewOffset.y;
                    }
                    break;
                default:
                    break;
            }

            CGFloat refreshViewHeight = self.frame.size.height;
            if (offset == 0) {
                if (self.state != PullToRefreshState_loading) {
                    self.state = PullToRefreshState_initial;
                }
            }else if(offset > -refreshViewHeight && offset < 0){
                if (self.state != PullToRefreshState_loading && self.state != PullToRefreshState_finished) {
                    dragProgress = -offset / refreshViewHeight;
                    self.state = PullToRefreshState_releasing;
                }
            }else if(offset > -1000. && offset < -refreshViewHeight){
                if (self.state == PullToRefreshState_releasing && dragProgress == 1 && self.scrollView.isDragging == NO) {
                    self.state = PullToRefreshState_loading;
                }else if(self.state != PullToRefreshState_loading && self.state != PullToRefreshState_finished){
                    dragProgress = 1;
                    self.state = PullToRefreshState_releasing;
                }
            }
        } else if(keyPath == contentSizeKeyPath) {
            if (self.position == PullToRefreshPosition_Bottom) {
                self.frame = CGRectMake(0, self.scrollView.contentSize.height, self.scrollView.bounds.size.width, self.bounds.size.height);
            }
        } else if(keyPath == contentInsetKeyPath){
            if (self.state == PullToRefreshState_initial) {
                scrollViewDefaultInsets = self.scrollView.contentInset;
            }

        }else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
