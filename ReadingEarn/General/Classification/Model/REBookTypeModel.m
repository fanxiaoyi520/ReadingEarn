//
//  REBookTypeModel.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/19.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REBookTypeModel.h"

@implementation REBookTypeModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"class_id" : @"id"//前边的是你想用的key，后边的是返回的key
             };
}
@end
