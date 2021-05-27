//
//  ZDPay_MywalletTableViewCell.m
//  ReadingEarn
//
//  Created by FANS on 2020/4/16.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPay_MywalletTableViewCell.h"
#import "ZDPayFuncTool.h"

@interface ZDPay_MywalletTableViewCell ()

@property (nonatomic,strong)UIImageView *backImageView;
@property (nonatomic,strong)UILabel *typeLab;
@property (nonatomic,strong)UILabel *cardNumberLab;
@property (nonatomic,strong)UIButton *isHiddenBtn;
@end
@implementation ZDPay_MywalletTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initialize];
    }
    return self;
}

#pragma mark - private
- (void)setFrame:(CGRect)frame {
    frame.origin.y += ratioH(16);
    frame.size.width = ScreenWidth-ratioW(32);
    [super setFrame:frame];
}

- (void)initialize {
    
    UIImageView *backImageView = [UIImageView new];
    backImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:backImageView];
    self.backImageView = backImageView;
    
    UILabel *typeLab = [UILabel new];
    self.typeLab = typeLab;
    [backImageView addSubview:typeLab];
    typeLab.textColor = COLORWITHHEXSTRING(@"#FFFFFF", .8);
    typeLab.font = ZD_Fout_Medium(ratioH(12));

    UILabel *cardNumberLab = [UILabel new];
    self.cardNumberLab = cardNumberLab;
    [backImageView addSubview:cardNumberLab];
    cardNumberLab.textColor = COLORWITHHEXSTRING(@"#FFFFFF", 1.0);
    cardNumberLab.font = ZD_Fout_Medium(ratioH(18));
    
    UIButton *isHiddenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.isHiddenBtn = isHiddenBtn;
    isHiddenBtn.selected = YES;
    [backImageView addSubview:isHiddenBtn];
    
    [isHiddenBtn setImage:REImageName(@"icon_yingcang") forState:UIControlStateNormal];
    [isHiddenBtn addTarget:self action:@selector(isHiddenBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)isHiddenBtnAction:(UIButton *)sender {
    if (sender.selected == YES) {
        sender.selected = NO;
        [self.isHiddenBtn setImage:REImageName(@"icon_zhankai") forState:UIControlStateNormal];
    } else {
        sender.selected = YES;
        [self.isHiddenBtn setImage:REImageName(@"icon_yingcang") forState:UIControlStateNormal];
    }
}

#pragma mark - public
- (void)layoutAndLoadData:(id __nullable)model {
    
//    if (!model) {
//        return;
//    }
    self.backImageView.frame = CGRectMake(0, ratioH(5), self.width, ratioH(112));
    self.backImageView.image = [UIImage imageNamed:@"bohaiyinhang"];
    
    CGRect typeRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:@"预付卡" withFont:ZD_Fout_Medium(ratioH(12))];
    self.typeLab.frame = CGRectMake(ratioW(48), ratioH(34), typeRect.size.width, ratioH(12));
    self.typeLab.text = @"预付卡";
    
    CGRect cardNumberRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:@"**** **** **** 9123" withFont:ZD_Fout_Medium(ratioH(18))];
    self.cardNumberLab.frame = CGRectMake(ratioW(48), ratioH(68), cardNumberRect.size.width, ratioH(18));
    self.cardNumberLab.text = @"**** **** **** 9123";

    self.isHiddenBtn.frame = CGRectMake(self.width-ratioW(57), ratioH(33), ratioW(57), ratioH(79));
}
@end
