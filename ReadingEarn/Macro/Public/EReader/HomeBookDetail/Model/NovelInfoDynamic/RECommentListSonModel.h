//
//  RECommentListSonModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/12/11.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RECommentListSonModel : RERootModel
//comments_id: "140"
//content: "adfasdfasdfsadfasfd"
//email: ""
//mobile: "153**77"
//nickname: ""
//replay_time: "1576064562"
@property (nonatomic ,copy)NSString *comments_id;
@property (nonatomic ,copy)NSString *content;
@property (nonatomic ,copy)NSString *email;
@property (nonatomic ,copy)NSString *mobile;
@property (nonatomic ,copy)NSString *nickname;
@property (nonatomic ,copy)NSString *replay_time;
@end

NS_ASSUME_NONNULL_END
