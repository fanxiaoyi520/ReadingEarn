//
//  HomeQuick1Model.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/15.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "HomeQuick1Model.h"

@implementation HomeQuick1Model
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"home_id" : @"id"//前边的是你想用的key，后边的是返回的key
             };
}

@end
