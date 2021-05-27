//
//  REBookDetailSectionFiveTableViewCell.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/25.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootTableViewCell.h"
#import "RELikeListModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^REBtnClickBlock)(UIButton *sender,NSString *book_id,NSString *imageStr);
@interface REBookDetailSectionFiveTableViewCell : RERootTableViewCell

@property (nonatomic ,copy)REBtnClickBlock btnClickBlock;
- (void)showDataWithModel:(NSMutableArray *)model;
@end

NS_ASSUME_NONNULL_END
