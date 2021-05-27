//
//  ZDPay_OrderSureRespModel.h
//  ReadingEarn
//
//  Created by FANS on 2020/4/15.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPayRootModel.h"
#import "ZDPay_OrderSureBankListRespModel.h"
#import "ZDPay_OrderSurePayListRespModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZDPay_OrderSureRespModel : ZDPayRootModel

/**
 用户存在标识
 0:用户存在
 1:用户不存在
 */
@property (nonatomic ,copy)NSString *isUser;
/**
 是否已设置支付密码
 0：已设置
 1：未设置
 */
@property (nonatomic ,copy)NSString *isSetPwd;
@property (nonatomic ,strong)NSArray<ZDPay_OrderSureBankListRespModel *> *bankList;
@property (nonatomic ,strong)NSArray<ZDPay_OrderSurePayListRespModel *> *payList;
@property (nonatomic ,strong)ZDPay_OrderSureBankListRespModel *bankListModel;
@property (nonatomic ,strong)ZDPay_OrderSurePayListRespModel *payListModel;


/**测试*/
@property (nonatomic ,copy)NSString *surplusTime; //支付剩余时间
@property (nonatomic ,copy)NSString *amountMoney; //金额 HK
@property (nonatomic ,copy)NSString *orderNumber; //订单编号
@end

NS_ASSUME_NONNULL_END
