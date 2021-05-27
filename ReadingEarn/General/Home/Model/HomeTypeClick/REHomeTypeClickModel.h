//
//  REHomeTypeClickModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/26.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"
#import "REHomeTypeStatusModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface REHomeTypeClickModel : RERootModel
//{
//    attribute = 1;
//    author = "\U6c5f\U5357\U5f3a\U5b50";
//    "charge_type" = 1;
//    "click_count" = 168;
//    contents = "\U4e16\U9053\U8270\U96be\Uff0c\U4eba\U5fc3\U9669\U6076\Uff0c\U505a\U4eba\U7684\U5e95\U7ebf\U5728\U54ea\U91cc\Uff1f\U6709\U4eba\U7684\U5730\U65b9\U5c31\U6709\U6c5f\U6e56\Uff0c\U8c01\U4e5f\U8eb2\U4e0d\U8fc7\U3002\U5bcc\U8d35\U4e5f\U597d\Uff0c\U5351\U5fae\U4e5f\U7f62\Uff0c\U6d3b\U7740\Uff0c\U603b\U8981\U6d3b\U51fa\U4e00\U79cd\U7cbe\U795e\U6765\Uff0c\U4e14\U770b\U4fca\U54e5\U8d2b\U5bd2\U5c11\U5e74\U90fd\U5e02\U6253\U62fc\Uff0c\U4e0e\U547d\U8fd0\U6297\U4e89\Uff0c\U5411\U5c48\U8fb1\U8bf4\U4e0d\Uff0c\U96c4\U5fc3\U52c3\U52c3\U521b\U9020\U8f89\U714c\U4eba\U751f\U7684\U6545\U4e8b\Uff01";
//    coverpic = "http://upload.gxdcsm.com/41c35a2750952f15bcb2b415d610ce03.png";
//    "coverpic_1" = "";
//    "create_time" = 1569419008;
//    "exc_total" = "2168.00";
//    "free_end_time" = 0;
//    "free_start_time" = 0;
//    grade = 98;
//    hots = 99;
//    id = 3;
//    infopic = "";
//    islong = 1;
//    isnew = 1;
//    isover = 1;
//    label = "4,5";
//    likes = 99;
//    nid = d86a283aedd01d5c7260bbcdb1e0e553;
//    "now_word_number" = 0;
//    "pay_total" = "0.00";
//    paychapter = 50;
//    paymoney = "5.00";
//    remark = "";
//    sex = 1;
//    sort = 0;
//    sources = "";
//    "spider_all" = 0;
//    "spider_now" = 0;
//    status = 1;
//    subscribe = 1;
//    "subscribe_chapter" = 0;
//    territory =                 (
//                            {
//            "attribute_name" = "\U70ed\U8840";
//            id = 4;
//            status = 1;
//        },
//                            {
//            "attribute_name" = "\U900d\U9065";
//            id = 5;
//            status = 1;
//        }
//    );
//    title = "\U731b\U9f99\U95ef\U6c5f\U6e56";
//    "update_time" = 1571390397;
//    "word_number_total" = 0;
//}

@property (nonatomic ,copy)NSString *attribute;
@property (nonatomic ,copy)NSString *author;
@property (nonatomic ,copy)NSString *charge_type;
@property (nonatomic ,copy)NSString *click_count;
@property (nonatomic ,copy)NSString *contents;
@property (nonatomic ,copy)NSString *coverpic;
@property (nonatomic ,copy)NSString *coverpic_1;
@property (nonatomic ,copy)NSString *create_time;
@property (nonatomic ,copy)NSString *exc_total;
@property (nonatomic ,copy)NSString *free_end_time;
@property (nonatomic ,copy)NSString *free_start_time;
@property (nonatomic ,copy)NSString *grade;
@property (nonatomic ,copy)NSString *hots;
@property (nonatomic ,copy)NSString *type_id;
@property (nonatomic ,copy)NSString *infopic;
@property (nonatomic ,copy)NSString *islong;
@property (nonatomic ,copy)NSString *isnew;
@property (nonatomic ,copy)NSString *isover;
@property (nonatomic ,copy)NSString *label;
@property (nonatomic ,copy)NSString *likes;
@property (nonatomic ,copy)NSString *nid;
@property (nonatomic ,copy)NSString *now_word_number;
@property (nonatomic ,copy)NSString *pay_total;
@property (nonatomic ,copy)NSString *paychapter;
@property (nonatomic ,copy)NSString *paymoney;
@property (nonatomic ,copy)NSString *remark;
@property (nonatomic ,copy)NSString *sex;
@property (nonatomic ,copy)NSString *sort;
@property (nonatomic ,copy)NSString *sources;
@property (nonatomic ,copy)NSString *spider_all;
@property (nonatomic ,copy)NSString *spider_now;
@property (nonatomic ,copy)NSString *status;
@property (nonatomic ,copy)NSString *subscribe;
@property (nonatomic ,copy)NSString *subscribe_chapter;
@property (nonatomic ,copy)NSMutableArray *territory;
@property (nonatomic ,copy)REHomeTypeStatusModel *homeTypeStatusModel;
@property (nonatomic ,copy)NSString *title;
@property (nonatomic ,copy)NSString *update_time;
@property (nonatomic ,copy)NSString *word_number_total;



@end

NS_ASSUME_NONNULL_END
