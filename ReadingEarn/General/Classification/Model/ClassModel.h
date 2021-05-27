//
//  ClassModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/18.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ClassModel : RERootModel
//attribute = "4,5";
//"attribute_name" = "\U70ed\U8840/\U900d\U9065";
//channel = "\U7537\U9891";
//"channel_nid" = man;
//icon = "http://images.xiaocao4.cn/2019092423382439705.jpg";
//id = 18;
//name = "\U90fd\U5e02";
//nid = a;
//sort = 1;
//status = 1;

@property (nonatomic ,copy)NSString *attribute;
@property (nonatomic ,copy)NSString *attribute_name;
@property (nonatomic ,copy)NSString *channel;
@property (nonatomic ,copy)NSString *channel_nid;
@property (nonatomic ,copy)NSString *icon;
@property (nonatomic ,copy)NSString *class_id;
@property (nonatomic ,copy)NSString *name;
@property (nonatomic ,copy)NSString *nid;
@property (nonatomic ,copy)NSString *sort;
@property (nonatomic ,copy)NSString *status;
@end

NS_ASSUME_NONNULL_END
