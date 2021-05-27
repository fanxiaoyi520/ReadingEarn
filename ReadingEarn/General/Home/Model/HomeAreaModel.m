//
//  HomeAreaModel.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/15.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "HomeAreaModel.h"

@implementation HomeAreaModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
            @"book" : @"HomeBookModel"
            };//前边，是属性数组的名字，后边就是类名
}
@end
