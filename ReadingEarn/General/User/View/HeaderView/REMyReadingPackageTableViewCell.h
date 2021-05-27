//
//  REMyReadingPackageTableViewCell.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/30.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootTableViewCell.h"
#import "REMyReadingPackageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface REMyReadingPackageTableViewCell : RERootTableViewCell

- (void)showDataWithModel:(REMyReadingPackageModel *)model;
@end

NS_ASSUME_NONNULL_END
