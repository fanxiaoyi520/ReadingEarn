//
//  REReadingPackageModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/30.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface REReadingPackageModel : RERootModel
//"active_point" = 5000;
//icon = "http://images.xiaocao4.cn/2019110720223273212.jpg";
//id = 6;
//nid = zhizun;
//"pay_amount" = 500000;
//"pay_symbol" = YDC;
//"released_amount" = 24170;
//"released_days" = 35;
//"released_symbol" = YDC;
//status = 1;
//title = "\U81f3\U5c0a\U9605\U8bfb\U5305";
//"yc_icon" = 5000;
//"yc_symbol" = YC;
@property (nonatomic ,copy)NSString *active_point;
@property (nonatomic ,copy)NSString *icon;
@property (nonatomic ,copy)NSString *reading_id;
@property (nonatomic ,copy)NSString *nid;
@property (nonatomic ,copy)NSString *pay_amount;
@property (nonatomic ,copy)NSString *pay_symbol;
@property (nonatomic ,copy)NSString *released_amount;
@property (nonatomic ,copy)NSString *released_days;
@property (nonatomic ,copy)NSString *released_symbol;
@property (nonatomic ,copy)NSString *status;
@property (nonatomic ,copy)NSString *title;
@property (nonatomic ,copy)NSString *yc_icon;
@property (nonatomic ,copy)NSString *yc_symbol;

@end

NS_ASSUME_NONNULL_END
