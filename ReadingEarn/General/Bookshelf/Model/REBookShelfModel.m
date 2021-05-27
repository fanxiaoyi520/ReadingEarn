//
//  REBookShelfModel.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/22.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REBookShelfModel.h"

@implementation REBookShelfModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"bookShelf_id":@"id"
    };
}
@end
