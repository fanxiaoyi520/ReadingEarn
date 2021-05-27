//
//  ZDPay_OrderSureHeaderView.m
//  ReadingEarn
//
//  Created by FANS on 2020/4/14.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPay_OrderSureHeaderView.h"

@interface ZDPay_OrderSureHeaderView ()

@property (nonatomic ,strong)NSString *zdPayTimer;
@property (nonatomic ,strong)UILabel *paytimeLab;
@property (nonatomic ,strong)UILabel *moneyUnitLab;
@property (nonatomic ,strong)UILabel *orderNumberLab;
@property (strong, nonatomic)CountDown *countDownForLab;

@end

@implementation ZDPay_OrderSureHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

#pragma mark - private
- (void)initialize {
    
    _countDownForLab = [[CountDown alloc] init];
    //支付剩余时间
    UILabel *paytimeLab = [UILabel new];
    self.paytimeLab = paytimeLab;
    paytimeLab.font = ZD_Fout_Medium(ratioH(14));
    paytimeLab.textAlignment = NSTextAlignmentCenter;
    paytimeLab.textColor = COLORWITHHEXSTRING(@"#666666", 1.0);
    [self.contentView addSubview:paytimeLab];
    
    //金额
    UILabel *moneyUnitLab = [UILabel new];
    self.moneyUnitLab = moneyUnitLab;
    moneyUnitLab.textAlignment = NSTextAlignmentCenter;
    moneyUnitLab.font = ZD_Fout_Medium(ratioH(18));
    moneyUnitLab.textColor = COLORWITHHEXSTRING(@"#333333", 1.0);
    [self.contentView addSubview:moneyUnitLab];
    
    //订单编号
    UILabel *orderNumberLab = [UILabel new];
    self.orderNumberLab = orderNumberLab;
    orderNumberLab.textAlignment = NSTextAlignmentCenter;
    orderNumberLab.textColor = COLORWITHHEXSTRING(@"#999999", 1.0);
    orderNumberLab.font = ZD_Fout_Medium(ratioH(14));
    [self.contentView addSubview:orderNumberLab];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
    [self.countDownForLab destoryTimer];
    NSLog(@"%s dealloc",object_getClassName(self));
}

#pragma mark - public
- (void)layoutAndLoadData:(ZDPay_OrderSureRespModel *)model {
    if (!model) {
        return;
    }
    
    self.paytimeLab.frame = CGRectMake(0, ratioW(20), self.width, ratioH(14));
    NSTimeInterval aMinutes = [model.surplusTime integerValue];
    @WeakObj(self)
    [_countDownForLab countDownWithStratDate:[NSDate date] finishDate:[NSDate dateWithTimeIntervalSinceNow:aMinutes] completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
        @StrongObj(self);
        NSInteger totoalSecond =day*24*60*60+hour*60*60 + minute*60+second;
        if (totoalSecond==0) {
            self.paytimeLab.text = @"00:00";
        }else{
            self.paytimeLab.text = [NSString stringWithFormat:@"%@ %ld",NSLocalizedString(@"支付剩余时间",nil),totoalSecond];
        }
    }];
    
    //金额
    NSString *amountMoneyStr = [ZDPayFuncTool getRoundFloat:[model.amountMoney doubleValue] withPrecisionNum:2];
    self.moneyUnitLab.frame = CGRectMake(0, self.paytimeLab.bottom+ratioH(20), self.width, ratioH(30));
    self.moneyUnitLab.text = [NSString stringWithFormat:@"HK$ %@",amountMoneyStr];
    [ZDPayFuncTool LabelAttributedString:self.moneyUnitLab FontNumber:ZD_Fout_Medium(ratioH(30)) AndRange:NSMakeRange(4, amountMoneyStr.length-2) AndColor:nil];
    
    //订单编号
    NSString *orderNumberStr = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"订单编号",nil),model.orderNumber];
    self.orderNumberLab.frame = CGRectMake(self.paytimeLab.left, self.moneyUnitLab.bottom+ratioH(16), self.moneyUnitLab.width, ratioH(14));
    self.orderNumberLab.text = orderNumberStr;
}

@end
