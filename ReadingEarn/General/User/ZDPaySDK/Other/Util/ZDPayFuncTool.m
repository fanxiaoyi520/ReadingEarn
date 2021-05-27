//
//  ZDPayFuncTool.m
//  ReadingEarn
//
//  Created by FANS on 2020/4/14.
//  Copyright © 2020 FANS. All rights reserved.
//


#pragma mark - 宏的作用
NSString *const QUERYPAYMETHOD = @"/pay/queryBindCard";//查询银行卡信息列表
NSString *const CHECKCARDTYPE = @"checkCardType";//快捷支付查询银行卡号信息
NSString *const SENDBINDCARDSMS = @"sendBindCardSms";//快捷支付绑卡获取短信
NSString *const CHECKBINDCARDSMS = @"checkBindCardSms";//快捷支付绑卡短信验证
NSString *const SETPAYPWD = @"setPayPwd";//快捷支付设置支付密码
NSString *const CHECKPAYPWD = @"checkPayPwd";//快捷支付验证支付密码
NSString *const UNBINDBANKCARD = @"unbindBankCard";//快捷支付解绑银行卡
NSString *const SENDFORGETPWDSMS = @"sendForgetPwdSms";//快捷支付忘记密码获取短信
NSString *const CHECKFORGETPWDSMS = @"checkForgetPwdSms";//验证忘记密码短信
NSString *const CHANGEACCOUNTPWD = @"changeAccountPwd";//快捷支付修改密码
NSString *const PAY = @"pay";//消费类交易(支付)
NSString *const REFUND = @"refund";//快捷支付消费撤销、退货、预授权完成或预授权撤销
NSString *const QUERYPAYRESULT = @"queryPayResult";//交易查询状态

UIColor *COLORWITHHEXSTRING(NSString * hexString,CGFloat alpha) {
    hexString = [hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    hexString = [hexString stringByReplacingOccurrencesOfString:@"0x" withString:@""];
    NSRegularExpression *RegEx = [NSRegularExpression regularExpressionWithPattern:@"^[a-fA-F|0-9]{6}$" options:0 error:nil];
    NSUInteger match = [RegEx numberOfMatchesInString:hexString options:NSMatchingReportCompletion range:NSMakeRange(0, hexString.length)];

    if (match == 0) {return [UIColor clearColor];}

    NSString *rString = [hexString substringWithRange:NSMakeRange(0, 2)];
    NSString *gString = [hexString substringWithRange:NSMakeRange(2, 2)];
    NSString *bString = [hexString substringWithRange:NSMakeRange(4, 2)];
    unsigned int r, g, b;
    BOOL rValue = [[NSScanner scannerWithString:rString] scanHexInt:&r];
    BOOL gValue = [[NSScanner scannerWithString:gString] scanHexInt:&g];
    BOOL bValue = [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    if (rValue && gValue && bValue) {
        return [UIColor colorWithRed:((float)r/255.0f) green:((float)g/255.0f) blue:((float)b/255.0f) alpha:alpha];
    } else {
        return [UIColor clearColor];
    }
}
#import "ZDPayFuncTool.h"
@implementation ZDPayFuncTool
#pragma mark - 倒计时

#pragma 获取字符串的宽高
+ (CGRect)getStringWidthAndHeightWithStr:(NSString *)str withFont:(UIFont *)font {
    CGRect contentRect = [str boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return contentRect;
}

+(float) widthForString:(NSString *)value fontSize:(float)fontSize andHeight:(float)height {
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(CGFLOAT_MAX, height) lineBreakMode:NSLineBreakByWordWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.width;
}

//获得字符串的高度
+(float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width {
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置

    return sizeToFit.height;
}

#pragma mark - 保留小数点位数
+ (NSString *)getRoundFloat:(double)number withPrecisionNum:(NSInteger)position {
    NSNumber *priceNum = [NSNumber numberWithDouble:number];
    NSString *string = [NSString stringWithFormat:@"%.10f",number];
    NSRange range = [string rangeOfString:@"."];
    if (range.location!=NSNotFound) {
        
        NSInteger loc = range.location+position+1;
        NSRange rangeS;
        if (string.length>loc) {
            rangeS = NSMakeRange(loc, 1);
            NSString *str = [string substringWithRange:rangeS];
            if (str!=nil&&[str floatValue]>=5.0f) {
                priceNum = [NSNumber numberWithDouble:[[string stringByReplacingCharactersInRange:rangeS withString:@"9"] floatValue]];
            }
        }
        
    }
    if (position>4) {
        return @"";
    }
    
    if (position==1) {//保留1位
        return [NSString stringWithFormat:@"%.1f",round([priceNum floatValue]*1000000000000)/1000000000000];
    }else if(position==2){//保留2位
        return [NSString stringWithFormat:@"%.2f",round([priceNum floatValue]*1000000000000)/1000000000000];
    }else if(position==3){//保留3位
        return [NSString stringWithFormat:@"%.3f",round([priceNum floatValue]*1000000000000)/1000000000000];
    }else if(position==4){//保留4位
        return [NSString stringWithFormat:@"%.4f",round([priceNum floatValue]*1000000000000)/1000000000000];
    }
    //默认保留2位
    return [NSString stringWithFormat:@"%.2f",round([priceNum floatValue]*1000000000000)/1000000000000];}

#pragma mark - 设置不同字体颜色和大小
+ (void)LabelAttributedString:(UILabel *)labell FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor * __nullable)vaColor {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:labell.text];
    [str addAttribute:NSFontAttributeName value:font range:range];
    if (vaColor) {
        [str addAttribute:NSForegroundColorAttributeName value:vaColor range:range];
    }
    labell.attributedText = str;
}

#pragma mark - 切圆角
/**
 按钮的圆角设置

 @param view view类控件
 @param rectCorner UIRectCorner要切除的圆角
 @param borderColor 边框颜色
 @param borderWidth 边框宽度
 @param viewColor view类控件颜色
 */
+ (void)setupRoundedCornersWithView:(UIView *)view cutCorners:(UIRectCorner)rectCorner borderColor:(UIColor *__nullable)borderColor cutCornerRadii:(CGSize)radiiSize borderWidth:(CGFloat)borderWidth viewColor:(UIColor *__nullable)viewColor {

    CAShapeLayer *mask=[CAShapeLayer layer];
    UIBezierPath * path= [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:rectCorner cornerRadii:radiiSize];
    mask.path=path.CGPath;
    mask.frame=view.bounds;

    CAShapeLayer *borderLayer=[CAShapeLayer layer];
    borderLayer.path=path.CGPath;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = borderColor.CGColor;
    borderLayer.lineWidth = borderWidth;
    borderLayer.frame = view.bounds;
    view.layer.mask = mask;
    [view.layer addSublayer:borderLayer];
}

@end
