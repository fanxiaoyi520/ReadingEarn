//
//  REBookInfoModel.m
//  ReadingEarn
//
//  Created by FANS on 2019/12/10.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REBookInfoModel.h"

@implementation REBookInfoModel
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"info_id":@"id"
    };
}

+(NSDictionary *)mj_objectClassInArray {
    return @{
        @"territory":@"REBookInfoTerritoryModel"
    };
}
@end
