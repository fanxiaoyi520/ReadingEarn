//
//  REMyNewsModel.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/28.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REMyNewsModel.h"

@implementation REMyNewsModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"system_id":@"id"
    };
}

@end
