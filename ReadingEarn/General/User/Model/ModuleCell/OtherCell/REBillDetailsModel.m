//
//  REBillDetailsModel.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/28.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REBillDetailsModel.h"

@implementation REBillDetailsModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"system_id":@"id"
    };
}

@end
