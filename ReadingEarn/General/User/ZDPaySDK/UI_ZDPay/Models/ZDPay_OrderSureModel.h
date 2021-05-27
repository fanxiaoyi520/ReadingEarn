//
//  ZDPay_OrderSureModel.h
//  ReadingEarn
//
//  Created by FANS on 2020/4/14.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPayRootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZDPay_OrderSureModel : ZDPayRootModel
/**
 客户端传递过来的参数
 */
@property (nonatomic ,copy)NSString *surplusTime; //支付剩余时间
@property (nonatomic ,copy)NSString *amountMoney; //金额 HK
@property (nonatomic ,copy)NSString *orderNumber; //订单编号

#pragma mark - 后台需要的参数
@property (nonatomic ,copy)NSString *registerMobile;//注册手机号
@property (nonatomic ,copy)NSString *registerCountryCode;//注册手机区号
@property (nonatomic ,copy)NSString *merId;//商户号
/**
    中国大陆-142
    香港-110
    新加坡-132
    马来西亚-122
    ......
 */
@property (nonatomic ,copy)NSString *countryCode;//国家编码 
@property (nonatomic ,copy)NSString *phoneSystem;//手机系统 Android or Ios
@property (nonatomic ,copy)NSString *mcc;//商业行业类别 Mcc，微信支付宝时必填
@property (nonatomic ,copy)NSString *subject;//交易内容 交易商品，微信支付宝时必填
@property (nonatomic ,copy)NSString *referUrl;//首页地址 网站首页地址，当交易类型为支付宝时该参数必填
@property (nonatomic ,copy)NSString *subAppid;//子商户appId 微信必传，微信官方审核通过的appId
@property (nonatomic ,copy)NSString *timeExpire;//订单有效时间 单位为分钟，最少为2分钟
@property (nonatomic ,copy)NSString *cardNum;//卡号 银联快捷支付时传
@property (nonatomic ,copy)NSString *orderNo;//订单号 商家订单号唯一
@property (nonatomic ,copy)NSString *amount;//交易金额 分
@property (nonatomic ,copy)NSString *notifyUrl;//异步通知地址 交易成功时通知的回调地址
/**
 中文:zh-CN
 英文:en-US
 繁体:zh-HK
 */
@property (nonatomic ,copy)NSString *language;//语言





#pragma mark - 后台返回的参数
@property (nonatomic ,copy)NSString *payImageUrl; //金额 HK
@property (nonatomic ,copy)NSString *payMethod; //订单编号

@end

NS_ASSUME_NONNULL_END
