//
//  NSString+Add.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/21.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "NSString+Add.h"

@implementation NSString (Add)

+ (BOOL)valiMobile:(NSString *)mobile {
    if (mobile.length != 11)
    {
        return NO;
    }
    return YES;
//    /**
//     * 手机号码:
//     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
//     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
//     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
//     * 电信号段: 133,153,180,181,189,177,1700
//     */
//    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
//    /**
//     * 中国移动：China Mobile
//     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
//     */
//    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
//    /**
//     * 中国联通：China Unicom
//     * 130,131,132,155,156,185,186,145,176,1709
//     */
//    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
//    /**
//     * 中国电信：China Telecom
//     * 133,153,180,181,189,177,1700
//     */
//    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
//
//    /**
//     25         * 大陆地区固话及小灵通
//     26         * 区号：010,020,021,022,023,024,025,027,028,029
//     27         * 号码：七位或八位
//     28         */
//    //   NSString * PHS = @"^(0[0-9]{2})\\d{8}$|^(0[0-9]{3}(\\d{7,8}))$";
//
//
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
//    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
//    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
//
//    if (([regextestmobile evaluateWithObject:mobile] == YES)
//        || ([regextestcm evaluateWithObject:mobile] == YES)
//        || ([regextestct evaluateWithObject:mobile] == YES)
//        || ([regextestcu evaluateWithObject:mobile] == YES))
//    {
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
//    return NO;
}
@end
