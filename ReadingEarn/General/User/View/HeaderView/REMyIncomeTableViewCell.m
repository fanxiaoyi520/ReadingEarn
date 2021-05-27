//
//  REMyIncomeTableViewCell.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/29.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REMyIncomeTableViewCell.h"

@interface REMyIncomeTableViewCell()

@property (nonatomic ,strong)UILabel *dayIncomeLabel;
@property (nonatomic ,strong)UILabel *timeIncomeLabel;
@property (nonatomic ,strong)UILabel *YDCIncomeLabel;
@property (nonatomic ,strong)UILabel *numLabel;
@end
@implementation REMyIncomeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self re_loadUI];
    }
    return self;
}

- (void)re_loadUI {
    //1.
    UILabel *dayIncomeLabel = [UILabel new];
    dayIncomeLabel.textAlignment = NSTextAlignmentLeft;
    dayIncomeLabel.font = REFont(17);
    [self.contentView addSubview:dayIncomeLabel];
    dayIncomeLabel.textColor = REColor(51, 51, 51);
    self.dayIncomeLabel = dayIncomeLabel;
    
    //2.
    UILabel *timeIncomeLabel = [UILabel new];
    timeIncomeLabel.numberOfLines = 2;
    timeIncomeLabel.textAlignment = NSTextAlignmentLeft;
    timeIncomeLabel.font = REFont(14);
    [self.contentView addSubview:timeIncomeLabel];
    timeIncomeLabel.textColor = REColor(161, 161, 161);
    self.timeIncomeLabel = timeIncomeLabel;
    
    //3.
    UILabel *YDCIncomeLabel = [UILabel new];
    YDCIncomeLabel.textAlignment = NSTextAlignmentRight;
    YDCIncomeLabel.font = REFont(14);
    [self.contentView addSubview:YDCIncomeLabel];
    YDCIncomeLabel.textColor = REColor(161, 161, 161);
    self.YDCIncomeLabel = YDCIncomeLabel;

    //4.
    UILabel *numLabel = [UILabel new];
    numLabel.textAlignment = NSTextAlignmentRight;
    numLabel.font = REFont(17);
    [self.contentView addSubview:numLabel];
    numLabel.textColor = REColor(255, 96, 47);
    self.numLabel = numLabel;
    
}

- (void)showDataWithModel:(REIncomeModel *)model {
    
    if (!model) {
        return;
    }
    //1.
    CGSize dayIncomeSize = [ToolObject sizeWithText:model.name withFont:REFont(17)];
    self.dayIncomeLabel.text = model.name;
    [self.dayIncomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.left.equalTo(@20);
        make.height.equalTo(@20);
        make.width.mas_equalTo(dayIncomeSize.width+10);
    }];
    
    //2.
    NSString *timeStr = [ToolObject getDateStringWithTimestamp:model.addtime];
    CGSize timeSize = [ToolObject textHeightFromTextString:timeStr width:dayIncomeSize.width+10 fontSize:14];
    self.timeIncomeLabel.text = timeStr;
    [self.timeIncomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@40);
        make.left.equalTo(@20);
        make.width.mas_equalTo(dayIncomeSize.width+10);
        make.height.mas_equalTo(timeSize.height+10);
    }];
    
    //3.
    self.numLabel.text = [NSString stringWithFormat:@"+%@",model.money];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.right.mas_equalTo(-20);
        make.width.mas_equalTo(dayIncomeSize.width+10);
        make.height.mas_equalTo(25);
    }];
    
    //4.
    self.YDCIncomeLabel.numberOfLines = 2;
    CGSize ydcSize = [ToolObject textHeightFromTextString:model.remark width:180 fontSize:14];
    self.YDCIncomeLabel.text = model.remark;
    [self.YDCIncomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@45);
        make.right.mas_equalTo(-50);
        make.width.mas_equalTo(180);
        make.height.mas_equalTo(ydcSize.height+10);
    }];
}
@end
