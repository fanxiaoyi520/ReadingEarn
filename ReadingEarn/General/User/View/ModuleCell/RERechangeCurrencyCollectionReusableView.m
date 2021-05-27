//
//  RERechangeCurrencyCollectionReusableView.m
//  ReadingEarn
//
//  Created by FANS on 2019/12/14.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERechangeCurrencyCollectionReusableView.h"

@interface RERechangeCurrencyCollectionReusableView ()

@property (nonatomic, strong) UIScrollView *bannelScrollow;
@property (nonatomic, strong) UILabel *yuebiLabel;
@property (nonatomic, strong) UILabel *yuebiMoneyLabel;

@end

@implementation RERechangeCurrencyCollectionReusableView
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
    UIScrollView *bannelScrollow = [UIScrollView new];
    bannelScrollow.showsHorizontalScrollIndicator = NO;
    bannelScrollow.bounces = YES;
    bannelScrollow.pagingEnabled = YES;
    [self addSubview:bannelScrollow];
    self.bannelScrollow = bannelScrollow;
    for (int i=0; i<3; i++) {
        UIImageView *bannerImageView = [UIImageView new];
        bannerImageView.tag = 100 + i;
        [bannelScrollow addSubview:bannerImageView];
    }
    
    //2.
    for (int i=0; i<2; i++) {
        UILabel *label = [UILabel new];
        label.tag = 200+i;
        label.textAlignment = NSTextAlignmentLeft;
        [self addSubview:label];
        
        UIView *lineView = [UIView new];
        lineView.tag = 300+i;
        [self addSubview:lineView];
        lineView.backgroundColor = REColor(247, 100, 66);
    }
    
    //3.
    UILabel *yuebiLabel = [UILabel new];
    self.yuebiLabel = yuebiLabel;
    [self addSubview:yuebiLabel];
    yuebiLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel *yuebiMoneyLabel = [UILabel new];
    self.yuebiMoneyLabel = yuebiMoneyLabel;
    [self addSubview:yuebiMoneyLabel];
    yuebiMoneyLabel.textAlignment = NSTextAlignmentLeft;
}

- (void)showDataWithModel:(RERechargeCurrencyModel *)model {
    if (!model) {
        return;
    }
    //1.
    CGFloat  bannelH = REScreenWidth*140/375;
    self.bannelScrollow.frame = CGRectMake(0, 0, REScreenWidth, bannelH);
    self.bannelScrollow.contentSize = CGSizeMake(model.banner.count*REScreenWidth, bannelH);
    for (int i=0; i<model.banner.count; i++) {
        RERCBannerModel *bannelModel = model.banner[i];
        UIImageView *bannelImageView = [self.bannelScrollow viewWithTag:100+i];
        bannelImageView.frame = CGRectMake(i*REScreenWidth, 0, REScreenWidth, bannelH);
        [bannelImageView sd_setImageWithURL:[NSURL URLWithString:bannelModel.ad_code] placeholderImage:PlaceholderImage];
    }

    //2.
    NSArray *array = @[@"我的余额",@"充值类型"];
    for (int i=0; i<2; i++) {
        UILabel *label = [self viewWithTag:200+i];
        CGSize size = [ToolObject sizeWithText:array[i] withFont:REFont(18)];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:array[i] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 18], NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
        label.attributedText = string;
        label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        label.frame = CGRectMake(20, bannelH+16+i*(25+132), size.width+10, 25);
        
        UIView *lineView = [self viewWithTag:300+i];
        lineView.frame = CGRectMake(20, label.bottom+4, size.width, 4);
    }
    
    //3.
    self.yuebiLabel.frame = CGRectMake(20, bannelH+85, 200, 14);
    NSMutableAttributedString *yuebiLabelstring = [[NSMutableAttributedString alloc] initWithString:@"阅币" attributes:@{NSFontAttributeName: [UIFont fontWithName:@".PingFang SC" size: 14], NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
    self.yuebiLabel.attributedText = yuebiLabelstring;
    self.yuebiLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    
    self.yuebiMoneyLabel.frame = CGRectMake(20, self.yuebiLabel.bottom + 12, 200, 24);
    NSString *balance = [ToolObject getRoundFloat:[model.account.balance floatValue] withPrecisionNum:2];
    NSString *balances = [NSString stringWithFormat:@"%@%@",balance,model.account.symbol];
    NSMutableAttributedString *yuebiMoneyLabelstring = [[NSMutableAttributedString alloc] initWithString:balances attributes:@{NSFontAttributeName: [UIFont fontWithName:@".PingFang SC" size: 24], NSForegroundColorAttributeName: [UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0]}];
    self.yuebiMoneyLabel.attributedText = yuebiMoneyLabelstring;
    self.yuebiMoneyLabel.textColor = [UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0];
}

@end
