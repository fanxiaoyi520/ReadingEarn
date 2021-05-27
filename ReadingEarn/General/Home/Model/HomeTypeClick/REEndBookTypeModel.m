//
//  REEndBookTypeModel.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/26.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REEndBookTypeModel.h"

@implementation REEndBookTypeModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"class_id" : @"id"//前边的是你想用的key，后边的是返回的key
             };
}
@end
