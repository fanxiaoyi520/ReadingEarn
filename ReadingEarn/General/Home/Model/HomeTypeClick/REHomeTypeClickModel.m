//
//  REHomeTypeClickModel.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/26.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REHomeTypeClickModel.h"

@implementation REHomeTypeClickModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"type_id":@"id"
    };
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{
            @"territory" : @"REHomeTypeStatusModel",
            };//前边，是属性数组的名字，后边就是类名
}

@end
