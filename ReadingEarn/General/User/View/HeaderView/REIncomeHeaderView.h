//
//  REIncomeHeaderView.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/29.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^REIncomeHeaderBlock)(UIButton *sender,NSString *order);
@interface REIncomeHeaderView : RERootView

@property (nonatomic ,copy)REIncomeHeaderBlock incomeHeaderBlock;
- (void)shouDataWithModel:(NSString *)model withTypeClick:(BOOL)isTypeClick;
@end

NS_ASSUME_NONNULL_END
