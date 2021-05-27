//
//  REYCDetailedTableViewCell.h
//  ReadingEarn
//
//  Created by FANS on 2019/12/2.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootTableViewCell.h"
#import "REBillDetailsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface REYCDetailedTableViewCell : RERootTableViewCell

- (void)showDataWithModel:(REBillDetailsModel *)model;
@end

NS_ASSUME_NONNULL_END
