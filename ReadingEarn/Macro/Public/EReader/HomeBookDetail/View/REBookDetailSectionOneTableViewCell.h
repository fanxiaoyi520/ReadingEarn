//
//  REBookDetailSectionOneTableViewCell.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/25.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootTableViewCell.h"
#import "REBookInfoModel.h"
#import "REBookInfoTerritoryModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^REStartReadBlock)(UIButton *sender);
typedef void (^REJionBookShelfBlock)(UIButton *sender);
@interface REBookDetailSectionOneTableViewCell : RERootTableViewCell

@property (nonatomic ,copy)REStartReadBlock startReadBlock;
@property (nonatomic ,copy)REJionBookShelfBlock jionBookShelfBlock;
- (void)showDataWithModel:(REBookInfoModel *)model withStr:(NSString *)is_Collection;
@end

NS_ASSUME_NONNULL_END
