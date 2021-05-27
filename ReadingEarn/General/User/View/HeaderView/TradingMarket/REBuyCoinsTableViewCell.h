//
//  REBuyCoinsTableViewCell.h
//  ReadingEarn
//
//  Created by FANS on 2019/12/5.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootTableViewCell.h"
#import "REBuyCoinsModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void (^REBuyBlock)(UIButton *sender,UITableViewCell *cell,NSString *type);
@interface REBuyCoinsTableViewCell : RERootTableViewCell

@property (nonatomic ,copy)REBuyBlock buyBlock;
- (void)showDataWithModel:(REBuyCoinsModel *)model withType:(NSString *)type;
@end

NS_ASSUME_NONNULL_END
