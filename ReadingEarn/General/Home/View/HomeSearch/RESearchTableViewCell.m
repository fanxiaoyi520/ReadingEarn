//
//  RESearchTableViewCell.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/25.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RESearchTableViewCell.h"

@interface RESearchTableViewCell()
@property (nonatomic ,strong)UIImageView *huoImageView;
@property (nonatomic ,strong)UILabel *numHuoLabel;
@property (nonatomic ,strong)UIImageView *dianzanImageView;
@property (nonatomic ,strong)UILabel *dianzanLabel;
@property (nonatomic ,strong)UIButton *readButton;
@property (nonatomic ,strong)CAGradientLayer *gl;

@end
@implementation RESearchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self re_loadUI];
    }
    return self;
}

- (void)re_loadUI {
    [super re_loadUI];

    //4.
    UIImageView *huoImageView = [UIImageView new];
    huoImageView.image = REImageName(@"re_huo");
    [self.contentView addSubview:huoImageView];
    self.huoImageView = huoImageView;
    
    UILabel *numHuoLabel = [UILabel new];
    numHuoLabel.textColor = [UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0];
    [self.contentView addSubview:numHuoLabel];
    self.numHuoLabel =numHuoLabel;
    
    //5
    UIImageView *dianzanImageView = [UIImageView new];
    dianzanImageView.image = REImageName(@"re_dianzan");
    [self.contentView addSubview:dianzanImageView];
    self.dianzanImageView = dianzanImageView;
    
    UILabel *dianzanLabel = [UILabel new];
    dianzanLabel.textColor = [UIColor colorWithRed:249/255.0 green:201/255.0 blue:93/255.0 alpha:1.0];
    [self.contentView addSubview:dianzanLabel];
    self.dianzanLabel = dianzanLabel;
    
    //6.
    UIButton *readButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:readButton];
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.startPoint = CGPointMake(0, 0.15010683238506317);
    gl.endPoint = CGPointMake(0.8663414716720581, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:198/255.0 blue:106/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0),@(1.0f)];
    [readButton.layer addSublayer:gl];
    self.gl = gl;
    readButton.layer.cornerRadius = 14;
    readButton.layer.masksToBounds = YES;
    readButton.userInteractionEnabled = YES;
    [readButton setTitle:@"立即阅读" forState:UIControlStateNormal];
    readButton.titleLabel.font = REFont(14);
    self.readButton = readButton;
}

- (void)showDataWithModel:(RESearchModel *)model {
    
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
    CGSize detailStrSize = [ToolObject textHeightFromTextString:detailStr width:107 fontSize:14];
    CGFloat rate = self.detailLabel.font.lineHeight;//每行需要的高度
    if (detailStrSize.height>rate*3) {
        detailStrSize.height = rate*3;
    }
    NSMutableAttributedString *bookIntrodutionLabelstring = [[NSMutableAttributedString alloc] initWithString:detailStr attributes:@{NSFontAttributeName: REFont(14), NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
    self.detailLabel.attributedText = bookIntrodutionLabelstring;
    [self.detailLabel setText:model.contents lineSpacing:6.0f];
    self.detailLabel.font = REFont(14);

    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@48);
        make.left.mas_equalTo(self.contentView).offset(132);
        make.right.mas_equalTo(self.contentView).offset(-107);
        make.height.mas_equalTo(detailStrSize.height+20);
    }];
    
    //4.
    [self.huoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.detailLabel).offset(16+16);
        make.left.mas_equalTo(132);
        make.width.equalTo(@16);
        make.height.equalTo(@16);
    }];
    
    CGSize huosize = [ToolObject sizeWithText:model.hots withFont:REFont(12)];
    NSMutableAttributedString *numHuoLabelstring = [[NSMutableAttributedString alloc] initWithString:model.hots attributes:@{NSFontAttributeName: REFont(12), NSForegroundColorAttributeName: [UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0]}];
    self.numHuoLabel.attributedText = numHuoLabelstring;
    self.numHuoLabel.textAlignment = NSTextAlignmentLeft;
    [self.numHuoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.bottom.mas_equalTo(self.detailLabel).offset(16+17);
       make.left.mas_equalTo(self.huoImageView).offset(5+self.huoImageView.width+20);
       make.width.mas_equalTo(huosize.width+20);
       make.height.equalTo(@17);
    }];
    
    //5.
    [self.dianzanImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.detailLabel).offset(16+16);
        make.left.mas_equalTo(self.numHuoLabel).offset(10+huosize.width+20);
        make.width.equalTo(@16);
        make.height.equalTo(@16);
    }];
