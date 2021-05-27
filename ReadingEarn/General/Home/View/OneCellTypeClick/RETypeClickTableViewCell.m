//
//  RETypeClickTableViewCell.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/26.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RETypeClickTableViewCell.h"

@interface RETypeClickTableViewCell()

@property (nonatomic ,strong)CAGradientLayer *gl;
@property (nonatomic ,strong)UIButton *scoreButton;
@property (nonatomic ,strong)UILabel *statusLabel;
@property (nonatomic ,strong)UILabel *statusLabeltwo;
@property (nonatomic ,strong)REHomeTypeStatusModel *homeTypeStatusModel;
@end
@implementation RETypeClickTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self re_loadUI];
    }
    return self;

}

- (void)re_loadUI {
    [super re_loadUI];
    
    //4.评分
    UIButton *scoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:scoreButton];
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.startPoint = CGPointMake(0, 0.15010683238506317);
    gl.endPoint = CGPointMake(0.8663414716720581, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:198/255.0 blue:106/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0),@(1.0f)];
    [scoreButton.layer addSublayer:gl];
    self.gl = gl;
    scoreButton.layer.cornerRadius = 10;
    scoreButton.layer.masksToBounds = YES;
    scoreButton.titleLabel.font = REFont(14);
    self.scoreButton = scoreButton;

    //5.类型
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

- (void)showDataWithModel:(REHomeTypeClickModel *)model {
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
    NSString *detailStr = model.contents;
    detailStr = [detailStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    detailStr = [detailStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    CGSize detailStrSize = [ToolObject textHeightFromTextString:detailStr width:200 fontSize:14];
    CGFloat rate = self.detailLabel.font.lineHeight;//每行需要的高度
    if (detailStrSize.height>rate*3) {
        detailStrSize.height = rate*3;
    }
    NSMutableAttributedString *bookIntrodutionLabelstring = [[NSMutableAttributedString alloc] initWithString:detailStr attributes:@{NSFontAttributeName: REFont(14), NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
    self.detailLabel.attributedText = bookIntrodutionLabelstring;
    [self.detailLabel setText:detailStr lineSpacing:6.0f];
    self.detailLabel.font = REFont(14);

    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@48);
        make.left.mas_equalTo(self.contentView).offset(132);
        make.right.mas_equalTo(self.contentView).offset(-16);
        make.height.mas_equalTo(detailStrSize.height+20);
    }];

    //4.
    self.gl.frame = CGRectMake(0, 0, 40, 20);
    NSString *scoreStr = [NSString stringWithFormat:@"%@分",model.grade];
    [self.scoreButton setTitle:scoreStr forState:UIControlStateNormal];
    [self.scoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@18);
        make.right.mas_equalTo(self.bookNameLabel).offset(10+40);
        make.height.equalTo(@20);
        make.width.equalTo(@40);
    }];
    
    //5.
    NSMutableArray *statusArray = [NSMutableArray array];
    NSString *statusStr;
    for (NSDictionary *dic in model.territory) {
        REHomeTypeStatusModel *stautusmodel = [REHomeTypeStatusModel mj_objectWithKeyValues:dic];
        [statusArray addObject:stautusmodel.attribute_name];
        statusStr = stautusmodel.status;
    }
    NSString *attribute_name =  [statusArray componentsJoinedByString:@""];
    CGSize statusLabelSize = [self sizeWithText:attribute_name withFont:REFont(12)];
    NSMutableAttributedString *statusLabelstring = [[NSMutableAttributedString alloc] initWithString:attribute_name attributes:@{NSFontAttributeName: REFont(12), NSForegroundColorAttributeName: [UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0]}];
    self.statusLabel.attributedText = statusLabelstring;
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.detailLabel).offset(12+22);
        make.left.mas_equalTo(self.contentView).offset(132);
        make.width.mas_equalTo(statusLabelSize.width+20);
        make.height.equalTo(@22);
    }];
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


@end
