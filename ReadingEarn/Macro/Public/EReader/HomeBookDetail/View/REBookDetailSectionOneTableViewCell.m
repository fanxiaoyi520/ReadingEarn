//
//  REBookDetailSectionOneTableViewCell.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/25.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REBookDetailSectionOneTableViewCell.h"

@interface REBookDetailSectionOneTableViewCell ()

@property (nonatomic ,strong)UIImageView *bookImageView;
@property (nonatomic ,strong)UILabel *bookTitleLabel;
@property (nonatomic ,strong)UILabel *bookTypeOneLabel;
@property (nonatomic ,strong)UILabel *bookTypeTwoLabel;
@property (nonatomic ,strong)UILabel *bookWordNumLabel;
@property (nonatomic ,strong)UIButton *startReadingButton;
@property (nonatomic ,strong)UIButton *jionBookShelfButton;
@property (nonatomic ,strong)UIView *lineView;
@property (nonatomic ,strong)UILabel *bookIntroduceLabel;
@property (nonatomic ,strong)CAGradientLayer *gl;
@end

@implementation REBookDetailSectionOneTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self re_loadUI];
    }
    return self;
}

- (void)re_loadUI {
    //1.
    UIImageView *bookImageView = [UIImageView new];
    [self.contentView addSubview:bookImageView];
    bookImageView.layer.cornerRadius = 8;
    bookImageView.layer.masksToBounds = YES;
    self.bookImageView = bookImageView;
    
    //2.
    UILabel *bookTitleLabel = [UILabel new];
    bookTitleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:bookTitleLabel];
    bookTitleLabel.textColor = REFontColor;
    self.bookTitleLabel = bookTitleLabel;
    [self.contentView addSubview:bookTitleLabel];

    //3.
    UILabel *bookTypeOneLabel = [UILabel new];
    bookTypeOneLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:bookTypeOneLabel];
    bookTypeOneLabel.layer.borderColor = [UIColor colorWithRed:255/255.0 green:198/255.0 blue:106/255.0 alpha:1.0].CGColor;
    bookTypeOneLabel.layer.borderWidth = 1;
    bookTypeOneLabel.layer.cornerRadius = 11;
    bookTypeOneLabel.textColor = [UIColor colorWithRed:255/255.0 green:198/255.0 blue:106/255.0 alpha:1.0];
    self.bookTypeOneLabel = bookTypeOneLabel;
    [self.contentView addSubview:bookTypeOneLabel];

    UILabel *bookTypeTwoLabel = [UILabel new];
    [self.contentView addSubview:bookTypeTwoLabel];
    bookTypeTwoLabel.textAlignment = NSTextAlignmentCenter;
    bookTypeTwoLabel.layer.borderColor = [UIColor colorWithRed:255/255.0 green:198/255.0 blue:106/255.0 alpha:1.0].CGColor;
    bookTypeTwoLabel.layer.borderWidth = 1;
    bookTypeTwoLabel.layer.cornerRadius = 11;
    bookTypeTwoLabel.textColor = [UIColor colorWithRed:255/255.0 green:198/255.0 blue:106/255.0 alpha:1.0];
    self.bookTypeTwoLabel = bookTypeTwoLabel;

    //4.
    UILabel *bookWordNumLabel = [UILabel new];
    self.bookWordNumLabel = bookWordNumLabel;
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.startPoint = CGPointMake(0, 0.1453857421875);
    gl.endPoint = CGPointMake(0.914423942565918, 0.8652682900428772);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:198/255.0 blue:106/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0),@(1.0f)];
    self.gl = gl;
    self.gl.cornerRadius = 11;
    self.gl.masksToBounds = YES;
    [self.bookImageView.layer addSublayer:gl];
    [self.bookImageView addSubview:bookWordNumLabel];

    //5.
    UIView *lineView = [UIView new];
    lineView.backgroundColor = RELineColor;
    [self.contentView addSubview:lineView];
    self.lineView = lineView;
    
    //6.
    UIButton *startReadingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:startReadingButton];
    [startReadingButton addTarget:self action:@selector(startReadingButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    startReadingButton.backgroundColor = [UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0];
    [startReadingButton setTitle:@"开始阅读" forState:UIControlStateNormal];
    [startReadingButton setTitleColor:REWhiteColor forState:UIControlStateNormal];
    startReadingButton.titleLabel.font = REFont(16);
    startReadingButton.layer.cornerRadius = 20;
    self.startReadingButton = startReadingButton;
    
    //7.
    UIButton *jionBookShelfButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:jionBookShelfButton];
    [jionBookShelfButton addTarget:self action:@selector(jionBookShelfButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [jionBookShelfButton setTitleColor:[UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0] forState:UIControlStateNormal];
    jionBookShelfButton.titleLabel.font = REFont(16);
    jionBookShelfButton.layer.borderColor = [UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0].CGColor;
    jionBookShelfButton.layer.borderWidth = 1;
    jionBookShelfButton.layer.cornerRadius = 20;
    self.jionBookShelfButton = jionBookShelfButton;
    
    //8.
    UILabel *bookIntroduceLabel = [UILabel new];
    self.bookIntroduceLabel = bookIntroduceLabel;
    [self.contentView addSubview:bookIntroduceLabel];
    bookIntroduceLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    bookIntroduceLabel.numberOfLines = 3;
    bookIntroduceLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    [self.contentView addSubview:bookIntroduceLabel];
}

- (void)showDataWithModel:(REBookInfoModel *)model withStr:(nonnull NSString *)is_Collection{
    if (!model) {
        return;
    }
    //1.
    [self.bookImageView sd_setImageWithURL:[NSURL URLWithString:model.coverpic] placeholderImage:PlaceholderImage];
    [self.bookImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@16);
        make.left.equalTo(@16);
        make.width.equalTo(@104);
        make.height.equalTo(@140);
    }];
    
    //2.
    NSMutableAttributedString *bookTitleLabelstring = [[NSMutableAttributedString alloc] initWithString:model.title attributes:@{NSFontAttributeName: REFont(18), NSForegroundColorAttributeName: REFontColor}];
    self.bookTitleLabel.attributedText = bookTitleLabelstring;
    [self.bookTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bookImageView);
        make.left.mas_equalTo(self.contentView).offset(132);
        make.width.mas_lessThanOrEqualTo(REScreenWidth-132-40-20);
        make.height.equalTo(@24);
    }];
    
    //3.
    NSMutableArray *array = [NSMutableArray array];
    for (REBookInfoTerritoryModel *bookInfoTerritoryModel in model.territory) {
        [array addObject:bookInfoTerritoryModel.attribute_name];
    }
    
    CGSize statusLabelSize;
    NSMutableAttributedString *bookTypeOneLabelstring;
    if (array.count>0) {
        statusLabelSize = [self sizeWithText:array[0] withFont:REFont(12)];
        bookTypeOneLabelstring = [[NSMutableAttributedString alloc] initWithString:array[0] attributes:@{NSFontAttributeName: REFont(12), NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:198/255.0 blue:106/255.0 alpha:1.0]}];
        self.bookTypeOneLabel.attributedText = bookTypeOneLabelstring;
    }
    [self.bookTypeOneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.mas_equalTo(self.contentView).offset(51);
       make.left.mas_equalTo(self.contentView).offset(132);
       make.width.mas_equalTo(statusLabelSize.width+20);
       make.height.equalTo(@22);
    }];
    
    NSString *statusStr;
    CGSize statusLabeltwoSize;
    NSMutableAttributedString *bookTypeTwoLabelstring;
    if (array.count>1) {
        statusStr = array[1];
        statusLabeltwoSize = [self sizeWithText:statusStr withFont:REFont(12)];
        bookTypeTwoLabelstring = [[NSMutableAttributedString alloc] initWithString:statusStr attributes:@{NSFontAttributeName: REFont(12), NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:198/255.0 blue:106/255.0 alpha:1.0]}];
        self.bookTypeTwoLabel.attributedText = bookTypeTwoLabelstring;
    }
    [self.bookTypeTwoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(51);
        make.left.mas_equalTo(self.bookTypeOneLabel).offset(20+statusLabelSize.width + 20);
        make.width.mas_equalTo(statusLabeltwoSize.width+20);
        make.height.equalTo(@22);
    }];
    
    //4.
    NSString *grade = [NSString stringWithFormat:@"%@分",model.grade];
    CGSize gradesize = [ToolObject sizeWithText:grade withFont:REFont(12)];
    self.bookWordNumLabel.frame = CGRectMake(104-6-gradesize.width-10, 140-20-10, gradesize.width+10, 20);
    self.gl.frame = CGRectMake(104-6-gradesize.width-10, 140-20-10, gradesize.width+10, 20);
    NSMutableAttributedString *bookWordNumLabelstring = [[NSMutableAttributedString alloc] initWithString:grade attributes:@{NSFontAttributeName: REFont(12), NSForegroundColorAttributeName: REWhiteColor}];
    self.bookWordNumLabel.attributedText = bookWordNumLabelstring;
    self.bookWordNumLabel.textAlignment = NSTextAlignmentCenter;

    
    //5.
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@222);
        make.left.mas_equalTo(self.contentView).offset(16);
        make.right.mas_equalTo(self.contentView).offset(-16);
        make.height.equalTo(@0.5);
    }];

    //6.
    [self.startReadingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@166);
        make.left.equalTo(@16);
        make.width.equalTo(@164);
        make.height.equalTo(@40);
    }];
    
    //7.
    
    NSString *joinStr;
    if ([is_Collection isEqualToString:@"0"]) {
        joinStr = @"加入书架";
        self.jionBookShelfButton.userInteractionEnabled = YES;
        [self.jionBookShelfButton setTitle:joinStr forState:UIControlStateNormal];
    } else {
        joinStr = @"已加入书架";
        [self.jionBookShelfButton setTitle:joinStr forState:UIControlStateNormal];
        self.jionBookShelfButton.userInteractionEnabled = NO;
    }
    [self.jionBookShelfButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@166);
        make.width.equalTo(@164);
        make.right.mas_equalTo(self.contentView).offset(-16);
        make.height.equalTo(@40);
    }];
    
    //8.
    NSString *detailStr = model.contents;
    detailStr = [detailStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    detailStr = [detailStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    CGSize detailStrSize = [self textHeightFromTextString:detailStr width:REScreenWidth-36 fontSize:14];
    CGFloat rate = self.bookIntroduceLabel.font.lineHeight;//每行需要的高度
    if (detailStrSize.height>rate*3) {
        detailStrSize.height = rate*3;
    }
    NSMutableAttributedString *bookIntroduceLabelstring = [[NSMutableAttributedString alloc] initWithString:detailStr attributes:@{NSFontAttributeName: REFont(14), NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
    self.bookIntroduceLabel.attributedText = bookIntroduceLabelstring;
    [self.bookIntroduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineView).offset(20);
        make.left.mas_equalTo(self.contentView).offset(18);
        make.right.mas_equalTo(self.contentView).offset(-18);
        make.height.mas_equalTo(detailStrSize.height);
    }];
}

#pragma mark - 事件
- (void)startReadingButtonAction:(UIButton *)sender {
    if (self.startReadBlock) {
        self.startReadBlock(sender);
    }
}

- (void)jionBookShelfButtonAction:(UIButton *)sender {
    if (self.jionBookShelfBlock) {
        self.jionBookShelfBlock(sender);
    }
}

@end
