//
//  ZDPay_OrderSurePayListRespModel.h
//  ReadingEarn
//
//  Created by FANS on 2020/4/15.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPayRootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZDPay_OrderSurePayListRespModel : ZDPayRootModel

@property (nonatomic ,copy)NSString *payType;//支付类型 参考字典数据支付类型.
@property (nonatomic ,copy)NSString *payTypePic;//支付类型图标

@end

NS_ASSUME_NONNULL_END
