//
//  REMyOrderModel.m
//  ReadingEarn
//
//  Created by FANS on 2019/12/5.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REMyOrderModel.h"

@implementation REMyOrderModel

+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"order_id":@"id",
    };
}
@end
