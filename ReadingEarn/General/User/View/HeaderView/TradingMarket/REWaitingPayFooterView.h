//
//  REWaitingPayFooterView.h
//  ReadingEarn
//
//  Created by FANS on 2019/12/6.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootView.h"
#import "REWaitingPayModel.h"
#import "REAppealStatusModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^REPayOrCancelBlock)(UIButton *sender);
@interface REWaitingPayFooterView : RERootView

@property (nonatomic ,copy)REPayOrCancelBlock payOrCancelBlock;
- (instancetype)initWithFrame:(CGRect)frame withType:(NSString *)type;
- (void)showDataWithModel:(REWaitingPayModel *)model withType:(NSString *)type withModel:(REAppealStatusModel *)statusModel;
@end

NS_ASSUME_NONNULL_END
