//
//  REBookDetailSectionThreeTableViewCell.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/25.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootTableViewCell.h"
#import "REGraInfoModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^REMorePalyRewardBlock)(UIButton *sender);
@interface REBookDetailSectionThreeTableViewCell : RERootTableViewCell

@property (nonatomic ,copy)REMorePalyRewardBlock morePalyRewardBlock;
- (void)showDataWithModel:(NSMutableArray *)model;
@end

NS_ASSUME_NONNULL_END
