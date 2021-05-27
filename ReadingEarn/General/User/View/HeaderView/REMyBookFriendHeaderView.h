//
//  REMyBookFriendHeaderView.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/29.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootView.h"
#import "REHeaderBookFriendModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^REHeaderClickBlock)(UIButton *sender,NSString *order);
typedef void (^RESortClickBlock)(UIButton *sender,NSString *order,NSString *tag);
@interface REMyBookFriendHeaderView : RERootView

@property (nonatomic , copy)REHeaderClickBlock headerClickBlock;
@property (nonatomic , copy)RESortClickBlock sortClickBlock;
- (void)showDataWithModel:(REHeaderBookFriendModel *)model withTypeClick:(BOOL)isTypeClick;
@end

NS_ASSUME_NONNULL_END
