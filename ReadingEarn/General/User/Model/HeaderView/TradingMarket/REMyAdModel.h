//
//  REMyAdModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/12/9.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface REMyAdModel : RERootModel
//LowerLimit = "10.00";
//TotoalPrice = "100.00";
//UpperLimit = "80.00";
//"ad_status" = "\U5df2\U53d6\U6d88";
//amout = "100.00";
//cancel = 2;
//"create_time" = 1575345247;
//"deal_amout_already" = "80.00000000";
//"deal_amout_not" = "20.00";
//headimg = "http://images.xiaocao4.cn/2019112820404258521.jpg";
//id = 3;
//"locked_amout_already" = "0.00000000";
//"locked_amout_not" = "20.00000000";
//mobile = "155****7777";
//payType = alipay;
//price = "1.00";
//status = 4;
//symbol = YDC;
//title = "\U6211\U8981\U5356\U5e01";
//type = 1;
@property (nonatomic ,copy)NSString *LowerLimit;
@property (nonatomic ,copy)NSString *TotoalPrice;
@property (nonatomic ,copy)NSString *UpperLimit;
@property (nonatomic ,copy)NSString *ad_status;
@property (nonatomic ,copy)NSString *amout;
@property (nonatomic ,copy)NSString *cancel;
@property (nonatomic ,copy)NSString *create_time;
@property (nonatomic ,copy)NSString *deal_amout_already;
@property (nonatomic ,copy)NSString *deal_amout_not;
@property (nonatomic ,copy)NSString *headimg;
@property (nonatomic ,copy)NSString *myad_id;
@property (nonatomic ,copy)NSString *locked_amout_already;
@property (nonatomic ,copy)NSString *locked_amout_not;
@property (nonatomic ,copy)NSString *mobile;
@property (nonatomic ,copy)NSString *payType;
@property (nonatomic ,copy)NSString *price;
@property (nonatomic ,copy)NSString *status;
@property (nonatomic ,copy)NSString *symbol;
@property (nonatomic ,copy)NSString *title;
@property (nonatomic ,copy)NSString *type;

@end

NS_ASSUME_NONNULL_END
