//
//  REMyReadingPackageTableViewCell.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/30.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REMyReadingPackageTableViewCell.h"

@interface REMyReadingPackageTableViewCell ()

@property (nonatomic ,strong)UIImageView *bgImageView;
@property (nonatomic ,strong)UIImageView *packageImageView;
@property (nonatomic ,strong)UILabel *nameLabel;
@property (nonatomic ,strong)UILabel *dayYDCLabel;
@property (nonatomic ,strong)UILabel *releasedLabel;
@property (nonatomic ,strong)UILabel *noReleasedLabel;
@property (nonatomic ,strong)UILabel *startLabel;
@property (nonatomic ,strong)UILabel *endLabel;
@property (nonatomic ,strong)UIButton *releasedStatusButton;
@end

@implementation REMyReadingPackageTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self re_loadUI];
    }
    return self;
}

- (void)re_loadUI {
    //1.
    UIImageView *bgImageView = [UIImageView new];
    self.bgImageView = bgImageView;
    [self.contentView addSubview:bgImageView];
    
    //2.
    UIImageView *packageImageView = [UIImageView new];
    self.packageImageView = packageImageView;
    [bgImageView addSubview:packageImageView];
    
    //3.
    UILabel *nameLabel = [UILabel new];
    self.nameLabel = nameLabel;
    [bgImageView addSubview:nameLabel];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    
    //4.
    UILabel *dayYDCLabel = [UILabel new];
    self.dayYDCLabel = dayYDCLabel;
    [bgImageView addSubview:dayYDCLabel];
    dayYDCLabel.textAlignment = NSTextAlignmentLeft;
    dayYDCLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];

    //5.
    UILabel *releasedLabel = [UILabel new];
    self.releasedLabel = releasedLabel;
    [bgImageView addSubview:releasedLabel];
    releasedLabel.textAlignment = NSTextAlignmentLeft;
    
    //6
    UILabel *noReleasedLabel = [UILabel new];
    self.noReleasedLabel = noReleasedLabel;
    [bgImageView addSubview:noReleasedLabel];
    noReleasedLabel.textAlignment = NSTextAlignmentRight;
    
    //7.
    UILabel *startLabel = [UILabel new];
    self.startLabel = startLabel;
    [bgImageView addSubview:startLabel];
    startLabel.textAlignment = NSTextAlignmentLeft;
    
    //8.
    UILabel *endLabel = [UILabel new];
    self.endLabel = endLabel;
    [bgImageView addSubview:endLabel];
    endLabel.textAlignment = NSTextAlignmentLeft;
    
    //9.
    UIButton *releasedStatusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.releasedStatusButton = releasedStatusButton;
    [bgImageView addSubview:releasedStatusButton];
    releasedStatusButton.layer.cornerRadius = 15;
    releasedStatusButton.titleLabel.font = REFont(12);
    [releasedStatusButton setTitleColor:REWhiteColor forState:UIControlStateNormal];
}

- (void)showDataWithModel:(REMyReadingPackageModel *)model {
    if (!model) {
        return;
    }
    //1.
    self.bgImageView.image = REImageName(@"reading_package");
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@12);
        make.left.equalTo(@16);
        make.right.mas_equalTo(-16);
        make.height.equalTo(@126);
    }];
    
    //2.
    [self.packageImageView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:PlaceholderImage];
    [self.packageImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.left.equalTo(@22);
        make.width.mas_equalTo(59);
        make.height.equalTo(@59);
    }];

    //3.
    NSMutableAttributedString *nameLabelstring = [[NSMutableAttributedString alloc] initWithString:model.title attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 13], NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
    self.nameLabel.attributedText = nameLabelstring;
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@90);
        make.left.equalTo(@18);
        make.width.mas_equalTo(100);
        make.height.equalTo(@18);
    }];
    
    //4.
    NSString *dayYDCStr = [NSString stringWithFormat:@"总量:%@%@",model.released_total,model.released_symbol];
    NSMutableAttributedString *dayYDCLabelstring = [[NSMutableAttributedString alloc] initWithString:dayYDCStr attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 15], NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    self.dayYDCLabel.attributedText = dayYDCLabelstring;
    [self.dayYDCLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@16);
        make.left.equalTo(@120);
        make.width.mas_equalTo(150);
        make.height.equalTo(@21);
    }];

    //5.
    NSString *releasedStr = [NSString stringWithFormat:@"已释放:%@%@",model.released_already,model.released_symbol];
    NSMutableAttributedString *releasedLabelstring = [[NSMutableAttributedString alloc] initWithString:releasedStr attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 12], NSForegroundColorAttributeName: [UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0]}];
    self.releasedLabel.attributedText = releasedLabelstring;
    self.releasedLabel.textColor = [UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0];
    [self.releasedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@41);
        make.left.equalTo(@120);
        make.width.mas_equalTo(150);
        make.height.equalTo(@17);
    }];
    
    //6.
    NSString *noReleasedStr = [NSString stringWithFormat:@"未释放:%@%@",model.released_not,model.released_symbol];
    NSMutableAttributedString *noReleasedLabelstring = [[NSMutableAttributedString alloc] initWithString:noReleasedStr attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 12], NSForegroundColorAttributeName: [UIColor colorWithRed:96/255.0 green:169/255.0 blue:242/255.0 alpha:1.0]}];
    self.noReleasedLabel.attributedText = noReleasedLabelstring;
    self.noReleasedLabel.textColor = [UIColor colorWithRed:96/255.0 green:169/255.0 blue:242/255.0 alpha:1.0];
    [self.noReleasedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@41);
        make.right.mas_equalTo(-10);
        make.width.mas_equalTo(150);
        make.height.equalTo(@17);
    }];

    //7.
    NSString *startStr = [NSString stringWithFormat:@"开始:%@",[ToolObject getDateStringWithTimestamp_time:model.start_time]];
    NSMutableAttributedString *startLabelstring = [[NSMutableAttributedString alloc] initWithString:startStr attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 10], NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
    self.startLabel.attributedText = startLabelstring;
    self.startLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    [self.startLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@79);
        make.left.mas_equalTo(120);
        make.width.mas_equalTo(150);
        make.height.equalTo(@14);
    }];
    
    //8.
    NSString *endStr = [NSString stringWithFormat:@"结束:%@",[ToolObject getDateStringWithTimestamp_time:model.end_time]];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:endStr attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 10], NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
    self.endLabel.attributedText = string;
    self.endLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    [self.endLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@97);
        make.left.mas_equalTo(120);
        make.width.mas_equalTo(150);
        make.height.equalTo(@14);
    }];

    //9.
    NSString *titleStr;
    if ([model.status isEqualToString:@"1"]) {
        titleStr = @"正在释放";
        self.releasedStatusButton.backgroundColor = [UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0];
    } else if ([model.status isEqualToString:@"2"]) {
        titleStr = @"释放结束";
        self.releasedStatusButton.backgroundColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:0.50];
        self.bgImageView.image = REImageName(@"reading_package_hui");
        self.releasedLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        self.noReleasedLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    }
    self.releasedStatusButton.layer.cornerRadius = 13;
    [self.releasedStatusButton setTitle:titleStr forState:UIControlStateNormal];
    [self.releasedStatusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@83);
        make.right.mas_equalTo(-10);
        make.width.mas_equalTo(72);
        make.height.equalTo(@26);
    }];

}

@end
