//
//  REReadHistoryModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/12/10.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface REReadHistoryModel : RERootModel
//readHistory =         {
//    "book_id" = 3725;
//    "chapter_name" = "\n\U7b2c1\U7ae0 \U540e\U8f66\U5ea7";
//    "chapter_number" = 1;
//    coverpic = "http://images.xiaocao4.cn/ec0436aaddaac179b3476967158d44b3.png";
//    "create_time" = 1575951190;
//    id = 560;
//    "mch_id" = 0;
//    status = 1;
//    "user_id" = 807085;
//};
@property (nonatomic ,copy)NSString *book_id;
@property (nonatomic ,copy)NSString *chapter_name;
@property (nonatomic ,copy)NSString *chapter_number;
@property (nonatomic ,copy)NSString *coverpic;
@property (nonatomic ,copy)NSString *create_time;
@property (nonatomic ,copy)NSString *history_id;
@property (nonatomic ,copy)NSString *mch_id;
@property (nonatomic ,copy)NSString *status;
@property (nonatomic ,copy)NSString *user_id;
@end

NS_ASSUME_NONNULL_END
