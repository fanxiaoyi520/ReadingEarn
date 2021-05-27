//
//  RECommentsModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/12/10.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"
#import "RECommentsListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RECommentsModel : RERootModel
//list =             (
//);
//total = 0;
@property (nonatomic ,strong)RECommentsListModel *commentsListModel;
@property (nonatomic ,strong)NSMutableArray *list;
@property (nonatomic ,copy)NSString *total;

@end

NS_ASSUME_NONNULL_END
