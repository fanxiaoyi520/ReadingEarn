//
//  REMyOrderTableViewCell.m
//  ReadingEarn
//
//  Created by FANS on 2019/12/5.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REMyOrderTableViewCell.h"

@interface REMyOrderTableViewCell ()
@property (nonatomic ,strong)UIView *cellLineView;
@property (nonatomic ,strong)UILabel *isBbuyLabel;
@property (nonatomic ,strong)UILabel *YDCLabel;
@property (nonatomic ,strong)UILabel *statusLabel;
@property (nonatomic ,strong)UILabel *priceLabel;
@property (nonatomic ,strong)UILabel *priceUnitLabel;
@property (nonatomic ,strong)UILabel *timeLabel;

@end
@implementation REMyOrderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self re_loadUI];
    }
    return self;
}

- (void)re_loadUI {
    
    UIView *cellLineView = [UIView new];
    [self.contentView addSubview:cellLineView];
    self.cellLineView = cellLineView;
    cellLineView.layer.cornerRadius = 3;
    
    //1.
    UILabel *isBbuyLabel = [UILabel new];
    isBbuyLabel.layer.cornerRadius = 4;
    isBbuyLabel.layer.masksToBounds = YES;
    [self.contentView addSubview:isBbuyLabel];
    self.isBbuyLabel = isBbuyLabel;
    
    //2.
    UILabel *YDCLabel = [UILabel new];
    isBbuyLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:YDCLabel];
    self.YDCLabel = YDCLabel;
    YDCLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    
    //3.
    UILabel *statusLabel = [UILabel new];
    [self.contentView addSubview:statusLabel];
    statusLabel.textAlignment = NSTextAlignmentRight;
    self.statusLabel = statusLabel;
    statusLabel.textColor = [UIColor colorWithRed:22/255.0 green:206/255.0 blue:79/255.0 alpha:1.0];

    //4.
    UILabel *priceLabel = [UILabel new];
    [self.contentView addSubview:priceLabel];
    priceLabel.textAlignment = NSTextAlignmentRight;
    self.priceLabel = priceLabel;
    priceLabel.textColor = [UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0];
    
    UILabel *priceUnitLabel = [UILabel new];
    priceUnitLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:priceUnitLabel];
    self.priceUnitLabel = priceUnitLabel;
    priceUnitLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    
    //5.
    UILabel *timeLabel = [UILabel new];
    [self.contentView addSubview:timeLabel];
    timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel = timeLabel;
    timeLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    
    //6.
    for (int i=0; i<3; i++) {
        UILabel *label = [UILabel new];
        label.tag = 100+i;
        [self.contentView addSubview:label];
        label.textAlignment = NSTextAlignmentLeft;
        
        UILabel *numLabel = [UILabel new];
        numLabel.tag = 200+i;
        [self.contentView addSubview:numLabel];
        numLabel.textAlignment = NSTextAlignmentLeft;
    }
}

