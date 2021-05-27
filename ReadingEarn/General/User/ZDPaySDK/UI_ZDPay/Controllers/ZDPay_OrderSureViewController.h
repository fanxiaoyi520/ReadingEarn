//
//  ZDPay_OrderSureViewController.h
//  ReadingEarn
//
//  Created by FANS on 2020/4/13.
//  Copyright © 2020 FANS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZDPayRootViewController.h"
#import "ZDPay_OrderSureModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZDPay_OrderSureViewController : ZDPayRootViewController

/**
客户端初始化方式
1.可以直接 alloc
2. [ZDPay_OrderSureViewController  manager]
 */

+ (instancetype)manager;
/**
 客户端调用中道支付回调结果SDK接口
 1.paySucess:支付成功的回调
 2.payCancel:支付取消回调
 3.payFailure:支付失败回调
 */
- (void)ZDPay_PaymentResultCallbackWithPaySucess:(void (^)(id _Nonnull responseObject))paySucess
                                       payCancel:(void (^)(id _Nonnull reason))payCancel
                                      payFailure:(void (^)(id _Nonnull desc,NSError * _Nonnull error))payFailure;
/**
    用户端需要传递的参数，以公开的model文件属性赋值传递
 */
@property (nonatomic,strong)ZDPay_OrderSureModel *orderModel;

@end

NS_ASSUME_NONNULL_END
