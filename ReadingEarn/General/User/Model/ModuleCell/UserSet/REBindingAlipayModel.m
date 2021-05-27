
//
//  REBindingAlipayModel.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/28.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REBindingAlipayModel.h"

@implementation REBindingAlipayModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"self_ID":@"name",
        @"alipayAccount":@"pay_number",
        @"QRcodePicture":@"pay_code"
    };
}
@end
