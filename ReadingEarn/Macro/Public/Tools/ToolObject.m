//
//  ToolObject.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/23.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "ToolObject.h"

@implementation ToolObject
//快速创建一个label
+ (UILabel *)createLabelWithTitle:(NSString *)title textColor:(UIColor *)textColor textFont:(CGFloat)textFont addSubView:(UIView *)subView {
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.textColor = textColor;
    label.font = REFont(textFont);
    [subView addSubview:label];
    return label;
}

//改变字体的颜色
+(void)LabelAttributedString:(UILabel*)label firstW:(NSString *)oneW toSecondW:(NSString *)twoW color:(UIColor *)color size:(CGFloat)size{
    // 创建Attributed
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:label.text];
    // 需要改变的第一个文字的位置
    NSUInteger firstLoc = [[noteStr string] rangeOfString:oneW].location;
    // 需要改变的最后一个文字的位置
    NSUInteger secondLoc = [[noteStr string] rangeOfString:twoW].location+1;
    // 需要改变的区间
    NSRange range = NSMakeRange(firstLoc, secondLoc - firstLoc);
    // 改变颜色
    [noteStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    // 改变字体大小及类型
    
    [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:size] range:range];
    // 为label添加Attributed
    [label setAttributedText:noteStr];
}

//设置不同字体颜色
+(void)LabelAttributedString:(UILabel *)labell FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:labell.text];
     
    //设置字号
    [str addAttribute:NSFontAttributeName value:font range:range];
     
    //设置文字颜色
    [str addAttribute:NSForegroundColorAttributeName value:vaColor range:range];
     
    labell.attributedText = str;
}

+ (CGSize)textHeightFromTextString:(NSString *)text width:(CGFloat)textWidth fontSize:(CGFloat)size {
    //计算 label需要的宽度和高度
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:size]};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
     CGSize size1 = [text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:size]}];
    return CGSizeMake(size1.width, rect.size.height);
}

+ (CGRect)boundingRectWithString:(NSString *)str withSize:(CGSize)size withFont:(UIFont *)font{

    CGRect rect = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];

    return rect;
}

+ (CGSize)sizeWithText:(NSString *)text withFont:(UIFont *)font{

    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:font}];

    return size;
}


+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
     UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (void)buttonTangentialFilletWithButton:(UIView *)myButton withUIRectCorner:(UIRectCorner)rectCorner {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:myButton.bounds      byRoundingCorners:rectCorner  cornerRadii:CGSizeMake(16, 16)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
     maskLayer.frame = myButton.bounds;
     maskLayer.path = maskPath.CGPath;
     myButton.layer.mask = maskLayer;
//    myButton.layer.cornerRadius=16;
}

+ (NSString *)getRoundFloat:(double)floatNumber withPrecisionNum:(NSInteger)precision {
    
    // 0.123456789  精度2
    
    //core foundation 的当前确切时间
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    
    //精度要求为2，算出 10的2次方，也就是100，让小数点右移两位，让原始小数扩大100倍
    double fact = pow(10,precision);//face = 100
    //让小数扩大100倍，四舍五入后面的位数，再缩小100倍，这样成功的进行指定精度的四舍五入
    double result = round(fact * floatNumber) / fact; // result = 0.12
    //组合成字符串 @"%.3f"   想要打印百分号%字符串 需要在前面加一个百分号 表示不转译
    NSString *proString = [NSString stringWithFormat:@"%%.%ldf",(long)precision]; //proString = @"%.2f"
    // 默认会显示6位 多余的n补0，所以需要指定显示多少小数位  @"%.2f" 0.123000
    NSString *resultString = [NSString stringWithFormat:proString,result];
    
    //time实际上是一个double
    CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();

    NSLog(@"time cost: %0.6f", end - start);
    NSNumber * nsNumber = @(resultString.floatValue);
    NSString * outNumber = [NSString stringWithFormat:@"%@",nsNumber];
    return outNumber;
}

