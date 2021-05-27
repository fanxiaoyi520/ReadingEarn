//
//  ZDPay_OrderSureBankListRespModel.h
//  ReadingEarn
//
//  Created by FANS on 2020/4/15.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPayRootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZDPay_OrderSureBankListRespModel : ZDPayRootModel

@property (nonatomic ,copy)NSString *bankName;//银行名称
@property (nonatomic ,copy)NSString *cardId;//银行卡号
@property (nonatomic ,copy)NSString *cardPic;//银行图标url地址
@property (nonatomic ,copy)NSString *cardNum;//银行卡号 银行卡后4位
@property (nonatomic ,copy)NSString *cardType;//银行卡类型 D:储蓄卡 C:信用卡
@property (nonatomic ,copy)NSString *serialNumber;//数据库ID
@property (nonatomic ,copy)NSString *cardBgPic;//银行卡背景图 url地址

@end

NS_ASSUME_NONNULL_END
