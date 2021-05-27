//
//  HomeModel.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/15.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "HomeModel.h"

@implementation HomeModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
            @"banner" : @"HomeBannelModel",
            @"quick1" : @"HomeQuick1Model",
            @"quick2" : @"HomeQuick2Model",
            @"vip" : @"HomeVipModel",
            @"womanType" : @"HomeWomanTypeModel",
            @"icon" : @"HomeIconModel",
            @"manType" : @"HomeManModel"
            };//前边，是属性数组的名字，后边就是类名
}

@end