+(NSString *)getDateStringWithTimestamp_time:(NSString *)str {
    NSTimeInterval time = [str doubleValue]; // 传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // 实例化一个NSDateFormatter对象
    // 设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:detailDate];
    return currentDateStr;
}
// 时间戳转时间,时间戳为13位是精确到毫秒的，10位精确到秒
+ (NSString *)getDateStringWithTimestamp:(NSString *)str {
//    NSTimeInterval time = [str doubleValue]; // 传入的时间戳str如果是精确到毫秒的记得要/1000
//    NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:time];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // 实例化一个NSDateFormatter对象
//    // 设定时间格式,这里可以设置成自己需要的格式
//    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
//    NSString *currentDateStr = [dateFormatter stringFromDate:detailDate];
//    return currentDateStr;
    //把字符串转为NSdate

    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    // 创建歌曲时间戳(后台返回的时间 一般是13位数字)
     NSTimeInterval createTime = [str doubleValue];
    // 时间差
    NSTimeInterval time = currentTime - createTime;
    
    // 秒转小时
    NSInteger hours = time/3600;
    if (hours<24) {
        return [NSString stringWithFormat:@"%ld小时前",hours];
    }
    //秒转天数
    NSInteger days = time/3600/24;
    if (days < 30) {
        return [NSString stringWithFormat:@"%ld天前",days];
    }
    //秒转月
    NSInteger months = time/3600/24/30;
    if (months < 12) {
        return [NSString stringWithFormat:@"%ld月前",months];
    }
    //秒转年
    NSInteger years = time/3600/24/30/12;
    return [NSString stringWithFormat:@"%ld年前",years];
}

+ (NSString *)getCurrentTimestamp {
    // 获取当前时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];

    // 得到当前时间（世界标准时间 UTC/GMT）
    NSDate *nowDate = [NSDate date];
    // 设置系统时区为本地时区
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    // 计算本地时区与 GMT 时区的时间差
    NSInteger interval = [zone secondsFromGMT];
    // 在 GMT 时间基础上追加时间差值，得到本地时间
    nowDate = [nowDate dateByAddingTimeInterval:interval];

    NSString *nowDateString = [dateFormatter stringFromDate:nowDate];
    return nowDateString;
}

+ (CIImage *)creatQRcodeWithUrlstring:(NSString *)urlString{
    
    // 1.实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复滤镜的默认属性 (因为滤镜有可能保存上一次的属性)
    [filter setDefaults];
    // 3.将字符串转换成NSdata
    NSData *data  = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    // 4.通过KVO设置滤镜, 传入data, 将来滤镜就知道要通过传入的数据生成二维码
    [filter setValue:data forKey:@"inputMessage"];
    // 5.生成二维码
    CIImage *outputImage = [filter outputImage];
    return outputImage;
}

+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

+ (UIViewController *)jsd_getRootViewController {

    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    NSAssert(window, @"The window is empty");
    return window.rootViewController;
}

+ (UIViewController *)jsd_getCurrentViewController{

    UIViewController* currentViewController = [self jsd_getRootViewController];
    BOOL runLoopFind = YES;
    while (runLoopFind) {
        if (currentViewController.presentedViewController) {

            currentViewController = currentViewController.presentedViewController;
        } else if ([currentViewController isKindOfClass:[UINavigationController class]]) {

          UINavigationController* navigationController = (UINavigationController* )currentViewController;
            currentViewController = [navigationController.childViewControllers lastObject];

        } else if ([currentViewController isKindOfClass:[UITabBarController class]]) {

          UITabBarController* tabBarController = (UITabBarController* )currentViewController;
            currentViewController = tabBarController.selectedViewController;
        } else {

            NSUInteger childViewControllerCount = currentViewController.childViewControllers.count;
            if (childViewControllerCount > 0) {

                currentViewController = currentViewController.childViewControllers.lastObject;

                return currentViewController;
            } else {

                return currentViewController;
            }
        }

    }
    return currentViewController;
}

+ (BOOL)onlineAuditJudgment {
    //获取ipa版本号
    NSString *string = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *string1 = [string stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    //获取后台版本号
    NSString *string2 = [[RESingleton sharedRESingleton].userModel stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSInteger a = [string1 integerValue];
    NSInteger b = [string2 integerValue];
    if (a < b) {
        return YES;
    } else {
        return NO;
    }
}

@end
