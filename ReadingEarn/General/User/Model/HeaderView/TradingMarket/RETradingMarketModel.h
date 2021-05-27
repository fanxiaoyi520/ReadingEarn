//
//  RETradingMarketModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/12/5.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RETradingMarketModel : RERootModel
//"already_deal_cny" = "0.00";
//"deal_now_count" = "200.00000000";
//"deal_price" = "5.50";
//"deal_total" = "200.00000000";
//symbol = YDC;

//"deal_now_count" = 0;
//"deal_price" = "0.051";
//"deal_total" = 0;
//gain = "1.96";
//"global_bonus" = "79.5000";
//symbol = YDC;
//@property (nonatomic ,copy)NSString *already_deal_cny;
@property (nonatomic ,copy)NSString *deal_now_count;
@property (nonatomic ,copy)NSString *deal_price;
@property (nonatomic ,copy)NSString *gain;
@property (nonatomic ,copy)NSString *deal_total;
@property (nonatomic ,copy)NSString *global_bonus;
@property (nonatomic ,copy)NSString *symbol;
@end

NS_ASSUME_NONNULL_END
