//
//  REBookInfoTerritoryModel.m
//  ReadingEarn
//
//  Created by FANS on 2019/12/10.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REBookInfoTerritoryModel.h"

@implementation REBookInfoTerritoryModel
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"territory_id":@"id"
    };
}
@end
