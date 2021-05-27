//
//  REReadingHistoryTableViewCell.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/22.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REReadingHistoryTableViewCell.h"

@interface REReadingHistoryTableViewCell ()

@property (nonatomic ,strong)UIImageView *bookImageView;
@property (nonatomic ,strong)UILabel *bookNameLabel;
@property (nonatomic ,strong)UILabel *bookIntrodutionLabel;
@property (nonatomic ,strong)UIButton *bookshelvesButton;
@property (nonatomic ,strong)UIButton *deleteButton;
@property (nonatomic ,strong)UILabel *statusLabel;
@property (nonatomic ,strong)UILabel *statusLabeltwo;
@end

@implementation REReadingHistoryTableViewCell

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
    bookImageView.layer.cornerRadius = 9;
    bookImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:bookImageView];
    self.bookImageView = bookImageView;
    //2.书名
    UILabel *bookNameLabel = [UILabel new];
    bookNameLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    [self.contentView addSubview:bookNameLabel];
    self.bookNameLabel = bookNameLabel;
    
    //3.书本介绍
    UILabel *bookIntrodutionLabel = [UILabel new];
    bookIntrodutionLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    bookIntrodutionLabel.numberOfLines = 3;
    bookIntrodutionLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    [self.contentView addSubview:bookIntrodutionLabel];
    self.bookIntrodutionLabel = bookIntrodutionLabel;


    //4.类型
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

    
    //5.是否加入书架按钮
    UIButton *bookshelvesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bookshelvesButton.titleLabel.font = REFont(14);
    bookshelvesButton.layer.cornerRadius = 14;
    [bookshelvesButton addTarget:self action:@selector(bookshelvesButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [bookshelvesButton setTitleColor:REWhiteColor forState:UIControlStateNormal];
    [self.contentView addSubview:bookshelvesButton];
    self.bookshelvesButton = bookshelvesButton;
    
    //6.删除历史
    //toolbar_icon_delete_nor
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setImage:REImageName(@"toolbar_icon_delete_nor") forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:deleteButton];
    self.deleteButton = deleteButton;
}

- (void)showDataWithModel:(REReadingHistoryModel *)model {
    
    //1.
    [self.bookImageView sd_setImageWithURL:[NSURL URLWithString:model.coverpic] placeholderImage:PlaceholderImage];
    [self.bookImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@16);
        make.left.equalTo(@16);
        make.width.equalTo(@104);
        make.height.equalTo(@140);
    }];
    
    //2.
    NSMutableAttributedString *bookNameLabelstring = [[NSMutableAttributedString alloc] initWithString:model.title attributes:@{NSFontAttributeName: REFont(17), NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    self.bookNameLabel.attributedText = bookNameLabelstring;
    [self.bookNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bookImageView);
        make.left.mas_equalTo(self.contentView).offset(132);
        make.width.mas_lessThanOrEqualTo(REScreenWidth-132-40-20);
        make.height.equalTo(@24);
    }];
    
    //3.
    NSString *detailStr = model.chapter_name;
    detailStr = [detailStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    detailStr = [detailStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    CGSize detailStrSize = [self textHeightFromTextString:detailStr width:107 fontSize:14];
    CGFloat rate = self.bookIntrodutionLabel.font.lineHeight;//每行需要的高度
    if (detailStrSize.height>rate*3) {
        detailStrSize.height = rate*3;
    }
    NSMutableAttributedString *bookIntrodutionLabelstring = [[NSMutableAttributedString alloc] initWithString:detailStr attributes:@{NSFontAttributeName: REFont(14), NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
    self.bookIntrodutionLabel.attributedText = bookIntrodutionLabelstring;
    [self.bookIntrodutionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@48);
        make.left.mas_equalTo(self.contentView).offset(132);
        make.right.mas_equalTo(self.contentView).offset(-107);
        make.height.mas_equalTo(detailStrSize.height);
    }];
    
    //4.
    CGSize statusLabelSize = [self sizeWithText:model.territory withFont:REFont(12)];
    NSMutableAttributedString *statusLabelstring = [[NSMutableAttributedString alloc] initWithString:model.territory attributes:@{NSFontAttributeName: REFont(12), NSForegroundColorAttributeName: [UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0]}];
    self.statusLabel.attributedText = statusLabelstring;
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bookIntrodutionLabel).offset(12+22);
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
        make.bottom.mas_equalTo(self.bookIntrodutionLabel).offset(12+22);
        make.left.mas_equalTo(self.statusLabel).offset(20+statusLabelSize.width + 20);
        make.width.mas_equalTo(statusLabeltwoSize.width+20);
        make.height.equalTo(@22);
    }];
    
    //5.
    if ([model.is_collect isEqualToString:@"1"]) {
        [self.bookshelvesButton setTitle:@"已加入" forState:UIControlStateNormal];
        self.bookshelvesButton.backgroundColor = REColor(247, 100, 66);
    } else {
        [self.bookshelvesButton setTitle:@"未加入" forState:UIControlStateNormal];
        self.bookshelvesButton.backgroundColor = REColor(210, 210, 210);
    }
    [self.bookshelvesButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@53);
        make.right.mas_equalTo(self.contentView).offset(-16);
        make.height.equalTo(@28);
        make.width.equalTo(@72);
    }];
    
    //6.
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView).offset(-16);
        make.right.mas_equalTo(self.contentView).offset(-16);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];

}

#pragma mark - 事件
- (void)bookshelvesButtonAction:(UIButton *)sender {
    if (self.bookShelfBlock) {
        self.bookShelfBlock(sender);
    }
}

- (void)deleteButtonAction:(UIButton *)sender {
    if (self.deleteBlock) {
        self.deleteBlock(self);
    }
}

@end
