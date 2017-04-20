# DPullToRefresh
merge from https://github.com/samvermette/SVPullToRefresh.git & https://github.com/Yalantis/PullToRefresh.git

## DPullRefresh is an extension to TableView & CollectionView. It has a default drop-down and pull-up effect, of course, you can also customize their own, only need to achieve the relevant agreement

### Install by CocoaPod
`pod 'DPullToRefresh','0.0.8'`
### import By Object-C
`#import <DPullToRefresh/UIScrollView+PullToRefresh.h>`
### import By Swift
`import DPullToRefresh`
### add a TopPullToRefresh
```
[self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf refresh];
    }];
```
### add a buttomToRefresh
``` 
[self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf getMore];
    }];
```
### stop | start
```
[tableView.topPullToRefreshView startRefreshing];
[tableView.buttomPullToRefreshView startRefreshing];

[tableView.topPullToRefreshView endRefreshing];
[tableView.buttomPullToRefreshView endRefreshing];
```


