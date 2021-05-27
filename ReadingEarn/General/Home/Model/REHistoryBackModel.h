//
//  REHistoryBackModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/12/10.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface REHistoryBackModel : RERootModel
//    "ad_code" = "http://images.xiaocao4.cn/2019102819362373729.jpg";
//    "ad_link" = 0;
//    "ad_name" = "\U9996\U9875\U9605\U8bfb\U8bb0\U5f55-\U6709\U8bb0\U5f55\U80cc\U666f\U56fe";
//    bgcolor = "";
//    "channel_nid" = jingxuan;
//    "click_count" = 0;
//    enabled = 1;
//    "end_time" = 1572451200;
//    id = 113;
//    "link_email" = "";
//    "link_man" = "";
//    "link_phone" = "";
//    "media_type" = 0;
//    pid = 1625;
//    remark = "";
//    sort = 1;
//    "start_time" = 1572192000;
//    target = 1;
//    towpic = "<null>";
@property (nonatomic ,copy)NSString *ad_code;
@property (nonatomic ,copy)NSString *ad_link;
@property (nonatomic ,copy)NSString *ad_name;
@property (nonatomic ,copy)NSString *bgcolor;
@property (nonatomic ,copy)NSString *channel_nid;
@property (nonatomic ,copy)NSString *click_count;
@property (nonatomic ,copy)NSString *enabled;
@property (nonatomic ,copy)NSString *back_id;
@property (nonatomic ,copy)NSString *link_email;
@property (nonatomic ,copy)NSString *link_man;
@property (nonatomic ,copy)NSString *link_phone;
@property (nonatomic ,copy)NSString *media_type;
@property (nonatomic ,copy)NSString *pid;
@property (nonatomic ,copy)NSString *remark;
@property (nonatomic ,copy)NSString *sort;
@property (nonatomic ,copy)NSString *start_time;
@property (nonatomic ,copy)NSString *target;
@property (nonatomic ,copy)NSString *towpic;
@end

NS_ASSUME_NONNULL_END
