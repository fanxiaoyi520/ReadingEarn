//
//  RETradingMarketCollectionReusableView.m
//  ReadingEarn
//
//  Created by FANS on 2019/12/5.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RETradingMarketCollectionReusableView.h"

@interface RETradingMarketCollectionReusableView ()

@property (nonatomic ,strong)UIImageView *bgImageView;
@property (nonatomic ,strong)UILabel *dealStatusLabel;
@property (nonatomic ,strong)UILabel *globalPinkLabel;
@property (nonatomic ,strong)UILabel *dealNumLabel;
@property (nonatomic ,strong)UILabel *globalNumLabel;
@end
@implementation RETradingMarketCollectionReusableView
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
    UIImageView *bgImageView = [UIImageView new];
    [self addSubview:bgImageView];
    self.bgImageView = bgImageView;
    
    //2.
    UILabel *dealStatusLabel = [UILabel new];
    dealStatusLabel.textAlignment = NSTextAlignmentLeft;
    dealStatusLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.80];
    [self.bgImageView addSubview:dealStatusLabel];
    self.dealStatusLabel = dealStatusLabel;
    
    //新加
    UILabel *globalPinkLabel = [UILabel new];
    globalPinkLabel.textAlignment = NSTextAlignmentRight;
    globalPinkLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.80];
    [self.bgImageView addSubview:globalPinkLabel];
    self.globalPinkLabel = globalPinkLabel;
    
    UILabel *globalNumLabel = [UILabel new];
    [self.bgImageView addSubview:globalNumLabel];
    globalNumLabel.textAlignment = NSTextAlignmentCenter;
    globalNumLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.globalNumLabel = globalNumLabel;
    
    //3.
    UILabel *dealNumLabel = [UILabel new];
    [self.bgImageView addSubview:dealNumLabel];
    dealNumLabel.textAlignment = NSTextAlignmentLeft;
    dealNumLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.dealNumLabel = dealNumLabel;
    
    //4.
    for (int i=0; i<3; i++) {
        UIView *bgView = [UIView new];
        [self.bgImageView addSubview:bgView];
        bgView.tag = 50+i;
        
        UILabel *titleLabel = [UILabel new];
        [bgView addSubview:titleLabel];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.tag = 60+i;
        titleLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        
        UILabel *numLabel = [UILabel new];
        [bgView addSubview:numLabel];
        numLabel.tag = 70+i;
        numLabel.textAlignment = NSTextAlignmentCenter;
        numLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    }
}

- (void)showDataWithModel:(RETradingMarketModel *)model {
    
    //1.
    self.bgImageView.frame = CGRectMake(16, 20, REScreenWidth-32, 148);
    self.bgImageView.image = REImageName(@"tradingMarket_bg");
    
    if (!model) {
        return;
    }
    
    //2.
    self.dealStatusLabel.frame = CGRectMake(20, 20, self.bgImageView.width-20, 14);
    NSMutableAttributedString *dealStatusLabelstring = [[NSMutableAttributedString alloc] initWithString:@"买单" attributes:@{NSFontAttributeName: [UIFont fontWithName:@".PingFang SC" size: 14], NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
    self.dealStatusLabel.attributedText = dealStatusLabelstring;

    //3.
    NSString *numStr = [NSString stringWithFormat:@"%@",model.deal_now_count];
    self.dealNumLabel.frame = CGRectMake(20, self.dealStatusLabel.bottom + 12, self.bgImageView.width-20, 24);
    NSMutableAttributedString *dealNumLabelstring = [[NSMutableAttributedString alloc] initWithString:numStr attributes:@{NSFontAttributeName: [UIFont fontWithName:@".PingFang SC" size: 14], NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
    self.dealNumLabel.attributedText = dealNumLabelstring;

    //新加
    self.globalPinkLabel.frame = CGRectMake(self.bgImageView.width-20-80, 20, 80, 14);
     NSMutableAttributedString *globalPinkLabelstring = [[NSMutableAttributedString alloc] initWithString:@"全球分红" attributes:@{NSFontAttributeName: [UIFont fontWithName:@".PingFang SC" size: 14], NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
     self.globalPinkLabel.attributedText = globalPinkLabelstring;
    NSNumber *global_bonusnum = @(model.global_bonus.floatValue);
    NSString *globalnumStr = [NSString stringWithFormat:@"%@",global_bonusnum];
    self.globalNumLabel.frame = CGRectMake(self.bgImageView.width-20-80, self.dealStatusLabel.bottom + 12, 80, 24);
    NSMutableAttributedString *globalNumLabelstring = [[NSMutableAttributedString alloc] initWithString:globalnumStr attributes:@{NSFontAttributeName: [UIFont fontWithName:@".PingFang SC" size: 14], NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
    self.globalNumLabel.attributedText = globalNumLabelstring;

    //4.
    NSArray *array = @[@"成交量",@"指导价",@"涨跌幅"];
    NSString *gain = [NSString stringWithFormat:@"%@%%",[ToolObject getRoundFloat:[model.gain floatValue] withPrecisionNum:6]];
    NSString *deal_price = [ToolObject getRoundFloat:[model.deal_price floatValue] withPrecisionNum:6];
    NSString *deal_total = [ToolObject getRoundFloat:[model.deal_total floatValue] withPrecisionNum:6];
    NSArray *numArray = @[deal_total,deal_price,gain];

    for (int i=0; i<3; i++) {
        UIView *bgView = [self.bgImageView viewWithTag:50+i];
        bgView.frame = CGRectMake(i*(self.bgImageView.width/3), self.dealStatusLabel.bottom + 48, self.bgImageView.width/3, 56);
        
        UILabel *titleLabel = [bgView viewWithTag:60+i];
        NSMutableAttributedString *titleLabelstring = [[NSMutableAttributedString alloc] initWithString:array[i] attributes:@{NSFontAttributeName: [UIFont fontWithName:@".PingFang SC" size: 11], NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
        titleLabel.attributedText = titleLabelstring;
        titleLabel.frame = CGRectMake(0, 6, bgView.width, 11);

        UILabel *numLabel = [bgView viewWithTag:70+i];
        NSMutableAttributedString *numLabelstring = [[NSMutableAttributedString alloc] initWithString:numArray[i] attributes:@{NSFontAttributeName: [UIFont fontWithName:@".PingFang SC" size: 22], NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
        numLabel.attributedText = numLabelstring;
        numLabel.frame = CGRectMake(0, titleLabel.bottom + 6, bgView.width, 22);
    }
}
@end
