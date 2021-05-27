//
//  REPlayRewardTableViewCell.m
//  ReadingEarn
//
//  Created by FANS on 2019/12/11.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REPlayRewardTableViewCell.h"

@interface REPlayRewardTableViewCell()

@property (nonatomic ,strong)UIView *lineView;
@property (nonatomic ,strong)UIImageView *headImageView;
@property (nonatomic ,strong)UILabel *nameLabel;
@property (nonatomic ,strong)UILabel *timeLabel;
@property (nonatomic ,strong)UILabel *contentLabel;
@property (nonatomic ,strong)UIImageView *tubiaoImageView;
@end
@implementation REPlayRewardTableViewCell

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
    self.lineView = lineView;
    
    //1.
    UIImageView *headImageView = [UIImageView new];
    [self.contentView addSubview:headImageView];
    self.headImageView = headImageView;
    
    //2.
    UILabel *nameLabel = [UILabel new];
    self.nameLabel = nameLabel;
    [self.contentView addSubview:nameLabel];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    
    //3.
    UILabel *timeLabel = [UILabel new];
    self.timeLabel = timeLabel;
    [self.contentView addSubview:timeLabel];
    timeLabel.textAlignment = NSTextAlignmentRight;
    
    //4.
    UILabel *contentLabel = [UILabel new];
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    contentLabel.textAlignment = NSTextAlignmentLeft;
    
    //5.
    UIImageView *tubiaoImageView = [UIImageView new];
    self.tubiaoImageView = tubiaoImageView;
    [self.contentView addSubview:tubiaoImageView];
}

- (void)showDataWithModel:(REPlayRewardModel *)model {
    self.lineView.frame = CGRectMake(63, 71.5, REScreenWidth-63-15, 0.5);
    
    if (!model) {
        return;
    }
    //1.
    self.headImageView.frame = CGRectMake(17, 18, 34, 34);
    self.headImageView.layer.cornerRadius = 17;
    self.headImageView.layer.masksToBounds = YES;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.headimg] placeholderImage:PlaceholderHead_Image];
    
    //2.
    self.nameLabel.frame = CGRectMake(self.headImageView.right+10, 16, 150, 14);
    NSMutableAttributedString *nameLabelstring = [[NSMutableAttributedString alloc] initWithString:model.mobile attributes:@{NSFontAttributeName: [UIFont fontWithName:@".PingFang SC" size: 14], NSForegroundColorAttributeName: [UIColor colorWithRed:71/255.0 green:105/255.0 blue:138/255.0 alpha:1.0]}];
    self.nameLabel.attributedText = nameLabelstring;
    self.nameLabel.textColor = [UIColor colorWithRed:71/255.0 green:105/255.0 blue:138/255.0 alpha:1.0];
    
    //3.
    NSString *create_time = [ToolObject getDateStringWithTimestamp:model.create_time];
    self.timeLabel.frame = CGRectMake(REScreenWidth-150-16, 16, 150, 12);
    NSMutableAttributedString *timeLabelstring = [[NSMutableAttributedString alloc] initWithString:create_time attributes:@{NSFontAttributeName: [UIFont fontWithName:@".PingFang SC" size: 12], NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
    self.timeLabel.attributedText = timeLabelstring;
    self.timeLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    
    //4.
    NSString *money = [NSString stringWithFormat:@"赠送:     %@书币给作者",model.money];
    self.contentLabel.frame = CGRectMake(self.headImageView.right+10, 41, 200, 14);
    NSMutableAttributedString *contentLabelstring = [[NSMutableAttributedString alloc] initWithString:money attributes:@{NSFontAttributeName: [UIFont fontWithName:@".PingFang SC" size: 14], NSForegroundColorAttributeName: [UIColor colorWithRed:58/255.0 green:58/255.0 blue:58/255.0 alpha:1.0]}];
    self.contentLabel.attributedText = contentLabelstring;
    [ToolObject LabelAttributedString:self.contentLabel FontNumber:REFont(14) AndRange:NSMakeRange(8, model.money.length) AndColor:REColor(247, 100, 66)];
    
    //5.
    self.tubiaoImageView.frame = CGRectMake(self.headImageView.right+55, 42, 14, 14);
    self.tubiaoImageView.image = REImageName(@"dashangtubiao");
}
@end
