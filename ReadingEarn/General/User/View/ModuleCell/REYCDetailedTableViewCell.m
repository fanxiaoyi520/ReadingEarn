//
//  REYCDetailedTableViewCell.m
//  ReadingEarn
//
//  Created by FANS on 2019/12/2.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REYCDetailedTableViewCell.h"

@interface REYCDetailedTableViewCell ()

@property (nonatomic ,strong)UILabel *titleLabel;
@property (nonatomic ,strong)UILabel *timeLabel;
@property (nonatomic ,strong)UILabel *ycLabel;
@property (nonatomic ,strong)UILabel *detailLabel;

@end
@implementation REYCDetailedTableViewCell
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
    lineView.backgroundColor = RELineColor;
    [self.contentView addSubview:lineView];
    lineView.tag = 10;

    //1.
    UILabel *titleLabel = [UILabel new];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:titleLabel];
    titleLabel.textColor = REColor(51, 51, 51);
    self.titleLabel = titleLabel;
    
    //2.
    UILabel *timeLabel = [UILabel new];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    timeLabel.textColor = REColor(153, 153, 153);
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    //3.yc
    UILabel *ycLabel = [UILabel new];
    [self.contentView addSubview:ycLabel];
    timeLabel.textColor = REColor(255, 105, 58);
    ycLabel.textAlignment = NSTextAlignmentRight;
    self.ycLabel = ycLabel;
    
    //4.
    UILabel *detailLabel = [UILabel new];
    [self.contentView addSubview:detailLabel];
    detailLabel.textColor = REColor(157, 157, 157);
    detailLabel.textAlignment = NSTextAlignmentRight;
    self.detailLabel = detailLabel;

}

- (void)showDataWithModel:(REBillDetailsModel *)model {
    if (!model) {
        return;
    }
    //1.
    self.titleLabel.frame = CGRectMake(20, 16, REScreenWidth-20, 20);
    NSMutableAttributedString *titleLabelstring = [[NSMutableAttributedString alloc] initWithString:model.name attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 17], NSForegroundColorAttributeName: REColor(51, 51, 51)}];
    self.titleLabel.attributedText = titleLabelstring;

    //2.
    NSString *timeStr = [ToolObject getDateStringWithTimestamp_time:model.addtime];
    self.timeLabel.frame = CGRectMake(20, self.titleLabel.bottom+14, REScreenWidth-20, 17);
    NSMutableAttributedString *timeLabelstring = [[NSMutableAttributedString alloc] initWithString:timeStr attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 13], NSForegroundColorAttributeName: REColor(51, 51, 51)}];
    self.timeLabel.attributedText = timeLabelstring;

    //3.
    NSString *ycStr;
    if ([model.expend floatValue] >0) {
        ycStr = [NSString stringWithFormat:@"-%@%@",model.expend,model.symbol];
        self.ycLabel.textColor = REColor(0, 135, 0);
    } else {
        ycStr = [NSString stringWithFormat:@"+%@%@",model.income,model.symbol];
        self.ycLabel.textColor = REColor(247, 100, 66);
    }
    self.ycLabel.frame = CGRectMake(REScreenWidth-100-20, 16, 100, 20);
    self.ycLabel.font = REFont(17);
    self.ycLabel.text = ycStr;

    //4.
    [self.detailLabel sizeToFit];
    self.detailLabel.numberOfLines = 0;
    CGSize size = [ToolObject textHeightFromTextString:model.remark width:150 fontSize:13];
    NSMutableAttributedString *detailLabelstring = [[NSMutableAttributedString alloc] initWithString:model.remark attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 13], NSForegroundColorAttributeName: REColor(51, 51, 51)}];
    self.detailLabel.attributedText = detailLabelstring;
    
    UIView *lineView = [self.contentView viewWithTag:10];
    if (size.width>200) {
        lineView.frame = CGRectMake(22,94.5, REScreenWidth-44, 0.5);
        self.detailLabel.frame = CGRectMake(REScreenWidth-200-20, self.titleLabel.bottom+14, 200, 17*2+10);
    } else {
        lineView.frame = CGRectMake(22,69.5, REScreenWidth-44, 0.5);
        self.detailLabel.frame = CGRectMake(REScreenWidth-200-20, self.titleLabel.bottom+14, 200, 17);
    }
}

@end
