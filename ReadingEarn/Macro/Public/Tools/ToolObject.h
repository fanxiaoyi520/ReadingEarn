//
//  ToolObject.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/23.
//  Copyright © 2019 FANS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ToolObject : NSObject

//快速创建一个label
+ (UILabel *)createLabelWithTitle:(NSString *)title textColor:(UIColor *)textColor textFont:(CGFloat)textFont addSubView:(UIView *)subView;

//改变字体的颜色
+(void)LabelAttributedString:(UILabel*)label firstW:(NSString *)oneW toSecondW:(NSString *)twoW color:(UIColor *)color size:(CGFloat)size;
+(void)LabelAttributedString:(UILabel *)labell FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor;
//返回文本的大小
+ (CGSize)textHeightFromTextString:(NSString *)text width:(CGFloat)textWidth fontSize:(CGFloat)size;

+ (CGRect)boundingRectWithString:(NSString *)str withSize:(CGSize)size withFont:(UIFont *)font;
+ (CGSize)sizeWithText:(NSString *)text withFont:(UIFont *)font;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (void)buttonTangentialFilletWithButton:(UIView *)myButton withUIRectCorner:(UIRectCorner)rectCorner;
//保留小数位
+ (NSString *)getRoundFloat:(double)floatNumber withPrecisionNum:(NSInteger)precision;
+ (NSString *)getDateStringWithTimestamp:(NSString *)str;
+(NSString *)getDateStringWithTimestamp_time:(NSString *)str;
+ (NSString *)getCurrentTimestamp;
+ (CIImage *)creatQRcodeWithUrlstring:(NSString *)urlString;
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size;


+ (UIViewController *)jsd_getRootViewController;
+ (UIViewController *)jsd_getCurrentViewController;
+ (BOOL)onlineAuditJudgment;
@end

NS_ASSUME_NONNULL_END
