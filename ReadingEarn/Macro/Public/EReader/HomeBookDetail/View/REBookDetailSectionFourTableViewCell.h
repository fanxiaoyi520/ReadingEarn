//
//  REBookDetailSectionFourTableViewCell.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/25.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootTableViewCell.h"
#import "RECommentsListModel.h"
#import "RECommentListSonModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^REDianzanBlock)(UIButton *sender,NSString *contents_id,UITableViewCell *mycell);
typedef void (^REReplyBlock)(UIButton *sender,NSString *contents_id,UITableViewCell *mycell);
@interface REBookDetailSectionFourTableViewCell : RERootTableViewCell

@property (nonatomic ,copy)REDianzanBlock dianzanBlock;
@property (nonatomic ,copy)REReplyBlock replyBlock;
- (void)showDataWithModel:(RECommentsListModel *)model;
- (void)showDataWithModel;
@end

NS_ASSUME_NONNULL_END
