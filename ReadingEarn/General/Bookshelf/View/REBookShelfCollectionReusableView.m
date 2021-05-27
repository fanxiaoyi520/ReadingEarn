//
//  REBookShelfCollectionReusableView.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/22.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REBookShelfCollectionReusableView.h"

@interface REBookShelfCollectionReusableView ()

@property (nonatomic ,strong)UIButton *manageButton;
@property (nonatomic ,strong)UILabel *numBookLabel;

@property (nonatomic ,strong)UIView *backView;
@property (nonatomic ,strong)UIButton *selectButton;
@property (nonatomic ,strong)UIButton *deleteButton;
@property (nonatomic ,strong)UIButton *cancelButton;
@end

@implementation REBookShelfCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self re_loadUI];
    }
    return self;
}

- (void)re_loadUI {
    
    //1.管理书架
    UIButton *managerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [managerButton setTitle:@"管理书架" forState:UIControlStateNormal];
    [managerButton setTitleColor:[UIColor colorWithRed:255/255.0 green:198/255.0 blue:106/255.0 alpha:1.0] forState:UIControlStateNormal];
    managerButton.titleLabel.font = REFont(14);
    [managerButton addTarget:self action:@selector(managerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    managerButton.layer.borderColor = [UIColor colorWithRed:255/255.0 green:198/255.0 blue:106/255.0 alpha:1.0].CGColor;
    managerButton.layer.borderWidth = 1;
    managerButton.layer.cornerRadius = 14;
    [self addSubview:managerButton];
    self.manageButton = managerButton;
    
    //2.书的数目
    UILabel *numBookLabel = [UILabel new];
    numBookLabel.textAlignment = NSTextAlignmentCenter;
    numBookLabel.textColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0];
    [self addSubview:numBookLabel];
    self.numBookLabel = numBookLabel;

    [self re_managerUI];
}

- (void)re_managerUI {
    UIView *backView = [UIView new];
    backView.backgroundColor = REWhiteColor;
    [self addSubview:backView];
    backView.hidden = YES;
    self.backView = backView;
    
    //1.
    UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backView addSubview:selectButton];
    selectButton.selected = NO;
    [selectButton setTitle:@"全选" forState:UIControlStateNormal];
    [selectButton setTitle:@"取消全选" forState:UIControlStateSelected];
    selectButton.titleLabel.font = REFont(14);
    [selectButton setTitleColor:REWhiteColor forState:UIControlStateNormal];
    [selectButton addTarget:self action:@selector(selectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    selectButton.backgroundColor = [UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0];
    selectButton.layer.cornerRadius = 14;
    self.selectButton = selectButton;
    
    //2.
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backView addSubview:deleteButton];
    deleteButton.titleLabel.font = REFont(14);
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.deleteButton = deleteButton;

    //3.
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backView addSubview:cancelButton];
    cancelButton.titleLabel.font = REFont(14);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.cancelButton = cancelButton;

}

- (void)showDataWithModel:(NSMutableArray *)model {
    //1.
    [self.manageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@11);
        make.left.equalTo(@16);
        make.width.equalTo(@72);
        make.height.equalTo(@28);
    }];
    
    //2.
    NSString *countStr = [NSString stringWithFormat:@"共 %lu 本书",(unsigned long)model.count];
    CGSize countStrSize = [self sizeWithText:countStr withFont:REFont(14)];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:countStr attributes:@{NSFontAttributeName: REFont(14), NSForegroundColorAttributeName: [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0]}];
    self.numBookLabel.attributedText = string;
    self.numBookLabel.frame = CGRectMake(self.right-15-(countStrSize.width + 10), 15, countStrSize.width + 10, 20);
    
    //3.
    [self re_showManagerDataWithModel:model];
}

- (void)re_showManagerDataWithModel:(NSMutableArray *)model {
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.mas_equalTo(self);
        make.height.mas_equalTo(self);
    }];
    
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@15);
        make.left.equalTo(@16);
        make.width.equalTo(@72);
        make.height.equalTo(@28);
    }];
    
    //1.
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@15);
        make.right.mas_equalTo(self.backView).offset(-64);
        make.width.equalTo(@72);
        make.height.equalTo(@28);
    }];
    
    //2.
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@15);
        make.right.mas_equalTo(self.backView).offset(-16);
        make.width.equalTo(@72);
        make.height.equalTo(@28);
    }];
    
    //3.
}

#pragma mark - 事件
- (void)managerButtonAction:(UIButton *)sender {
    self.backView.hidden = NO;
    if (self.managerBookShelfBlock) {
        self.managerBookShelfBlock(sender);
    }
}

- (void)selectButtonAction:(UIButton *)sender {
    if (self.selectBlock) {
        self.selectBlock(sender);
    }
}

- (void)deleteButtonAction:(UIButton *)sender {
    if (self.headerDeleteBlock) {
        self.headerDeleteBlock(sender);
    }
}

- (void)cancelButtonAction:(UIButton *)sender {
    self.backView.hidden = YES;
    if (self.cancelBlock) {
        self.cancelBlock(sender);
    }
}

#pragma mark - 获取文本size
- (CGSize)sizeWithText:(NSString *)text withFont:(UIFont *)font{

    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:font}];

    return size;
}

@end
