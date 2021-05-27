//
//  ZDPay_OrderSureFooterView.m
//  ReadingEarn
//
//  Created by FANS on 2020/4/14.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPay_OrderSureFooterView.h"
#import "ZDPayFuncTool.h"

@interface ZDPay_OrderSureFooterView ()

@property (nonatomic ,strong)UIButton *proxyBtn;
@property (nonatomic ,strong)UILabel *proxyLabel;
@property (nonatomic ,strong)UIButton *surePayBtn;

@end

@implementation ZDPay_OrderSureFooterView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

#pragma mark - private
- (void)initialize {
    
    [self creatSureProxyBtnWithSel:@selector(proxyBtn:)];
    [self creatSurePayBtnWithSel:@selector(surePayBtn:)];
    
    UILabel *proxyLabel = [UILabel new];
    [self.contentView addSubview:proxyLabel];
    proxyLabel.textAlignment = NSTextAlignmentCenter;
    proxyLabel.lineBreakMode = NSLineBreakByWordWrapping;
    proxyLabel.numberOfLines = 0;
    proxyLabel.preferredMaxLayoutWidth = ScreenWidth;
    proxyLabel.font = ZD_Fout_Medium(ratioH(13));
    proxyLabel.textColor = COLORWITHHEXSTRING(@"#999999", 1.0);
    self.proxyLabel = proxyLabel;
    
}

- (void)creatSureProxyBtnWithSel:(SEL)sel {
    UIButton *proxyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [proxyBtn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    self.proxyBtn = proxyBtn;
    self.proxyBtn.selected = YES;
    [self.contentView addSubview:proxyBtn];
}

- (void)creatSurePayBtnWithSel:(SEL)sel {
    UIButton *surePayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.surePayBtn = surePayBtn;
    [surePayBtn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    surePayBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:surePayBtn];
    surePayBtn.backgroundColor = COLORWITHHEXSTRING(@"#333333", 1.0);
    surePayBtn.layer.cornerRadius = ratioH(22);
    surePayBtn.layer.masksToBounds = YES;
    [surePayBtn setTitleColor:COLORWITHHEXSTRING(@"#FFFFFF", 1.0) forState:UIControlStateNormal];
    surePayBtn.titleLabel.font = ZD_Fout_Medium(ratioH(18));
    surePayBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)proxyBtn:(UIButton *)sender {
    if (sender.selected == NO) {
        sender.selected = YES;
        [self.proxyBtn setImage:[UIImage imageNamed:@"btn_xieyi_selete"] forState:UIControlStateNormal];
    } else {
        sender.selected = NO;
        [self.proxyBtn setImage:[UIImage imageNamed:@"btn_xieyi_unsel"] forState:UIControlStateNormal];
    }
}

- (void)surePayBtn:(UIButton *)sender {
    if (self.surePay) {
        self.surePay(sender);
    }
}

#pragma mark - public
- (void)layoutAndLoadData:(ZDPay_OrderSureRespModel *)model
                  surePay:(void(^)(UIButton *sender))surePay {
    self.surePay = surePay;
    if (!model) {
        return;
    }
    
    self.proxyBtn.frame = CGRectMake(ratioW(33), ratioH(86), ratioH(13), ratioH(13));
    [self.proxyBtn setImage:[UIImage imageNamed:@"btn_xieyi_selete"] forState:UIControlStateNormal];
    
    CGRect rect = [ZDPayFuncTool getStringWidthAndHeightWithStr:@"点击确认，表示您已经阅读并同意《支付协议》" withFont:ZD_Fout_Medium(ratioH(13))];
    self.proxyLabel.frame = CGRectMake(self.proxyBtn.right+ratioW(5), ratioH(83.5), rect.size.width, rect.size.height);
    self.proxyLabel.text = @"点击确认，表示您已经阅读并同意《支付协议》";
    [ZDPayFuncTool LabelAttributedString:self.proxyLabel FontNumber:ZD_Fout_Medium(ratioH(13)) AndRange:NSMakeRange(15, 6) AndColor:COLORWITHHEXSTRING(@"#FFB300", 1.0)];
    
    NSString *amountMoneyStr = [ZDPayFuncTool getRoundFloat:[model.amountMoney doubleValue] withPrecisionNum:2];
    self.surePayBtn.frame = CGRectMake(ratioW(20), self.proxyLabel.bottom + ratioH(11), self.width-ratioW(40), ratioH(44));
    [self.surePayBtn setTitle:[NSString stringWithFormat:@"%@ HK$ %@",NSLocalizedString(@"确认支付",nil),amountMoneyStr] forState:UIControlStateNormal];
}
@end
