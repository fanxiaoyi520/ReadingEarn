//
//  REReadHistoryModel.m
//  ReadingEarn
//
//  Created by FANS on 2019/12/10.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REReadHistoryModel.h"

@implementation REReadHistoryModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"history_id" : @"id"//前边的是你想用的key，后边的是返回的key
             };
}
@end
