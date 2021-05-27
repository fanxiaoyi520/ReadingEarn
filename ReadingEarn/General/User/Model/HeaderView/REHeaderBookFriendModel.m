//
//  REHeaderBookFriendModel.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/29.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REHeaderBookFriendModel.h"

@implementation REHeaderBookFriendModel
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if (!oldValue||[oldValue isKindOfClass:[NSNull class]]) {
        return @"0";
    }
    return oldValue;
}

@end
