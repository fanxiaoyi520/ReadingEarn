//
//  REReadingPackageTableViewCell.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/30.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REReadingPackageTableViewCell.h"

@interface REReadingPackageTableViewCell ()

@property (nonatomic ,strong)UIImageView *bgImageView;
@property (nonatomic ,strong)UIImageView *packageImageView;
@property (nonatomic ,strong)UILabel *nameLabel;
@property (nonatomic ,strong)UILabel *dayYDCLabel;
@property (nonatomic ,strong)UILabel *validityLabel;
@property (nonatomic ,strong)UILabel *activityLevelLabel;
@property (nonatomic ,strong)UIButton *YDCNumButton;
@property (nonatomic ,strong)UIButton *YCNumButton;
@end
@implementation REReadingPackageTableViewCell

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
    bgImageView.userInteractionEnabled = YES;
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
    UILabel *validityLabel = [UILabel new];
    self.validityLabel = validityLabel;
    [bgImageView addSubview:validityLabel];
    validityLabel.textAlignment = NSTextAlignmentLeft;
 
    //6.
    UILabel *activityLevelLabel = [UILabel new];
    activityLevelLabel.textAlignment = NSTextAlignmentRight;
    self.activityLevelLabel= activityLevelLabel;
    [bgImageView addSubview:activityLevelLabel];
    
    //7.
    UIButton *YDCNumButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.YDCNumButton = YDCNumButton;
    YDCNumButton.tag = 100;
    [YDCNumButton addTarget:self action:@selector(YDCOrYCNumButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    YDCNumButton.backgroundColor = [UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0];
    YDCNumButton.layer.cornerRadius = 15;
    YDCNumButton.titleLabel.font = REFont(16);
    [YDCNumButton setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    [bgImageView addSubview:YDCNumButton];
    
    //8.
    UIButton *YCNumButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.YCNumButton = YCNumButton;
    YCNumButton.tag = 101;
    YCNumButton.hidden = YES;
    [YCNumButton addTarget:self action:@selector(YDCOrYCNumButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    YCNumButton.backgroundColor = [UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0];
    YCNumButton.layer.cornerRadius = 15;
    YCNumButton.titleLabel.font = REFont(16);
    [YCNumButton setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    [bgImageView addSubview:YCNumButton];

    
}

- (void)showDataWithModel:(REReadingPackageModel *)model withIndexPath:(nonnull NSIndexPath *)indexPath{
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
    NSString *dayYDCStr = [NSString stringWithFormat:@"每天产出%@%@",model.released_amount,model.pay_symbol];
    NSMutableAttributedString *dayYDCLabelstring = [[NSMutableAttributedString alloc] initWithString:dayYDCStr attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 15], NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    self.dayYDCLabel.attributedText = dayYDCLabelstring;
    [self.dayYDCLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@16);
        make.left.equalTo(@120);
        make.width.mas_equalTo(150);
        make.height.equalTo(@21);
    }];
    
    //5.
    NSString *validityStr = [NSString stringWithFormat:@"有效期%@天",model.released_days];
    NSMutableAttributedString *validityLabelstring = [[NSMutableAttributedString alloc] initWithString:validityStr attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 10], NSForegroundColorAttributeName: [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0]}];
    self.validityLabel.attributedText = validityLabelstring;
    self.validityLabel.textColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0];
    [self.validityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@41);
        make.left.equalTo(@120);
        make.width.mas_equalTo(150);
        make.height.equalTo(@14);
    }];
    
    //6
    NSString *actityStr = [NSString stringWithFormat:@"+%@活跃度",model.active_point];
    NSMutableAttributedString *activityLevelLabelstring = [[NSMutableAttributedString alloc] initWithString:actityStr attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 12], NSForegroundColorAttributeName: [UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0]}];
    self.activityLevelLabel.attributedText = activityLevelLabelstring;
    self.activityLevelLabel.textColor = [UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0];
    [self.activityLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@41);
        make.right.mas_equalTo(-10);
        make.width.mas_equalTo(150);
        make.height.equalTo(@17);
    }];
    
    //7.
    NSString *YDCNumStr = [NSString stringWithFormat:@"￥%@%@",model.pay_amount,model.pay_symbol];
    CGSize YDCNumSize = [ToolObject sizeWithText:YDCNumStr withFont:REFont(16)];
    [self.YDCNumButton setTitle:YDCNumStr forState:UIControlStateNormal];
    [self.YDCNumButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@82);
        make.right.mas_equalTo(-10);
        make.width.mas_equalTo(YDCNumSize.width+20);
        make.height.equalTo(@30);
    }];
    objc_setAssociatedObject(self.YDCNumButton, "firstObject", model.reading_id, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    //8.
    if ([model.status isEqualToString:@"0"]) {
        self.YCNumButton.hidden = NO;
        objc_setAssociatedObject(self.YCNumButton, "firstObject", model.reading_id, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    } else {
        self.YCNumButton.hidden = YES;
    }
    NSString *YCNumStr = [NSString stringWithFormat:@"￥%@%@",model.yc_icon,model.yc_symbol];
    CGSize YCNumSize = [ToolObject sizeWithText:YCNumStr withFont:REFont(16)];
    [self.YCNumButton setTitle:YCNumStr forState:UIControlStateNormal];
    [self.YCNumButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@82);
        make.right.mas_equalTo(self.YDCNumButton.left-YCNumSize.width-50);
        make.width.mas_equalTo(YCNumSize.width+20);
        make.height.equalTo(@30);
    }];
}

- (void)YDCOrYCNumButtonAction:(UIButton *)sender {
    NSString *first = objc_getAssociatedObject(sender, "firstObject");
    if (self.readingPackageBlock) {
        self.readingPackageBlock(sender,first);
    }
}
@end
