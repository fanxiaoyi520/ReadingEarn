//
//  RECommentsModel.m
//  ReadingEarn
//
//  Created by FANS on 2019/12/10.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RECommentsModel.h"

@implementation RECommentsModel
+(NSDictionary *)mj_objectClassInArray {
    return @{
        @"list":@"RECommentsListModel"
    };
}
@end
