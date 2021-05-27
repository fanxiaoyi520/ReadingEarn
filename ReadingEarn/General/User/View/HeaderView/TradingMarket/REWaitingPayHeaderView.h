//
//  REWaitingPayHeaderView.h
//  ReadingEarn
//
//  Created by FANS on 2019/12/6.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootView.h"
#import "REWaitingPayModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^REAppealBlock)(UIButton *sender);
@interface REWaitingPayHeaderView : RERootView

@property (nonatomic ,copy)REAppealBlock appealBlock;
- (void)showDataWithModel:(REWaitingPayModel *)model;
@end

NS_ASSUME_NONNULL_END