- (void)showDataWithModel:(REMyOrderModel *)model {
    
    if (!model) {
        return;
    }
    self.cellLineView.frame = CGRectMake(0, 20, 5, 86);
    
    //1.
    NSString *isBuy;
    if ([model.order_status isEqualToString:@"1"]) {
        isBuy = @"买";
        self.isBbuyLabel.backgroundColor = REColor(247, 100, 66);
        self.isBbuyLabel.textColor = REWhiteColor;
        self.cellLineView.backgroundColor = REColor(247, 100, 66);
    } else {
        isBuy = @"卖";
        self.isBbuyLabel.backgroundColor = REColor(22, 206, 79);
        self.isBbuyLabel.textColor = REWhiteColor;
        self.cellLineView.backgroundColor = REColor(22, 206, 79);
    }
    self.isBbuyLabel.textAlignment = NSTextAlignmentCenter;
    self.isBbuyLabel.frame = CGRectMake(45, 20, 20, 20);
    self.isBbuyLabel.font = REFont(14);
    self.isBbuyLabel.text = isBuy;
    
    //2.
    self.YDCLabel.frame = CGRectMake(self.isBbuyLabel.right+11, 20, 100, 20);
    NSMutableAttributedString *YDCLabelstring = [[NSMutableAttributedString alloc] initWithString:model.symbol attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14], NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    self.YDCLabel.attributedText = YDCLabelstring;

    //3.

    NSString *statusStr;
    if ([model.step isEqualToString:@"1"]) {
        statusStr = @"待付款";
    } else if ([model.step isEqualToString:@"2"]){
        statusStr = @"待收款";
    } else if ([model.step isEqualToString:@"3"]){
        statusStr = @"待放币";
    } else {
        statusStr = @"已完成";
    }
    self.statusLabel.frame = CGRectMake(REScreenWidth-20-100, 20, 100, 17);
    NSMutableAttributedString *statusLabelstring = [[NSMutableAttributedString alloc] initWithString:statusStr attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 12], NSForegroundColorAttributeName: [UIColor colorWithRed:22/255.0 green:206/255.0 blue:79/255.0 alpha:1.0]}];
    self.statusLabel.attributedText = statusLabelstring;

    //4.¥
    NSString *priceStr = [NSString stringWithFormat:@"¥%@",[ToolObject getRoundFloat:[model.total_money floatValue] withPrecisionNum:0]];
    self.priceLabel.frame = CGRectMake(REScreenWidth-49-100, 57, 100, 20);
    NSMutableAttributedString *priceLabelstring = [[NSMutableAttributedString alloc] initWithString:priceStr attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size: 20], NSForegroundColorAttributeName: [UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0]}];
    self.priceLabel.attributedText = priceLabelstring;

    CGSize priceunit = [ToolObject sizeWithText:@"CNY" withFont:REFont(10)];
    self.priceUnitLabel.frame = CGRectMake(REScreenWidth-priceunit.width-10-20, 67, priceunit.width+10, 10);
    NSMutableAttributedString *priceUnitLabelstring = [[NSMutableAttributedString alloc] initWithString:@"CNY" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size: 10], NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
    self.priceUnitLabel.attributedText = priceUnitLabelstring;
    
    //5.
    NSString *timeStr = [ToolObject getDateStringWithTimestamp_time:model.create_time];
    self.timeLabel.frame = CGRectMake(REScreenWidth-20-150, 85, 150, 17);
    NSMutableAttributedString *timeLabelstring = [[NSMutableAttributedString alloc] initWithString:timeStr attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 12], NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
    self.timeLabel.attributedText = timeLabelstring;

    //6.
    NSArray *array = @[@"订单号:",@"价格(CNY):",@"数量(YDC):"];
    NSNumber *order_numnum = @(model.order_num.floatValue);
    NSString *order_num = [NSString stringWithFormat:@"%@",order_numnum];
    NSArray *numArray = @[model.ordid,model.price,order_num];
    for (int i=0; i<3; i++) {
        CGSize labelsize = [ToolObject sizeWithText:array[i] withFont:REFont(14)];
        UILabel *label = [self.contentView viewWithTag:100+i];
        label.frame = CGRectMake(45, 52+i*(20+6), labelsize.width+10, 20);
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:array[i] attributes:@{NSFontAttributeName: REFont(14), NSForegroundColorAttributeName: REColor(153, 153, 153)}];
        label.attributedText = string;

        UILabel *numLabel = [self.contentView viewWithTag:200+i];
        numLabel.frame = CGRectMake(label.right+5, 52+i*(20+6), 200, 20);
        NSMutableAttributedString *numLabelstring = [[NSMutableAttributedString alloc] initWithString:numArray[i] attributes:@{NSFontAttributeName: REFont(14), NSForegroundColorAttributeName: REColor(247, 100, 66)}];
        numLabel.attributedText = numLabelstring;
        if (i==0) {
            numLabel.textColor = REColor(51, 51, 51);
        }
    }
}
@end
