//
//  REBookListModel.m
//  ReadingEarn
//
//  Created by FANS on 2019/12/10.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REBookListModel.h"

@implementation REBookListModel
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"booklist_id":@"id"
    };
}
@end
