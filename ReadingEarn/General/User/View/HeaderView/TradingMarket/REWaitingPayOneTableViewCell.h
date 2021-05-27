//
//  REWaitingPayOneTableViewCell.h
//  ReadingEarn
//
//  Created by FANS on 2019/12/6.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootTableViewCell.h"
#import "REWaitingPayModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface REWaitingPayOneTableViewCell : RERootTableViewCell

- (void)showDataWithModel:(REWaitingPayModel *)model;
@end

NS_ASSUME_NONNULL_END
