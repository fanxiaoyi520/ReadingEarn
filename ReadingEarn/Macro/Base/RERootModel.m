//
//  RERootModel.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/15.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"

@implementation RERootModel
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if (!oldValue||[oldValue isKindOfClass:[NSNull class]]) {
        return @"";
    }
    return oldValue;
}

@end
