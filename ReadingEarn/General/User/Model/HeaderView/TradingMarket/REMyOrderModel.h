//
//  REMyOrderModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/12/5.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface REMyOrderModel : RERootModel
//"create_time" = 1575545736;
//"end_time" = 1575547536;
//id = 27;
//"order_num" = "1.00000000";
//"order_status" = 2;
//ordid = 31730628889736266085;
//price = "1.00";
//status = 1;
//step = 1;
//symbol = YDC;
//"total_money" = 1;
//type = 2;
@property (nonatomic ,copy)NSString *create_time;
@property (nonatomic ,copy)NSString *end_time;
@property (nonatomic ,copy)NSString *order_id;
@property (nonatomic ,copy)NSString *order_num;
@property (nonatomic ,copy)NSString *order_status;
@property (nonatomic ,copy)NSString *ordid;
@property (nonatomic ,copy)NSString *price;
@property (nonatomic ,copy)NSString *status;
@property (nonatomic ,copy)NSString *step;
@property (nonatomic ,copy)NSString *symbol;
@property (nonatomic ,copy)NSString *total_money;
@property (nonatomic ,copy)NSString *type;

@end

NS_ASSUME_NONNULL_END
