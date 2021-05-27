//
//  REReadingHistoryModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/22.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface REReadingHistoryModel : RERootModel
//"book_id" = 43;
//"chapter_name" = "\n\U7b2c2\U7ae0\U6211\U8001\U5a46";
//"chapter_number" = 2;
//coverpic = "http://images.xiaocao4.cn/3ec0d3a023ffc230270102775ecad515.png";
//"create_time" = 1574403234;
//id = 25;
//"is_collect" = 1;
//isover = 1;
//label = "23,24";
//"mch_id" = 0;
//status = 1;
//territory = "\U7a7f\U8d8a\U67b6\U7a7a";
//title = "\U70ed\U8840\U519b\U795e\U5316\U8eab\U67d4\U60c5\U4fdd\U9556";
//"user_id" = 807079;
@property (nonatomic ,copy)NSString *book_id;
@property (nonatomic ,copy)NSString *chapter_name;
@property (nonatomic ,copy)NSString *chapter_number;
@property (nonatomic ,copy)NSString *coverpic;
@property (nonatomic ,copy)NSString *create_time;
@property (nonatomic ,copy)NSString *readingHistory_id;
@property (nonatomic ,copy)NSString *is_collect;
@property (nonatomic ,copy)NSString *isover;
@property (nonatomic ,copy)NSString *label;
@property (nonatomic ,copy)NSString *mch_id;
@property (nonatomic ,copy)NSString *status;
@property (nonatomic ,copy)NSString *territory;
@property (nonatomic ,copy)NSString *title;
@property (nonatomic ,copy)NSString *user_id;
@end

NS_ASSUME_NONNULL_END
