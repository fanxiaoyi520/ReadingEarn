//
//  RECommentsListModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/12/10.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"
#import "RECommentListSonModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RECommentsListModel : RERootModel
//book_id: "379"
//content: "asdfasfasdfasdf"
//create_time: "1576064541"
//email: ""
//headimg: ""
//id: "140"
//is_like: 0
//mobile: "153**77"
//nickname: ""
//replay_total: 2
//sons: [{comments_id: "140", content: "adfasdfasdfsadfasfd", replay_time: "1576064562", nickname: "",…},…]
//total_likes: 0
@property (nonatomic ,copy)NSString *book_id;
@property (nonatomic ,copy)NSString *content;
@property (nonatomic ,copy)NSString *create_time;
@property (nonatomic ,copy)NSString *email;
@property (nonatomic ,copy)NSString *headimg;
@property (nonatomic ,copy)NSString *list_id;
@property (nonatomic ,copy)NSString *is_like;
@property (nonatomic ,copy)NSString *mobile;
@property (nonatomic ,copy)NSString *nickname;
@property (nonatomic ,copy)NSString *replay_total;
@property (nonatomic ,copy)NSString *total_likes;
@property (nonatomic ,strong)RECommentListSonModel *commentListSonModel;
@property (nonatomic ,strong)NSMutableArray *sons;
@end

NS_ASSUME_NONNULL_END
