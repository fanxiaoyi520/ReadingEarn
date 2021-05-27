//
//  REMyAdTableViewCell.h
//  ReadingEarn
//
//  Created by FANS on 2019/12/9.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootTableViewCell.h"
#import "REMyAdModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^RECancelBlock)(UIButton *sender,UITableViewCell *mycell);
@interface REMyAdTableViewCell : RERootTableViewCell

@property (nonatomic ,copy)RECancelBlock cancelBlock;
- (void)showDataWithModel:(REMyAdModel *)model;
@end

NS_ASSUME_NONNULL_END
