//
//  REExchangeModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/30.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface REExchangeModel : RERootModel
//Printing description of response->_responseObject:
//{
//    "app_symbol" = YC;
//    banance = "229.00000000";
//    code = 1;
//    logo = "http://images.xiaocao4.cn/2019110322113758013.jpg";
//    scale = 10;
//    "wallet_symbol" = YDC;
//}
@property (nonatomic ,copy)NSString *app_symbol;
@property (nonatomic ,copy)NSString *banance;
@property (nonatomic ,copy)NSString *code;
@property (nonatomic ,copy)NSString *logo;
@property (nonatomic ,copy)NSString *scale;
@property (nonatomic ,copy)NSString *wallet_symbol;
@end

NS_ASSUME_NONNULL_END
