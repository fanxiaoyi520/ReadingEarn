//
//  RESingleton.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/27.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RESingleton.h"

@implementation RESingleton
+ (instancetype)sharedRESingleton {
    static RESingleton *_sharedRESingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //不能再使用alloc方法
        //因为已经重写了allocWithZone方法，所以这里要调用父类的分配空间的方法
        _sharedRESingleton = [[super allocWithZone:NULL] init];
    });
    return _sharedRESingleton;
}

// 防止外部调用alloc 或者 new
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [RESingleton sharedRESingleton];
}

// 防止外部调用copy
- (id)copyWithZone:(nullable NSZone *)zone {
    return [RESingleton sharedRESingleton];
}

// 防止外部调用mutableCopy
- (id)mutableCopyWithZone:(nullable NSZone *)zone {
    return [RESingleton sharedRESingleton];
}

#pragma mark - 引用
- (NSArray *)personalCenterArray {
    NSArray *array;
    if ([ToolObject onlineAuditJudgment] == YES) {
        array = @[@"修改登录密码",@"修改支付密码",@"修改用户信息",@"绑定支付宝",@"实名认证",@"退出登录"];
    } else {
        array = @[@"修改登录密码",@"修改支付密码",@"修改用户信息",@"实名认证",@"退出登录"];
    }
    return array;
}

/**
 交易市场
 */
- (NSArray *)tradingMarketTitleArray {
    NSArray *array = @[@"我要买币",@"我要卖币",@"我的订单",@"发布买卖",@"我的买卖"];
    return array;
}

- (NSArray *)tradingMarketImageArray {
    NSArray *array = @[@"tradingMarket_buy",@"tradingMarket_sell",@"tradingMarket_order",@"tradingMarket_re_ad",@"tradingMarket_ad"];
    return array;
}

- (NSArray *)tradingMarketBuyArray {
    NSArray *array = @[@"购买币种",@"数量",@"单价(CNY)",@"总额(CNY)",@"支付方式",@"联系方式(手机号码)",@"联系方式(邮箱)"];
    return array;
}

- (NSArray *)tradingMarketSellArray {
    NSArray *array = @[@"出售币种",@"数量",@"单价(CNY)",@"总额(CNY)",@"支付方式",@"联系方式(手机号码)",@"联系方式(邮箱)"];
    return array;
}

@end
