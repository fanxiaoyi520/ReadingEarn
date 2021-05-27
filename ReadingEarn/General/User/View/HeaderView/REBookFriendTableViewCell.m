//
//  REBookFriendTableViewCell.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/29.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REBookFriendTableViewCell.h"
@interface REBookFriendTableViewCell()
@property (nonatomic ,strong)UIImageView *headImageView;
@property (nonatomic ,strong)UILabel *nameLabel;
@property (nonatomic ,strong)UILabel *timeLabel;
@property (nonatomic ,strong)UILabel *isshimingLabel;
@property (nonatomic ,strong)UIImageView *gradeImageView;

@end
@implementation REBookFriendTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self re_loadUI];
    }
    return self;
}

- (void)re_loadUI {
    
     UIView *lineView = [UIView new];
     lineView.tag = 20;
     lineView.backgroundColor = RELineColor;
     [self.contentView addSubview:lineView];

    //1.
    UIImageView *headImageView = [UIImageView new];
    [self.contentView addSubview:headImageView];
    self.headImageView = headImageView;
    
    //2.
    UILabel *nameLabel = [UILabel new];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    //3.
    UILabel *isshimingLabel = [UILabel new];
    isshimingLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:isshimingLabel];
    self.isshimingLabel = isshimingLabel;
    self.isshimingLabel.font = REFont(8);
    self.isshimingLabel.textColor = REWhiteColor;
    
    //4.
    UILabel *timeLabel = [UILabel new];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;

    //5.
    UIImageView *gradeImageView = [UIImageView new];
    [self.contentView addSubview:gradeImageView];
    self.gradeImageView = gradeImageView;

    //6.
    NSArray *array = @[@"全部实名人数",@"活跃度"];
    for (int i=0; i<2; i++) {
        UILabel *shimingNumLabel = [UILabel new];
        shimingNumLabel.tag = 200+i;
        shimingNumLabel.textAlignment = NSTextAlignmentCenter;
        shimingNumLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        [self.contentView addSubview:shimingNumLabel];
        NSMutableAttributedString *shimingNumLabelstring = [[NSMutableAttributedString alloc] initWithString:array[i] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 10], NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
        shimingNumLabel.attributedText = shimingNumLabelstring;

        
        UILabel *numLabel = [UILabel new];
        numLabel.tag = 300+i;
        numLabel.textAlignment = NSTextAlignmentCenter;
        numLabel.textColor = [UIColor colorWithRed:226/255.0 green:66/255.0 blue:54/255.0 alpha:1.0];
        [self.contentView addSubview:numLabel];
    }
    
}

- (void)showDataWithModel:(REHeaderBookFriendCellModel *)model {
    UIView *linevView = [self.contentView viewWithTag:20];
    linevView.frame = CGRectMake(84, 76, REScreenWidth-84-20, 0.5);
    if (!model) {
        return;
    }
    //1.
    self.headImageView.layer.cornerRadius = 24;
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.backgroundColor = [UIColor redColor];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@21);
        make.left.equalTo(@20);
        make.width.equalTo(@48);
        make.height.equalTo(@48);
    }];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.headimg] placeholderImage:PlaceholderHead_Image];

    //2.
    NSMutableAttributedString *nameLabelstring = [[NSMutableAttributedString alloc] initWithString:model.name attributes:@{NSFontAttributeName: REFont(14), NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    self.nameLabel.attributedText = nameLabelstring;
    CGSize namesize = [ToolObject sizeWithText:model.name withFont:REFont(14)];
    self.nameLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@18);
        make.left.equalTo(@84);
        make.height.equalTo(@20);
        make.width.lessThanOrEqualTo(@200);
    }];
    
    //3.
    NSString *shimingStr;
    if ([model.status isEqualToString:@"0"]) {
        shimingStr = @"未实名";
        self.isshimingLabel.backgroundColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    } else {
        shimingStr = @"已实名";
        self.isshimingLabel.backgroundColor = REColor(247, 100, 16);
    }
    self.isshimingLabel.layer.cornerRadius = 8;
    self.isshimingLabel.layer.masksToBounds = YES;
    CGSize shimingStrsize = [ToolObject sizeWithText:shimingStr withFont:REFont(12)];
    self.isshimingLabel.text = shimingStr;
    [self.isshimingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@21);
        make.left.mas_equalTo(self.nameLabel).offset(namesize.width+6);
        make.height.equalTo(@14);
        make.width.mas_equalTo(shimingStrsize.width+15);
    }];
    
    //4.
    NSString *timeStr = [ToolObject getDateStringWithTimestamp:model.create_time];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:timeStr attributes:@{NSFontAttributeName: REFont(12), NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
    self.timeLabel.attributedText = string;
    self.timeLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@47);
        make.left.mas_equalTo(84);
        make.width.lessThanOrEqualTo(@200);
        make.height.equalTo(@17);
    }];
    
    //5.
    [self.gradeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.right.mas_equalTo(-20);
        make.width.equalTo(@20);
        make.height.equalTo(@14);
    }];
    [self.gradeImageView sd_setImageWithURL:[NSURL URLWithString:model.rank_logo] placeholderImage:nil];
    
    //6.
    NSArray *numarray = @[model.valid_total,model.active_total];
    for (int i=0; i<2; i++) {
        UILabel *shimingNumLabel = [self.contentView viewWithTag:200+i];
        shimingNumLabel.frame = CGRectMake(114+i*(89+80), 86, 80, 14);
        
        UILabel *numLabel = [self.contentView viewWithTag:300+i];
        NSMutableAttributedString *numLabelstring = [[NSMutableAttributedString alloc] initWithString:numarray[i] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14], NSForegroundColorAttributeName: [UIColor colorWithRed:226/255.0 green:66/255.0 blue:54/255.0 alpha:1.0]}];
        numLabel.frame = CGRectMake(114+i*(89+80), 102, 80, 20);
        numLabel.attributedText = numLabelstring;
    }
}
@end
