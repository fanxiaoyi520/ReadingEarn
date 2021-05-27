//
//  RERechangeCurrencyCollectionViewCell.m
//  ReadingEarn
//
//  Created by FANS on 2019/12/14.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERechangeCurrencyCollectionViewCell.h"

@interface RERechangeCurrencyCollectionViewCell ()

@property (nonatomic ,strong)UILabel *bookMoneyLabel;
@property (nonatomic ,strong)UILabel *giveMoneyLabel;
@property (nonatomic ,strong)UIImageView *typeImageView;
@property (nonatomic ,strong)UIButton *moneyYDCButton;
@end
@implementation RERechangeCurrencyCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self re_loadUI];
    }
    return self;
}

- (void)re_loadUI {
    
    //1.
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    backImageView.image = REImageName(@"jianqu_20");
    self.backgroundView = backImageView;
    
    UIImageView *selectedImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    selectedImageView.image = REImageName(@"jianqu_21");
    self.selectedBackgroundView = selectedImageView;

    //2.
    UIImageView *typeImageView = [UIImageView new];
    self.typeImageView = typeImageView;
    [self.contentView addSubview:typeImageView];
    
    //3.
    UILabel *bookMoneyLabel = [UILabel new];
    self.bookMoneyLabel = bookMoneyLabel;
    bookMoneyLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:bookMoneyLabel];
    
    //4.
    UILabel *giveMoneyLabel = [UILabel new];
    self.giveMoneyLabel = giveMoneyLabel;
    [self.contentView addSubview:giveMoneyLabel];
    giveMoneyLabel.textAlignment = NSTextAlignmentCenter;
    
    //5.
    UIButton *moneyYDCButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.moneyYDCButton = moneyYDCButton;
    [moneyYDCButton addTarget:self action:@selector(moneyYDCButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:moneyYDCButton];
    moneyYDCButton.titleLabel.font = REFont(16);
    moneyYDCButton.backgroundColor = REColor(247, 100, 66);
    moneyYDCButton.layer.cornerRadius = 15;
    [moneyYDCButton setTitleColor:REWhiteColor forState:UIControlStateNormal];
}

- (void)showDataWithModel:(RERCChargeTypeModel *)model {
    
    //2.
    self.typeImageView.frame = CGRectMake(0, 0, 54, 42);
    if ([model.attribute isEqualToString:@"1"]) {
        self.typeImageView.image = REImageName(@"toolbar_dec_good");
    } else if ([model.attribute isEqualToString:@"2"]) {
        self.typeImageView.image = REImageName(@"toolbar_dec_good(3)");
    } else if ([model.attribute isEqualToString:@"3"]) {
        self.typeImageView.image = REImageName(@"toolbar_dec_good(1)");
    }

    
    //3.
    self.bookMoneyLabel.frame = CGRectMake(0, 15, self.width, 25);
    NSMutableAttributedString *bookMoneyLabelstring = [[NSMutableAttributedString alloc] initWithString:model.name attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 18], NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    self.bookMoneyLabel.attributedText = bookMoneyLabelstring;
    self.bookMoneyLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    
    //4.
    self.giveMoneyLabel.frame = CGRectMake(0, self.bookMoneyLabel.bottom+15, self.width, 20);
    NSMutableAttributedString *giveMoneyLabelstring = [[NSMutableAttributedString alloc] initWithString:model.remark attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 15], NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    self.giveMoneyLabel.attributedText = giveMoneyLabelstring;
    self.giveMoneyLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];

    //5.
    NSString *moneyYDC = [NSString stringWithFormat:@"¥%@%@",model.charge_money.amount,model.charge_money.symbol];
    self.moneyYDCButton.frame = CGRectMake(26, self.giveMoneyLabel.bottom+15, self.width-52, 30);
    [self.moneyYDCButton setTitle:moneyYDC forState:UIControlStateNormal];
    objc_setAssociatedObject(self.moneyYDCButton,"firstObject",model.type_id, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - 事件
- (void)moneyYDCButtonAction:(UIButton *)sender {
    NSString *first = objc_getAssociatedObject(sender,"firstObject");
    if (self.moneyYDCBlock) {
        self.moneyYDCBlock(sender,first);
    }
}
@end
