//
//  REMyReadingPackageModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/30.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface REMyReadingPackageModel : RERootModel
//"end_time" = 1577585325;
//icon = "http://images.xiaocao4.cn/2019110720200516651.jpg";
//id = 25;
//nid = xinshou;
//"released_already" = 0;
//"released_not" = 1140;
//"released_symbol" = YDC;
//"released_total" = 1140;
//"start_time" = 1574993325;
//status = 1;
//title = "\U65b0\U624b\U9605\U8bfb\U5305";
//"user_id" = 802874;
@property (nonatomic ,copy)NSString *end_time;
@property (nonatomic ,copy)NSString *icon;
@property (nonatomic ,copy)NSString *my_reading_id;
@property (nonatomic ,copy)NSString *nid;
@property (nonatomic ,copy)NSString *released_already;
@property (nonatomic ,copy)NSString *released_not;
@property (nonatomic ,copy)NSString *released_symbol;
@property (nonatomic ,copy)NSString *released_total;
@property (nonatomic ,copy)NSString *start_time;
@property (nonatomic ,copy)NSString *status;
@property (nonatomic ,copy)NSString *title;
@property (nonatomic ,copy)NSString *user_id;

@end

NS_ASSUME_NONNULL_END
