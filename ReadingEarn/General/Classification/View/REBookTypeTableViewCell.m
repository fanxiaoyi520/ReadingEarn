//
//  REBookTypeTableViewCell.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/19.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REBookTypeTableViewCell.h"

@interface REBookTypeTableViewCell ()

@property (nonatomic ,strong)UIImageView *bookImageView;
@property (nonatomic ,strong)UILabel *bookNameLabel;
@property (nonatomic ,strong)CAGradientLayer *gl;
@property (nonatomic ,strong)UILabel *scoreLabel;
@property (nonatomic ,strong)UILabel *detailLabel;
@property (nonatomic ,strong)UILabel *statusLabel;
@property (nonatomic ,strong)UILabel *statusLabeltwo;


@end

@implementation REBookTypeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self re_loadUI];
    }
    return self;
}

- (void)re_loadUI {
    
    //1.书图
    UIImageView *bookImageView = [UIImageView new];
    [self.contentView addSubview:bookImageView];
    bookImageView.layer.cornerRadius = 10;
    bookImageView.layer.masksToBounds = YES;
    self.bookImageView = bookImageView;
    
    //2.书名
    UILabel *bookNameLabel = [UILabel new];
    bookNameLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    [self.contentView addSubview:bookNameLabel];
    self.bookNameLabel = bookNameLabel;
    
    //3.评分
    UILabel *scoreLabel = [UILabel new];
    scoreLabel.layer.cornerRadius = 10;
    scoreLabel.layer.masksToBounds=YES;
    scoreLabel.backgroundColor = REColor(255, 171, 76);
    scoreLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:scoreLabel];
    self.scoreLabel = scoreLabel;
    
    //4.
    UILabel *detailLabel = [UILabel new];
    detailLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    [self.contentView addSubview:detailLabel];
    detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    detailLabel.numberOfLines = 3;
    self.detailLabel = detailLabel;
    
    //5.
    UILabel *statusLabel = [UILabel new];
    statusLabel.layer.borderWidth = 1;
    statusLabel.layer.cornerRadius = 11;
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.layer.borderColor = [UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0].CGColor;
    statusLabel.textColor = [UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0];
    [self.contentView addSubview:statusLabel];
    self.statusLabel = statusLabel;
    
    UILabel *statusLabeltwo = [UILabel new];
    statusLabeltwo.textAlignment = NSTextAlignmentCenter;
    statusLabeltwo.layer.borderWidth = 1;
    statusLabeltwo.layer.cornerRadius = 11;
    statusLabeltwo.layer.borderColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0].CGColor;
    statusLabeltwo.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    [self.contentView addSubview:statusLabeltwo];
    self.statusLabeltwo = statusLabeltwo;

}

- (void)showDataWithModel:(REBookTypeModel *)model {
    
    //1.
    [self.bookImageView sd_setImageWithURL:[NSURL URLWithString:model.coverpic] placeholderImage:PlaceholderImage];
    [self.bookImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(16);
        make.left.mas_equalTo(self.contentView).offset(16);
        make.width.equalTo(@104);
        make.height.equalTo(@140);
    }];
    
    //2.
    NSMutableAttributedString *bookNamestring = [[NSMutableAttributedString alloc] initWithString:model.title attributes:@{NSFontAttributeName: REFont(17), NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    self.bookNameLabel.attributedText = bookNamestring;
    [self.bookNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bookImageView);
        make.left.mas_equalTo(self.contentView).offset(132);
        make.width.mas_lessThanOrEqualTo(REScreenWidth-132-40-20);
        make.height.equalTo(@24);
    }];

    //3.
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@分",model.grade] attributes:@{NSFontAttributeName: REFont(12), NSForegroundColorAttributeName: REWhiteColor}];
    self.scoreLabel.attributedText = string;
    self.scoreLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bookImageView);
        make.width.equalTo(@40);
        make.right.mas_equalTo(self.bookNameLabel).offset(50);
        make.height.equalTo(@20);
    }];

    //4.
    NSMutableAttributedString *detailstring = [[NSMutableAttributedString alloc] initWithString:model.contents attributes:@{NSFontAttributeName: REFont(14), NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
    self.detailLabel.attributedText = detailstring;
    [self.detailLabel setText:model.contents lineSpacing:6.0f];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@48);
        make.left.mas_equalTo(self.contentView).offset(132);
        make.right.mas_equalTo(self.contentView).offset(-16);
        make.height.equalTo(@80);
    }];
    
    //5.
    CGSize statusLabelSize = [self sizeWithText:model.territory withFont:REFont(12)];
    
    NSMutableAttributedString *statusLabelstring = [[NSMutableAttributedString alloc] initWithString:model.territory attributes:@{NSFontAttributeName: REFont(12), NSForegroundColorAttributeName: [UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0]}];
    self.statusLabel.attributedText = statusLabelstring;
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.detailLabel).offset(12+22);
        make.left.mas_equalTo(self.contentView).offset(132);
        make.width.mas_equalTo(statusLabelSize.width+20);
        make.height.equalTo(@22);
    }];

    NSString *statusStr;
    if ([model.status isEqualToString:@"0"]) {
        statusStr = @"更新中";
    } else {
        statusStr = @"已完结";
    }
    CGSize statusLabeltwoSize = [self sizeWithText:statusStr withFont:REFont(12)];
    NSMutableAttributedString *statusLabeltwostring = [[NSMutableAttributedString alloc] initWithString:statusStr attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 12], NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
    self.statusLabeltwo.attributedText = statusLabeltwostring;
    [self.statusLabeltwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.detailLabel).offset(12+22);
        make.left.mas_equalTo(self.statusLabel).offset(20+statusLabelSize.width + 20);
        make.width.mas_equalTo(statusLabeltwoSize.width+20);
        make.height.equalTo(@22);
    }];

}

- (CGSize)sizeWithText:(NSString *)text withFont:(UIFont *)font{
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:font}];
    return size;
}

@end
