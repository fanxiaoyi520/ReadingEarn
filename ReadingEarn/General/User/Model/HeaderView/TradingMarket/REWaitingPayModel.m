//
//  REWaitingPayModel.m
//  ReadingEarn
//
//  Created by FANS on 2019/12/6.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REWaitingPayModel.h"

@implementation REWaitingPayModel

+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"pay_id":@"id",
    };
}
@end
