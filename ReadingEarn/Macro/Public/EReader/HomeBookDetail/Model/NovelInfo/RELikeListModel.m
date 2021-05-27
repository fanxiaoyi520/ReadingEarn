//
//  RELikeListModel.m
//  ReadingEarn
//
//  Created by FANS on 2019/12/10.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RELikeListModel.h"

@implementation RELikeListModel
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"like_id":@"id"
    };
}

@end
