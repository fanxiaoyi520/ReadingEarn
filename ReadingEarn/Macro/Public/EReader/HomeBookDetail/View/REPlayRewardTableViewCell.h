//
//  REPlayRewardTableViewCell.h
//  ReadingEarn
//
//  Created by FANS on 2019/12/11.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootTableViewCell.h"
#import "REPlayRewardModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface REPlayRewardTableViewCell : RERootTableViewCell

- (void)showDataWithModel:(REPlayRewardModel *)model;
@end

NS_ASSUME_NONNULL_END
