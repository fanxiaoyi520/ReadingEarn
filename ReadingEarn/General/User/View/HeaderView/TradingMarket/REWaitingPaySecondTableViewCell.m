//
//  REWaitingPaySecondTableViewCell.m
//  ReadingEarn
//
//  Created by FANS on 2019/12/6.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REWaitingPaySecondTableViewCell.h"

@interface REWaitingPaySecondTableViewCell ()

@property (nonatomic ,strong)UILabel *tipsLabel;
@property (nonatomic ,strong)UIImageView *alipayImageView;
@property (nonatomic ,strong)UILabel *alipayNameLabel;
@property (nonatomic ,strong)UIView *lineView;
@property (nonatomic ,strong)UILabel *sellLabel;

@end
@implementation REWaitingPaySecondTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self re_loadUI];
    }
    return self;
}

- (void)re_loadUI {

    UIView *lineView = [UIView new];
    [self.contentView addSubview:lineView];
    self.lineView = lineView;
    lineView.backgroundColor = RELineColor;
    
    //新加
    UILabel *sellLabel = [UILabel new];
    [self.contentView addSubview:sellLabel];
    self.sellLabel = sellLabel;
    sellLabel.textAlignment = NSTextAlignmentLeft;
    
    //1.
    UILabel *tipsLabel = [UILabel new];
    [self.contentView addSubview:tipsLabel];
    self.tipsLabel = tipsLabel;
    tipsLabel.textAlignment = NSTextAlignmentLeft;
    
    //2.
    UIImageView *alipayImageView = [UIImageView new];
    [self.contentView addSubview:alipayImageView];
    self.alipayImageView = alipayImageView;
    
    //3.
    UILabel *alipayNameLabel = [UILabel new];
    [self.contentView addSubview:alipayNameLabel];
    self.alipayNameLabel = alipayNameLabel;
    alipayNameLabel.textAlignment = NSTextAlignmentLeft;
 
    //4.
    for (int i=0; i<5; i++) {
        UILabel *label = [UILabel new];
         [self.contentView addSubview:label];
         label.tag = 100 + i;
         label.textAlignment = NSTextAlignmentLeft;
         
         UILabel *numLabel = [UILabel new];
         [self.contentView addSubview:numLabel];
         numLabel.tag = 200 + i;
         numLabel.textAlignment = NSTextAlignmentRight;
        if (i==2) {
            numLabel.hidden = YES;
            
            UIImageView *imageView = [UIImageView new];
            [self.contentView addSubview:imageView];
            imageView.tag = 300;
        }
    }
}

- (void)showDataWithModel:(REWaitingPayModel *)model {
    if (!model) {
        return;
    }
    self.lineView.frame = CGRectMake(30, 45, REScreenWidth-30-20, 0.5);
    
    //新加
    self.sellLabel.textColor = REWhiteColor;
    self.sellLabel.layer.cornerRadius = 2;
    self.sellLabel.layer.masksToBounds = YES;
    self.sellLabel.textAlignment = NSTextAlignmentCenter;
    self.sellLabel.frame = CGRectMake(24, 12, 20, 20);
    self.sellLabel.backgroundColor = REColor(22, 206, 79);
    self.sellLabel.textColor = REWhiteColor;
    self.sellLabel.text = @"卖";
    
    //1.
    self.tipsLabel.frame = CGRectMake(self.sellLabel.right + 10, 12, 150, 20);
    NSMutableAttributedString *tipsLabelstring = [[NSMutableAttributedString alloc] initWithString:@"请向卖方账户付款" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14], NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    self.tipsLabel.attributedText = tipsLabelstring;
    self.tipsLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    
//    //2.
//    self.alipayImageView.frame  = CGRectMake(30, 42, 24, 24);
//    self.alipayImageView.image = REImageName(@"waiting_pay_zhifubao");
//
//    //3.
//    self.alipayNameLabel.frame = CGRectMake(self.alipayImageView.right+12, 44, 100, 20);
//    NSMutableAttributedString *alipayNameLabelstring = [[NSMutableAttributedString alloc] initWithString:@"支付宝" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14], NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
//    self.alipayNameLabel.attributedText = alipayNameLabelstring;
//    self.alipayNameLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    
    //4.
    NSArray *array = @[@"开户名:",@"支付宝账号:",@"收款二维码:",@"联系方式(手机):",@"联系方式(邮箱):"];
    NSArray *numArray = @[model.name,model.pay_number,@"1",model.shell_mobile,model.create_user_id_email];
    for (int i=0; i<5; i++) {
        UILabel *label = [self.contentView viewWithTag:100+i];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:array[i] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14], NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
        label.attributedText = string;
        label.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        label.frame = CGRectMake(30, 57+i*(20+6), 100, 20);
        
        UILabel *numLabel = [self.contentView viewWithTag:200+i];
        numLabel.font = REFont(14);
        numLabel.frame = CGRectMake(REScreenWidth-200-20, 57+i*(20+6), 200, 20);
        numLabel.text = [NSString stringWithFormat:@"%@",numArray[i]];
        numLabel.textColor = REColor(153, 153, 153);
        if (i==1) {
            numLabel.textColor = REColor(247, 100, 66);
        }
        if (i==2) {
            UIImageView *imageView = [self.contentView viewWithTag:300];
            imageView.frame = CGRectMake(REScreenWidth-20-20, 112, 20, 20);
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.pay_code] placeholderImage:REImageName(@"waiting_pay_code1")];
            UITapGestureRecognizer *taps = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            imageView.userInteractionEnabled = YES;
            objc_setAssociatedObject(taps, @"pay_code", model.pay_code, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [imageView addGestureRecognizer:taps];
        }
    }

}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    NSString * pay_code = (NSString *)objc_getAssociatedObject(tap, @"pay_code");
    if (self.QRCodeBlock) {
        self.QRCodeBlock(tap,pay_code);
    }
}

@end
