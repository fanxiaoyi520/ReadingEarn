//
//  UIScrollView+QFRefresh.m
//  MasonryTest
//
//  Created by yanghy on 2019/10/30.
//  Copyright © 2019 majq. All rights reserved.
//

#import "UIScrollView+QFRefresh.h"
#import <MJRefresh/MJRefresh.h>

@implementation UIScrollView (QFRefresh)


- (void)qf_refreshHeaderBlock:(QFRefreshRefreshingBlock)refreshingBlock
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:refreshingBlock];
    
    header.lastUpdatedTimeLabel.hidden = YES;   //隐藏时间
    header.stateLabel.hidden = NO;  //隐藏文字
    
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在加载 ..." forState:MJRefreshStateRefreshing];
    
    header.stateLabel.font = [UIFont systemFontOfSize:13];  // Set font
    //header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    
    header.stateLabel.textColor = [UIColor blackColor];   // Set textColor
    //header.lastUpdatedTimeLabel.textColor = [UIColor blueColor];
    
    self.mj_header = header;
}

- (void)qf_refreshFooterBlock:(QFRefreshRefreshingBlock)refreshingBlock
{
//    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:refreshingBlock];
//
//    [footer setTitle:@"" forState:MJRefreshStateIdle];
//    [footer setTitle:@"" forState:MJRefreshStatePulling];
//    [footer setTitle:@"" forState:MJRefreshStateRefreshing];
//    [footer setTitle:@"这就是我的底线~~" forState:MJRefreshStateNoMoreData];
//
//    footer.stateLabel.font = [UIFont systemFontOfSize:13];  // Set font
//    footer.stateLabel.textColor = [UIColor blackColor]; ;  // Set textColor
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:refreshingBlock];
    footer.backgroundColor = [UIColor orangeColor];
    
    footer.stateLabel.hidden = NO;
    footer.stateLabel.font = [UIFont systemFontOfSize:13];
    footer.stateLabel.textColor = [UIColor blackColor];
    //footer.ignoredScrollViewContentInsetBottom = IS_IPHONEX ? 10 : 0;
    footer.arrowView.image = [UIImage imageNamed:@"common_loading_down"];
    footer.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    footer.labelLeftInset = 0;
    
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"" forState:MJRefreshStatePulling];
    [footer setTitle:@"" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"这就是我的底线~~" forState:MJRefreshStateNoMoreData];
    
    self.mj_footer = footer;
}

- (void)qf_endHeaderRefreshing
{
    if (self.mj_header.isRefreshing) {
        [self.mj_header endRefreshing];
    }
}

- (void)qf_endFooterRefreshing
{
    if (self.mj_footer.isRefreshing) {
        [self.mj_footer endRefreshing];
    }
}

- (void)qf_endRefreshing
{
    [self qf_endHeaderRefreshing];
    [self qf_endFooterRefreshing];
}

- (void)qf_beginRefreshing
{
    if (self.mj_header) {
        [self.mj_header beginRefreshing];
    }
}

- (void)qf_beginRefreshingWithCompletionBlock:(void (^)(void))completionBlock
{
    if (self.mj_header) {
        [self.mj_header beginRefreshingWithCompletionBlock:completionBlock];
    }
}


- (void)qf_resetNoMoreData
{
    if (self.mj_footer) {
        [self.mj_footer resetNoMoreData];
    }
}

- (void)qf_endRefreshingWithNoMoreData
{
    if (self.mj_footer) {
        [self.mj_footer endRefreshingWithNoMoreData];
    }
}

@end
