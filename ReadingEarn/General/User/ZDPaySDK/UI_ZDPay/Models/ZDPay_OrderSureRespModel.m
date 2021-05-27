//
//  ZDPay_OrderSureRespModel.m
//  ReadingEarn
//
//  Created by FANS on 2020/4/15.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPay_OrderSureRespModel.h"

@implementation ZDPay_OrderSureRespModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
            @"bankList" : @"ZDPay_OrderSureBankListRespModel",
            @"payList" : @"ZDPay_OrderSurePayListRespModel",
            };//前边，是属性数组的名字，后边就是类名
}

@end
