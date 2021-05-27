//
//  REBuyCoinsTableViewCell.m
//  ReadingEarn
//
//  Created by FANS on 2019/12/5.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REBuyCoinsTableViewCell.h"

@interface REBuyCoinsTableViewCell ()

@property (nonatomic ,strong)UIView *bgView;
@property (nonatomic ,strong)UIImageView *headImageView;
@property (nonatomic ,strong)UILabel *nameLabel;
@property (nonatomic ,strong)UILabel *dealNumLabel;
@property (nonatomic ,strong)UILabel *dealRateLabel;
@property (nonatomic ,strong)UIImageView *channelImageView;
@property (nonatomic ,strong)UILabel *surplusShareLabel;

@property (nonatomic ,strong)UILabel *moneyLabel;
@property (nonatomic ,strong)UILabel *limitMoneyLabel;
@property (nonatomic ,strong)UILabel *numMoneyLabel;
@property (nonatomic ,strong)UIButton *buyButton;
@property (nonatomic ,copy)NSString *type;
@end
@implementation REBuyCoinsTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
         
        [self re_loadUI];
    }
    return self;
}

- (void)re_loadUI {
    UIView *bgView = [UIView new];
    bgView.userInteractionEnabled = YES;
    [self.contentView addSubview:bgView];
    self.bgView = bgView;
    bgView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    bgView.layer.cornerRadius = 8;
    
    //1.
    UIImageView *headImageView = [UIImageView new];
    [bgView addSubview:headImageView];
    self.headImageView = headImageView;
    headImageView.layer.cornerRadius = 24;
    headImageView.layer.masksToBounds = YES;
    
    //2.
    //账户名
    UILabel *nameLabel = [UILabel new];
    [bgView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    nameLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    
    //成交量
    UILabel *dealNumLabel = [UILabel new];
    [bgView addSubview:dealNumLabel];
    self.dealNumLabel = dealNumLabel;
    dealNumLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    
    //成交率
    UILabel *dealRateLabel = [UILabel new];
    [bgView addSubview:dealRateLabel];
    self.dealRateLabel = dealRateLabel;
    dealRateLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    
    UILabel *surplusShareLabel = [UILabel new];
    [bgView addSubview:surplusShareLabel];
    self.surplusShareLabel = surplusShareLabel;
    dealRateLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    
    //渠道
    UIImageView *channelImageView = [UIImageView new];
    self.channelImageView = channelImageView;
    [bgView addSubview:channelImageView];
    
    //3.
    //价格
    UILabel *moneyLabel = [UILabel new];
    moneyLabel.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:moneyLabel];
    self.moneyLabel = moneyLabel;
    moneyLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    
    //限额
    UILabel *limitMoneyLabel = [UILabel new];
    [bgView addSubview:limitMoneyLabel];
    limitMoneyLabel.textAlignment = NSTextAlignmentRight;
    self.limitMoneyLabel = limitMoneyLabel;
    limitMoneyLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    
    //数量
    UILabel *numMoneyLabel = [UILabel new];
    [bgView addSubview:numMoneyLabel];
    self.numMoneyLabel = numMoneyLabel;
    numMoneyLabel.textAlignment = NSTextAlignmentRight;
    numMoneyLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    
    //购买
    UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buyButton = buyButton;
    [bgView addSubview:buyButton];
    buyButton.titleLabel.font = REFont(14);
    [buyButton setTitleColor:REWhiteColor forState:UIControlStateNormal];
    [buyButton addTarget:self action:@selector(buyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    buyButton.backgroundColor = [UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0];
    buyButton.layer.cornerRadius = 14;
}

- (void)showDataWithModel:(REBuyCoinsModel *)model withType:(NSString *)type {
    self.type = type;
    self.bgView.frame = CGRectMake(16, 8, REScreenWidth-32, 132);
    if (!model) {
        return;
    }
    //1.
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.headimg] placeholderImage:PlaceholderHead_Image];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@26);
        make.left.equalTo(@12);
        make.width.equalTo(@48);
        make.height.equalTo(@48);
    }];
    
    //2.
    //账户名
    self.nameLabel.frame = CGRectMake(76, 12, 120, 20);
    NSMutableAttributedString *nameLabelstring = [[NSMutableAttributedString alloc] initWithString:model.mobile attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14], NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    self.nameLabel.attributedText = nameLabelstring;

    //成交量
    NSString *dealNum = [NSString stringWithFormat:@"成交量:%@",model.deal_total];
    self.dealNumLabel.frame = CGRectMake(76, self.nameLabel.bottom+8, 120, 17);
    NSMutableAttributedString *dealNumLabelstring = [[NSMutableAttributedString alloc] initWithString:dealNum attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 12], NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
    self.dealNumLabel.attributedText = dealNumLabelstring;

    //成交率
    NSString *dealRate = [NSString stringWithFormat:@"成交率:%@%%",model.deal_scal];
    self.dealRateLabel.frame = CGRectMake(76, self.dealNumLabel.bottom+5, 120, 17);
    NSMutableAttributedString *dealRateLabelstring = [[NSMutableAttributedString alloc] initWithString:dealRate attributes:@{NSFontAttributeName: REFont(12), NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
    self.dealRateLabel.font = REFont(12);
    self.dealRateLabel.attributedText = dealRateLabelstring;
    [ToolObject LabelAttributedString:self.dealRateLabel FontNumber:REFont(12) AndRange:NSMakeRange(4, model.deal_scal.length+1) AndColor:REColor(247, 100, 66)];

    //剩余份额
    NSString *deal_amout_not = [ToolObject getRoundFloat:[model.locked_amout_not floatValue] withPrecisionNum:2];
    NSString *surplusShare = [NSString stringWithFormat:@"剩余份额:%@",deal_amout_not];
    self.surplusShareLabel.frame = CGRectMake(76, self.dealRateLabel.bottom+5, 120, 17);
    NSMutableAttributedString *surplusShareLabelstring = [[NSMutableAttributedString alloc] initWithString:surplusShare attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 12], NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
    self.surplusShareLabel.attributedText = surplusShareLabelstring;

    //渠道
    self.channelImageView.frame = CGRectMake(76, self.surplusShareLabel.bottom+5, 14, 14);
    self.channelImageView.image = REImageName(@"zhifubao");
    
    //3.
    //价格
    NSString *money = [NSString stringWithFormat:@"￥%@CNY",model.TotoalPrice];
    self.moneyLabel.frame = CGRectMake(self.bgView.width-150-16, 18, 150, 20);
    NSMutableAttributedString *moneyLabelstring = [[NSMutableAttributedString alloc] initWithString:money attributes:@{NSFontAttributeName: REFont(12), NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
    self.moneyLabel.attributedText = moneyLabelstring;
    self.moneyLabel.font = REFont(12);
    [ToolObject LabelAttributedString:self.moneyLabel FontNumber:REFont(20) AndRange:NSMakeRange(0, model.TotoalPrice.length+1) AndColor:REColor(247, 100, 66)];

    //限额
    NSString *limitMoney = [NSString stringWithFormat:@"限额:%@~%@CNY",model.LowerLimit,model.UpperLimit];
    self.limitMoneyLabel.frame = CGRectMake(self.bgView.width-150-16, self.moneyLabel.bottom+5, 150, 17);
    NSMutableAttributedString *limitMoneyLabelstring = [[NSMutableAttributedString alloc] initWithString:limitMoney attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 12], NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
    self.limitMoneyLabel.attributedText = limitMoneyLabelstring;
    self.limitMoneyLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    
    //数量
    NSString *numMoney = [NSString stringWithFormat:@"数量:%@%@",model.amout,model.symbol];
    self.numMoneyLabel.frame = CGRectMake(self.bgView.width-150-16, self.limitMoneyLabel.bottom+5, 150, 17);
    NSMutableAttributedString *numMoneyLabelstring = [[NSMutableAttributedString alloc] initWithString:numMoney attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 12], NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
    self.numMoneyLabel.attributedText = numMoneyLabelstring;
    self.numMoneyLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    //购买
    self.buyButton.frame = CGRectMake(self.bgView.width-116-16, self.numMoneyLabel.bottom+5, 116, 28);
    if ([type isEqualToString:@"2"]) {
        [self.buyButton setTitle:@"购买" forState:UIControlStateNormal];
    } else {
        [self.buyButton setTitle:@"出售" forState:UIControlStateNormal];
    }
    if ([deal_amout_not isEqualToString:@"0"]) {
        self.buyButton.backgroundColor = REColor(153, 153, 153);
        self.buyButton.userInteractionEnabled = NO;
    }
}

- (void)buyButtonAction:(UIButton *)sender {
    if (self.buyBlock) {
        self.buyBlock(sender,self,self.type);
    }
}

@end
