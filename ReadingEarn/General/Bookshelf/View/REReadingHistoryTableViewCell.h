//
//  REReadingHistoryTableViewCell.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/22.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootTableViewCell.h"
#import "REReadingHistoryModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^REBookShelfBlock)(UIButton *sender);
typedef void (^REDeleteBlock)(UITableViewCell *currentCell);
@interface REReadingHistoryTableViewCell : RERootTableViewCell

@property (nonatomic , copy)REBookShelfBlock bookShelfBlock;
@property (nonatomic , copy)REDeleteBlock deleteBlock;
- (void)showDataWithModel:(REReadingHistoryModel *)model;
@end

NS_ASSUME_NONNULL_END
