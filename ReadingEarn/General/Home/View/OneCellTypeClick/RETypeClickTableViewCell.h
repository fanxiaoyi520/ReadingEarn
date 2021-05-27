//
//  RETypeClickTableViewCell.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/26.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootTableViewCell.h"
#import "REHomeTypeClickModel.h"
#import "REHomeTypeStatusModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RETypeClickTableViewCell : RERootTableViewCell

- (void)showDataWithModel:(REHomeTypeClickModel *)model;
@end

NS_ASSUME_NONNULL_END
