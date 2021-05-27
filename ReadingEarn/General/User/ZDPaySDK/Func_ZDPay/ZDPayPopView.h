//
//  ZDPayPopView.h
//  ReadingEarn
//
//  Created by FANS on 2020/4/15.
//  Copyright © 2020 FANS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum _ZDPayPopViewEnum {
    SetPaymentPassword  = 0, //设置支付密码
} ZDPayPopViewEnum;

typedef void (^ZDSetPaymentPassword)(NSString *text, BOOL isFinished);
typedef void (^ZDForgetPassword)(void);
@interface ZDPayPopView : UIView
@property (nonatomic ,copy)ZDSetPaymentPassword setPaymentPassword;
@property (nonatomic ,copy)ZDForgetPassword forgetPassword;

+ (ZDPayPopView *)readingEarnPopupViewWithType:(ZDPayPopViewEnum)type;
- (void)showPopupViewWithData:(__nullable id)model
                      payPass:(void (^)(NSString *text, BOOL isFinished))payPass
                   forgetPass:(void (^)(void))forgetPass;
- (void)closeThePopupView;

@end

NS_ASSUME_NONNULL_END
