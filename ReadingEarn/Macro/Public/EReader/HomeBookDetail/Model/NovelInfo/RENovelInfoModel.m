//
//  RENovelInfoModel.m
//  ReadingEarn
//
//  Created by FANS on 2019/12/10.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RENovelInfoModel.h"

@implementation RENovelInfoModel
+(NSDictionary *)mj_objectClassInArray {
    return @{
        @"bookList":@"REBookListModel",
        @"likeList":@"RELikeListModel",
    };
}

+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"mynewInfoModel":@"newInfo"
    };
}
@end
