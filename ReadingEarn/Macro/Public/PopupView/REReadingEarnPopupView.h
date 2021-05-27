//
//  REReadingEarnPopupView.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/28.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^REExchangeYDCBlock)(UIButton *sender,NSString *text);
typedef void (^RECopyQRcodeAddressBlock)(UIButton *sender,NSString *text);
typedef void (^REGraTypeBlock)(UIButton *sender,NSString *gratype_idStr);
typedef void (^REImmediateRechargeBlock)(UIButton *sender);
typedef void (^REIsAgreeBlock)(UIButton *sender);
typedef enum _REReadingEarnPopupViewsEnum {
    REReadingEarnPopupView_ContactCustomerService  = 0, //联系客服
    REReadingEarnPopupView_ExchangeYDC  = 1, //兑换YDC
    REReadingEarnPopupView_Recharge  = 2, //充值
    REReadingEarnPopupView_Recharge2  = 4, //充值
    REReadingEarnPopupView_PlayReward  = 3, //我要打赏
    REReadingEarnPopupView_SignIn  = 5, //签到提示
    REReadingEarnPopupView_ImmediateRecharge  = 6, //看书提示立即充值
    REReadingEarnPopupView_UserAgreement  = 7, //用户协议
} REReadingEarnPopupViewsEnum;

@interface REReadingEarnPopupView : RERootView

@property (nonatomic ,copy)REGraTypeBlock graTypeBlock;
@property (nonatomic ,copy)REExchangeYDCBlock exchangeYDCBlock;
@property (nonatomic ,copy)RECopyQRcodeAddressBlock copyQRcodeAddressBlock;
@property (nonatomic ,copy)REImmediateRechargeBlock immediateRechargeBlock;
@property (nonatomic ,copy)REIsAgreeBlock isAgreeBlock;

+ (REReadingEarnPopupView *)readingEarnPopupViewWithType:(REReadingEarnPopupViewsEnum)type;
- (void)showPopupViewWithData:(id)model;
- (void)closeThePopupView;
@end

NS_ASSUME_NONNULL_END