//
    CGSize dianzansize = [ToolObject sizeWithText:model.likes withFont:REFont(12)];
    NSMutableAttributedString *dianzanLabelstring = [[NSMutableAttributedString alloc] initWithString:model.likes attributes:@{NSFontAttributeName: REFont(12), NSForegroundColorAttributeName: [UIColor colorWithRed:249/255.0 green:201/255.0 blue:93/255.0 alpha:1.0]}];
    self.dianzanLabel.attributedText = dianzanLabelstring;
    self.dianzanLabel.textAlignment = NSTextAlignmentLeft;
    [self.dianzanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.bottom.mas_equalTo(self.detailLabel).offset(16+17);
       make.left.mas_equalTo(self.dianzanImageView).offset(5+self.dianzanImageView.width+20);
       make.width.mas_equalTo(dianzansize.width+20);
       make.height.equalTo(@17);
    }];
    
    self.gl.frame = CGRectMake(0, 0, 72, 28);
    self.readButton.frame = CGRectMake(REScreenWidth-72-16, 53, 72, 28);
}

- (void)showDataWithHomeFreeModel:(REHomeTypeFreeModel *)model {
    
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
    CGSize detailStrSize = [ToolObject textHeightFromTextString:detailStr width:107 fontSize:14];
    CGFloat rate = self.detailLabel.font.lineHeight;//每行需要的高度
    if (detailStrSize.height>rate*3) {
        detailStrSize.height = rate*3;
    }
    NSMutableAttributedString *bookIntrodutionLabelstring = [[NSMutableAttributedString alloc] initWithString:detailStr attributes:@{NSFontAttributeName: REFont(14), NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
    self.detailLabel.attributedText = bookIntrodutionLabelstring;
    [self.detailLabel setText:model.contents lineSpacing:6.0f];
    self.detailLabel.font = REFont(14);

    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@48);
        make.left.mas_equalTo(self.contentView).offset(132);
        make.right.mas_equalTo(self.contentView).offset(-107);
        make.height.mas_equalTo(detailStrSize.height+20);
    }];
    
    //4.
    [self.huoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.detailLabel).offset(16+16);
        make.left.mas_equalTo(132);
        make.width.equalTo(@16);
        make.height.equalTo(@16);
    }];
    
    CGSize huosize = [ToolObject sizeWithText:model.hots withFont:REFont(12)];
    NSMutableAttributedString *numHuoLabelstring = [[NSMutableAttributedString alloc] initWithString:model.hots attributes:@{NSFontAttributeName: REFont(12), NSForegroundColorAttributeName: [UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0]}];
    self.numHuoLabel.attributedText = numHuoLabelstring;
    self.numHuoLabel.textAlignment = NSTextAlignmentLeft;
    [self.numHuoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.bottom.mas_equalTo(self.detailLabel).offset(16+17);
       make.left.mas_equalTo(self.huoImageView).offset(5+self.huoImageView.width+20);
       make.width.mas_equalTo(huosize.width+20);
       make.height.equalTo(@17);
    }];
    
    //5.
    [self.dianzanImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.detailLabel).offset(16+16);
        make.left.mas_equalTo(self.numHuoLabel).offset(10+huosize.width+20);
        make.width.equalTo(@16);
        make.height.equalTo(@16);
    }];
//
    CGSize dianzansize = [ToolObject sizeWithText:model.likes withFont:REFont(12)];
    NSMutableAttributedString *dianzanLabelstring = [[NSMutableAttributedString alloc] initWithString:model.likes attributes:@{NSFontAttributeName: REFont(12), NSForegroundColorAttributeName: [UIColor colorWithRed:249/255.0 green:201/255.0 blue:93/255.0 alpha:1.0]}];
    self.dianzanLabel.attributedText = dianzanLabelstring;
    self.dianzanLabel.textAlignment = NSTextAlignmentLeft;
    [self.dianzanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.bottom.mas_equalTo(self.detailLabel).offset(16+17);
       make.left.mas_equalTo(self.dianzanImageView).offset(5+self.dianzanImageView.width+20);
       make.width.mas_equalTo(dianzansize.width+20);
       make.height.equalTo(@17);
    }];
    
    self.gl.frame = CGRectMake(0, 0, 72, 28);
    self.readButton.frame = CGRectMake(REScreenWidth-72-16, 53, 72, 28);
}


@end
