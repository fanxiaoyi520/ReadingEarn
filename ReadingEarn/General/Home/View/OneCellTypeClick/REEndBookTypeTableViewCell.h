//
//  REEndBookTypeTableViewCell.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/26.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootTableViewCell.h"
#import "REBookTypeModel.h"
#import "REEndBookTypeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface REEndBookTypeTableViewCell : RERootTableViewCell
- (void)showDataWithModel:(REEndBookTypeModel *)model;
@end

NS_ASSUME_NONNULL_END
