//
//  RESearchModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/25.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RESearchModel : RERootModel
//  "remark" : "",
//  "id" : 29,
//  "hots" : 97,
//  "title" : "逆天重生：都市仙君",
//  "coverpic" : "http:\/\/upload.gxdcsm.com\/2019101900130537060.jpg",
//  "contents" : "正式版：元婴期修士苏择重回少年时代，逆天修仙，以无敌姿态征服一切，弥补前世缺憾。高能版：仙君重生都市，扮猪吃虎，吊打三界不服；傲娇萝莉、清纯校花、冰山总裁......都想和他在一起。",
//  "label" : "19,20",
//  "likes" : 96,
//  "territory" : [
//    {
//      "id" : 19,
//      "status" : 1,
//      "attribute_name" : "风流"
//    },
//    {
//      "id" : 20,
//      "status" : 1,
//      "attribute_name" : "情种"
//    }
//  ],
//  "click_count" : 0
//},
@property (nonatomic ,copy)NSString *remark;
@property (nonatomic ,copy)NSString *search_id;
@property (nonatomic ,copy)NSString *hots;
@property (nonatomic ,copy)NSString *title;
@property (nonatomic ,copy)NSString *coverpic;
@property (nonatomic ,copy)NSString *contents;
@property (nonatomic ,copy)NSString *label;
@property (nonatomic ,copy)NSString *likes;
//@property (nonatomic ,copy)NSMutableArray *territory;
@property (nonatomic ,copy)NSString *click_count;
@end

NS_ASSUME_NONNULL_END
