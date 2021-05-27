//
//  REMyIncomeTableViewCell.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/29.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootTableViewCell.h"
#import "REIncomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface REMyIncomeTableViewCell : RERootTableViewCell

- (void)showDataWithModel:(REIncomeModel *)model;
@end

NS_ASSUME_NONNULL_END
