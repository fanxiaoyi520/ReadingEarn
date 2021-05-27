//
//  REMyAdTableViewCell.m
//  ReadingEarn
//
//  Created by FANS on 2019/12/9.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REMyAdTableViewCell.h"

@interface REMyAdTableViewCell ()

@property (nonatomic ,strong)UIView *bgView;
@property (nonatomic ,strong)UIImageView *headImageView;
@property (nonatomic ,strong)UIImageView *payImageView;
@property (nonatomic ,strong)UIButton *cancleButton;
@end
@implementation REMyAdTableViewCell
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
    bgView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    bgView.layer.cornerRadius = 8;
    
    //1.
    UIImageView *headImageView = [UIImageView new];
    [self.bgView addSubview:headImageView];
    self.headImageView = headImageView;
    headImageView.layer.cornerRadius = 24;
    headImageView.layer.masksToBounds = YES;
    
    //2.
    for (int i=0; i<3; i++) {
        UILabel *label = [UILabel new];
        [self.bgView addSubview:label];
        label.tag = 100+i;
        label.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        
        UILabel *numLabel = [UILabel new];
        [self.bgView addSubview:numLabel];
        numLabel.textAlignment = NSTextAlignmentRight;
        numLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        numLabel.tag = 300+i;
        
        UILabel *numUnitLabel = [UILabel new];
        [self.bgView addSubview:numUnitLabel];
        numUnitLabel.textAlignment = NSTextAlignmentRight;
        numUnitLabel.tag = 200+i;
        numUnitLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    }
    
    //3.
    UIImageView *payImageView = [UIImageView new];
    self.payImageView = payImageView;
    [self.bgView addSubview:payImageView];
    
    //4.
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bgView addSubview:cancelButton];
    self.cancleButton = cancelButton;
    cancelButton.titleLabel.font = REFont(14);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:REWhiteColor forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.layer.cornerRadius = 14;
}

- (void)showDataWithModel:(REMyAdModel *)model {
    
    self.bgView.frame = CGRectMake(16, 8, REScreenWidth-32, 132);
    
    if (!model) {
        return;
    }
    
    //1.
    self.headImageView.frame = CGRectMake(12, 26, 48, 48);
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.headimg] placeholderImage:PlaceholderHead_Image];
    
    //2.
    NSString *amout = [NSString stringWithFormat:@"数量:%@%@",model.amout,model.symbol];
    NSString *ad_status = [NSString stringWithFormat:@"状态:%@",model.ad_status];
    NSArray *array = @[model.mobile,amout,ad_status];
    
    NSString *TotoalPrice = [NSString stringWithFormat:@"¥%@",model.TotoalPrice];
    NSString *lowup = [NSString stringWithFormat:@"限额:%@~%@",model.LowerLimit,model.UpperLimit];
    NSNumber *deal_amout_already = @(model.deal_amout_already.floatValue);
    NSString *chengjiaofenw = [NSString stringWithFormat:@"成交份额:%@",deal_amout_already];
    NSArray *numArray = @[TotoalPrice,lowup,chengjiaofenw];
    
    NSArray *unitArray = @[model.symbol,model.symbol,@"BTC"];
    for (int i=0; i<3; i++) {
        UILabel *label = [self.contentView viewWithTag:100+i];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:array[i] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 12], NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
        label.attributedText = string;
        label.frame = CGRectMake(76, 18+i*(17+8), 200, 17);
        if (i==0) {
            label.textColor = REColor(51, 51, 51);
            label.font = REFont(14);
        }
        
        if (i==2) {
            NSString *str = array[i];
            [ToolObject LabelAttributedString:label FontNumber:REFont(12) AndRange:NSMakeRange(3, str.length-3) AndColor:REColor(247, 100, 66)];
        }
        
        UILabel *numLabel = [self.contentView viewWithTag:300+i];
        NSMutableAttributedString *numLabelstring = [[NSMutableAttributedString alloc] initWithString:numArray[i] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 12], NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
        numLabel.attributedText = numLabelstring;
        numLabel.frame = CGRectMake(self.bgView.width-43-200, 22+i*(17+8), 200, 17);
        if (i==0) {
            numLabel.textColor = REColor(247, 100, 66);
            numLabel.font = REFont(20);
        }
        
        
        UILabel *numUnitLabel = [self.contentView viewWithTag:200+i];
        NSMutableAttributedString *numUnitLabelstring = [[NSMutableAttributedString alloc] initWithString:unitArray[i] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 10], NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
        numUnitLabel.attributedText = numUnitLabelstring;
        numUnitLabel.frame = CGRectMake(self.bgView.width-16-50, 27+i*(17+8), 50, 10);
        
//        if (i==1) {
//            numLabel.hidden = YES;
//            numUnitLabel.hidden = YES;
//        }
    }
    
    //3.
    self.payImageView.frame = CGRectMake(76, 92, 14, 14);
    self.payImageView.image = REImageName(@"zhifubao");
    
    
    //4.
    self.cancleButton.frame = CGRectMake(self.bgView.width-116-16, 94, 116, 28);
    if ([model.cancel isEqualToString:@"2"]) {
        self.cancleButton.backgroundColor = REColor(206, 206, 206);
        self.cancleButton.userInteractionEnabled = NO;
    } else {
        self.cancleButton.backgroundColor = REColor(247, 100, 66);
        self.cancleButton.userInteractionEnabled = YES;
    }
}

- (void)cancelButtonAction:(UIButton *)sender {
    if (self.cancelBlock) {
        self.cancelBlock(sender,self);
    }
}
@end
