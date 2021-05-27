//
//  RERCChargeTypeModel.m
//  ReadingEarn
//
//  Created by FANS on 2019/12/14.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERCChargeTypeModel.h"

@implementation RERCChargeTypeModel
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"type_id":@"id",
    };
}

@end
