//
//  REBookFriendTableViewCell.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/29.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootTableViewCell.h"
#import "REHeaderBookFriendCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface REBookFriendTableViewCell : RERootTableViewCell

- (void)showDataWithModel:(REHeaderBookFriendCellModel *)model;
@end

NS_ASSUME_NONNULL_END
