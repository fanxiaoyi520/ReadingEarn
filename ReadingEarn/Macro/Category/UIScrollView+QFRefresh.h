//
//  UIScrollView+QFRefresh.h
//  MasonryTest
//
//  Created by yanghy on 2019/10/30.
//  Copyright © 2019 majq. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^QFRefreshRefreshingBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (QFRefresh)

- (void)qf_refreshHeaderBlock:(QFRefreshRefreshingBlock)refreshingBlock;
- (void)qf_refreshFooterBlock:(QFRefreshRefreshingBlock)refreshingBlock;

- (void)qf_endHeaderRefreshing;
- (void)qf_endFooterRefreshing;
- (void)qf_endRefreshing;

- (void)qf_beginRefreshing;
- (void)qf_beginRefreshingWithCompletionBlock:(void (^)(void))completionBlock;

- (void)qf_resetNoMoreData;
- (void)qf_endRefreshingWithNoMoreData;
@end

NS_ASSUME_NONNULL_END
