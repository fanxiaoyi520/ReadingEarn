//
//  REWaitingPayModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/12/6.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"
#import "REWaitingPaySencondModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface REWaitingPayModel : RERootModel
//data =     {
//    "create_time" = 1575545718;
//    "create_user_id_email" = "";
//    "create_user_id_phone" = 15521365498;
//    data =         {
//        button = "\U786e\U8ba4\U4ed8\U6b3e";
//        cancel = 2;
//        name = 2;
//    };
//    "end_time" = 1575547518;
//    headimg = "";
//    id = 26;
//    mobile = 15377777777;
//    name = 1231;
//    "order_num" = "6.00000000";
//    "order_status" = 2;
//    ordid = 62390628889718915085;
//    payType = alipay;
//    "pay_code" = "http://images.xiaocao4.cn/2019112814160449494.jpg";
//    "pay_number" = 123456789;
//    "payment_time" = 0;
//    price = "10.00";
//    "release_time" = 0;
//    status = 1;
//    step = 1;
//    symbol = YDC;
//    "total_money" = 60;
//    type = 1;
//};
@property (nonatomic ,copy)NSString *create_time;
@property (nonatomic ,copy)NSString *create_user_id_email;
@property (nonatomic ,copy)NSString *create_user_id_phone;
@property (nonatomic ,strong)REWaitingPaySencondModel *data;
@property (nonatomic ,copy)NSString *end_time;
@property (nonatomic ,copy)NSString *headimg;
@property (nonatomic ,copy)NSString *pay_id;
@property (nonatomic ,copy)NSString *mobile;
@property (nonatomic ,copy)NSString *name;
@property (nonatomic ,copy)NSString *order_num;
@property (nonatomic ,copy)NSString *order_status;
@property (nonatomic ,copy)NSString *ordid;
@property (nonatomic ,copy)NSString *payType;
@property (nonatomic ,copy)NSString *pay_code;
@property (nonatomic ,copy)NSString *pay_number;
@property (nonatomic ,copy)NSString *payment_time;
@property (nonatomic ,copy)NSString *price;
@property (nonatomic ,copy)NSString *release_time;
@property (nonatomic ,copy)NSString *status;
@property (nonatomic ,copy)NSString *step;
@property (nonatomic ,copy)NSString *symbol;
@property (nonatomic ,copy)NSString *total_money;
@property (nonatomic ,copy)NSString *type;
@property (nonatomic ,copy)NSString *buy_mobile;
@property (nonatomic ,copy)NSString *shell_mobile;
@end

NS_ASSUME_NONNULL_END
