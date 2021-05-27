//
//  RERechargeCurrencyModel.m
//  ReadingEarn
//
//  Created by FANS on 2019/12/14.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERechargeCurrencyModel.h"

@implementation RERechargeCurrencyModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
            @"banner" : @"RERCBannerModel",
            @"chargeType" : @"RERCChargeTypeModel",
            };//前边，是属性数组的名字，后边就是类名
}


@end
