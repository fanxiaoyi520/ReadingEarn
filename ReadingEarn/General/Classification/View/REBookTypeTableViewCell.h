//
//  REBookTypeTableViewCell.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/19.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootTableViewCell.h"
#import "REBookTypeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface REBookTypeTableViewCell : RERootTableViewCell

- (void)showDataWithModel:(REBookTypeModel *)model;
@end

NS_ASSUME_NONNULL_END
