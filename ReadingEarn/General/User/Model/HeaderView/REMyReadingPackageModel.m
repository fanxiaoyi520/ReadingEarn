//
//  REMyReadingPackageModel.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/30.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REMyReadingPackageModel.h"

@implementation REMyReadingPackageModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"my_reading_id":@"id"
    };
}
@end
