//
//  REBookShelfCollectionViewCell.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/22.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REBookShelfCollectionViewCell.h"

@interface REBookShelfCollectionViewCell ()
@end

@implementation REBookShelfCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self re_loadUI];
    }
    return self;
}

- (void)re_loadUI {
    
    //1.书图
    UIImageView *bookImageView = [UIImageView new];
    [self.contentView addSubview:bookImageView];
    bookImageView.layer.cornerRadius = 8;
    bookImageView.userInteractionEnabled = YES;
    bookImageView.layer.masksToBounds = YES;
    self.bookImageView = bookImageView;
    
    //2.书名
    UILabel *bookNameLabel = [UILabel new];
    bookNameLabel.textAlignment = NSTextAlignmentCenter;
    bookNameLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    self.bookNameLabel = bookNameLabel;
    [self.contentView addSubview:bookNameLabel];
    
    //3.select
    UIButton *cellSelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:cellSelectButton];
    cellSelectButton.hidden = YES;
    [cellSelectButton addTarget:self action:@selector(cellSelectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cellSelectButton setImage:REImageName(@"toolbar_btn_choose_nor") forState:UIControlStateNormal];
    [cellSelectButton setImage:REImageName(@"toolbar_btn_choose_pre") forState:UIControlStateSelected];
    self.cellSelectButton = cellSelectButton;
}

- (void)showDataWithModel:(REBookShelfModel *)model {
    
    //1.
    [self.bookImageView sd_setImageWithURL:[NSURL URLWithString:model.coverpic] placeholderImage:PlaceholderImage];
    [self.bookImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.height*140/172);
        make.width.mas_equalTo(self.width);
    }];
    
    //2.
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:model.title attributes:@{NSFontAttributeName: REFont(14), NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    self.bookNameLabel.attributedText = string;
    [self.bookNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(self.width);
    }];
    
    //3.
    [self.cellSelectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.right.equalTo(@-10);
        make.width.equalTo(@22);
        make.height.equalTo(@22);
    }];
}

#pragma mark - 事件
- (void)cellSelectButtonAction:(UIButton *)sender {
    if (self.cellSelectBlock) {
        self.cellSelectBlock(self,sender);
    }
}

@end
