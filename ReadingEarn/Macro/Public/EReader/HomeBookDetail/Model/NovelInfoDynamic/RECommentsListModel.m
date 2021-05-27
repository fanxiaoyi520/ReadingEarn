
//
//  RECommentsListModel.m
//  ReadingEarn
//
//  Created by FANS on 2019/12/10.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RECommentsListModel.h"

@implementation RECommentsListModel
+(NSDictionary *)mj_objectClassInArray {
    return @{
        @"sons":@"RECommentListSonModel"
    };
}

+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"list_id":@"id"
    };
}

@end
