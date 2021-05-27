//
//  REMyOrderTableViewCell.h
//  ReadingEarn
//
//  Created by FANS on 2019/12/5.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootTableViewCell.h"
#import "REMyOrderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface REMyOrderTableViewCell : RERootTableViewCell

- (void)showDataWithModel:(REMyOrderModel *)model;
@end

NS_ASSUME_NONNULL_END
