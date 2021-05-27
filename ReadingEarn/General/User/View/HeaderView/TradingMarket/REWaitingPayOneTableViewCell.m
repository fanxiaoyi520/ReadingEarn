//
//  REWaitingPayOneTableViewCell.m
//  ReadingEarn
//
//  Created by FANS on 2019/12/6.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REWaitingPayOneTableViewCell.h"

@interface REWaitingPayOneTableViewCell ()

@property (nonatomic ,strong)UIView *bgView;
@property (nonatomic ,strong)UIImageView *headImageView;
@property (nonatomic ,strong)UILabel *nameLabel;
@property (nonatomic ,strong)UILabel *moneyLabel;
@property (nonatomic ,strong)UILabel *moneyUnitLabel;
@property (nonatomic ,strong)UIView *lineView;
@property (nonatomic ,strong)UIView *cellLineView;
@property (nonatomic ,strong)UILabel *buyLabel;
@end
@implementation REWaitingPayOneTableViewCell

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
    [self.contentView addSubview:bgView];
    self.bgView = bgView;
    bgView.backgroundColor = REWhiteColor;
    
    UIView *lineView = [UIView new];
    [self.contentView addSubview:lineView];
    self.lineView = lineView;
    lineView.backgroundColor = RELineColor;
    
    UIView *cellLineView = [UIView new];
    [self.contentView addSubview:cellLineView];
    self.cellLineView = cellLineView;
    cellLineView.layer.cornerRadius = 3;

    //新加
    UILabel *buyLabel = [UILabel new];
    [self.contentView addSubview:buyLabel];
    self.buyLabel = buyLabel;
    buyLabel.textAlignment = NSTextAlignmentLeft;
    
    //1.
    UIImageView *headImageView = [UIImageView new];
    [self.contentView addSubview:headImageView];
    self.headImageView = headImageView;
    headImageView.layer.cornerRadius = 10;
    headImageView.layer.masksToBounds = YES;
    
    //2.
    UILabel *nameLabel = [UILabel new];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    nameLabel.textAlignment = NSTextAlignmentLeft;
    
    //3.
    UILabel *moneyLabel = [UILabel new];
    [self.contentView addSubview:moneyLabel];
    self.moneyLabel = moneyLabel;
    moneyLabel.textAlignment = NSTextAlignmentRight;
    
    UILabel *moneyUnitLabel = [UILabel new];
    [self.contentView addSubview:moneyUnitLabel];
    self.moneyUnitLabel = moneyUnitLabel;
    moneyUnitLabel.textAlignment = NSTextAlignmentRight;
    
    //4.
    for (int i=0; i<4; i++) {
        UILabel *label = [UILabel new];
        [self.contentView addSubview:label];
        label.tag = 100 + i;
        label.textAlignment = NSTextAlignmentLeft;
        
        UILabel *numLabel = [UILabel new];
        [self.contentView addSubview:numLabel];
        numLabel.tag = 200 + i;
        numLabel.textAlignment = NSTextAlignmentRight;
    }
}

- (void)showDataWithModel:(REWaitingPayModel *)model {
    self.bgView.frame = CGRectMake(0, 0, REScreenWidth, 171);
    self.lineView.frame = CGRectMake(30, 49, REScreenWidth-30-20, 0.5);
    self.cellLineView.frame = CGRectMake(0, 40, 5, 86);
    if ([model.order_status isEqualToString:@"1"]) {
        self.cellLineView.backgroundColor = [UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0];
    } else {
        self.cellLineView.backgroundColor = [UIColor colorWithRed:0/255.0 green:216/255.0 blue:65/255.0 alpha:1.0];
    }
    
    if (!model) {
        return;
    }

    //新加
    self.buyLabel.backgroundColor = REColor(247, 100, 66);
    self.buyLabel.textColor = REWhiteColor;
    self.buyLabel.layer.cornerRadius = 2;
    self.buyLabel.layer.masksToBounds = YES;
    self.buyLabel.textAlignment = NSTextAlignmentCenter;
    self.buyLabel.frame = CGRectMake(24, 16, 20, 20);
    self.buyLabel.font = REFont(14);
    self.buyLabel.text = @"买";

    //1.
    self.headImageView.frame = CGRectMake(self.buyLabel.right + 10, 16, 20, 20);
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.headimg] placeholderImage:PlaceholderHead_Image];
    
    //2.
    self.nameLabel.frame = CGRectMake(self.headImageView.right+8, 16, 100, 20);
    NSMutableAttributedString *nameLabelstring = [[NSMutableAttributedString alloc] initWithString:model.buy_mobile attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14], NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    self.nameLabel.attributedText = nameLabelstring;
    self.nameLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    
    //3.
    NSString *moneyStr = [NSString stringWithFormat:@"¥%@",model.total_money];
    CGSize moneysize = [ToolObject sizeWithText:moneyStr withFont:REFont(20)];
    NSMutableAttributedString *moneyLabelstring = [[NSMutableAttributedString alloc] initWithString:moneyStr attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 20], NSForegroundColorAttributeName: [UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0]}];
    self.moneyLabel.attributedText = moneyLabelstring;
    self.moneyLabel.textColor = [UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0];
    self.moneyLabel.frame = CGRectMake(REScreenWidth-moneysize.width-58-10, 12, moneysize.width+10, 28);
    
    self.moneyUnitLabel.frame = CGRectMake(REScreenWidth-20-30-10, 20, 30+10, 20);
    NSMutableAttributedString *moneyUnitLabelstring = [[NSMutableAttributedString alloc] initWithString:@"CNY" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14], NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    self.moneyUnitLabel.attributedText = moneyUnitLabelstring;
    self.moneyUnitLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    
    //4.
    NSArray *array = @[@"订单号:",@"价格(CNY):",@"数量(YDC)",@"创建时间:"];
    NSString *create_time = [ToolObject getDateStringWithTimestamp_time:model.create_time];
    NSNumber *order_numnum = @(model.order_num.floatValue);
    NSString *order_num = [NSString stringWithFormat:@"%@",order_numnum];
    NSArray *numArray = @[model.ordid,model.price,order_num,create_time];
    for (int i=0; i<4; i++) {
        UILabel *label = [self.contentView viewWithTag:100+i];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:array[i] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14], NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
        label.attributedText = string;
        label.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        label.frame = CGRectMake(30, 61+i*(20+6), 100, 20);
        
        UILabel *numLabel = [self.contentView viewWithTag:200+i];
        numLabel.font = REFont(14);
        numLabel.frame = CGRectMake(REScreenWidth-200-20, 61+i*(20+6), 200, 20);
        numLabel.text = [NSString stringWithFormat:@"%@",numArray[i]];
        if (i>0 &&i<3) {
            numLabel.textColor = REColor(247, 100, 66);
        } else {
            numLabel.textColor = REColor(153, 153, 153);
        }
    }
}

@end
