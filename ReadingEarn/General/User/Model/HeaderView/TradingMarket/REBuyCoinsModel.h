//
//  REBuyCoinsModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/12/5.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface REBuyCoinsModel : RERootModel
//LowerLimit = "5.00";
//TotoalPrice = "1000.00";
//UpperLimit = "60.00";
//amout = "100.00";
//"create_time" = 1575345230;
//"deal_amout_not" = "100.00";
//"deal_scal" = 100;
//"deal_total" = 3;
//headimg = "";
//id = 2;
//"locked_amout_already" = "6.00000000";
//"locked_amout_not" = "94.00000000";
//mobile = "153****7777";
//payType = alipay;
//price = "10.00";
//status = 2;
//symbol = YDC;
//title = "\U6211\U8981\U5356\U5e01";
//type = 2;
@property (nonatomic ,copy)NSString *LowerLimit;
@property (nonatomic ,copy)NSString *TotoalPrice;
@property (nonatomic ,copy)NSString *UpperLimit;
@property (nonatomic ,copy)NSString *amout;
@property (nonatomic ,copy)NSString *create_time;
@property (nonatomic ,copy)NSString *deal_amout_not;
@property (nonatomic ,copy)NSString *deal_scal;
@property (nonatomic ,copy)NSString *deal_total;
@property (nonatomic ,copy)NSString *headimg;
@property (nonatomic ,copy)NSString *buy_id;
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
