///Users/fans/Desktop/ReadingEarn/ReadingEarn/General/Home/View/REVIPTableViewCell.m
//  REVIPTableViewCell.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/17.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REVIPTableViewCell.h"
@interface REVIPTableViewCell ()

@property (nonatomic, strong) NSMutableArray *homeVIPArray;
@property (nonatomic, strong) NSMutableArray *homeQuick2Array;
@property (nonatomic, strong) NSMutableArray *homeManArray;
@property (nonatomic, strong) NSMutableArray *homewomanArray;

@end

@implementation REVIPTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withModel:(HomeModel *)model {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.homeVIPArray = [NSMutableArray array];
        self.homeQuick2Array = [NSMutableArray array];
        self.homeManArray = [NSMutableArray array];
        self.homewomanArray = [NSMutableArray array];
        
        [self re_loadUI:model];
    }
    return self;
}

- (void)re_loadUI:(HomeModel *)model {
    
    NSMutableArray *vipArray = [NSMutableArray array];
    for (HomeVipModel *vipModel in model.vip) {
        [vipArray addObject:vipModel];
    }
    //1.vip专属标题
    UILabel *vipLabel = [UILabel new];
    vipLabel.tag = 100;
    [self.contentView addSubview:vipLabel];
    UIView *lineView = [UIView new];
    lineView.tag = 110;
    lineView.backgroundColor = [UIColor colorWithRed:247/255.0 green:100/255.0 blue:66/255.0 alpha:1.0];
    lineView.layer.cornerRadius = 2;
    [self.contentView addSubview:lineView];
    
    //2.查看更多
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.tag = 120;
    [moreButton setTitleColor:REColor(51, 51, 51) forState:UIControlStateNormal];
    moreButton.titleLabel.font = REFont(14);
    [self.contentView addSubview:moreButton];
    
    //3.vip专属图片书名
    for (int i=0; i<3; i++) {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:backButton];
        backButton.tag = 200+i;
        
        UIImageView *buttonImageView = [UIImageView new];
        [backButton addSubview:buttonImageView];
        buttonImageView.tag = 210+i;
        buttonImageView.layer.cornerRadius = 10;
        buttonImageView.layer.masksToBounds = YES;

        UILabel *buttonLabel = [UILabel new];
        buttonLabel.tag = 220+i;
        buttonLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        [backButton addSubview:buttonLabel];
    }
    
    //4.男生小说女生小说
    for (int i=0; i<2; i++) {
        UILabel *boyGirlLabel = [UILabel new];
        boyGirlLabel.tag = 300+i;
        boyGirlLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        [self.contentView addSubview:boyGirlLabel];
        
        UILabel *boyGirlTypeLabel = [UILabel new];
        boyGirlTypeLabel.tag = 350+i;
        boyGirlTypeLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        [self.contentView addSubview:boyGirlTypeLabel];
        
        UIImageView *boyGirlImageView = [UIImageView new];
        boyGirlImageView.tag = 380+i;
        boyGirlImageView.userInteractionEnabled = YES;
        boyGirlImageView.layer.shadowColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:0.20].CGColor;
        boyGirlImageView.layer.shadowOffset = CGSizeMake(0,2);
        boyGirlImageView.layer.shadowRadius = 10;
        boyGirlImageView.layer.shadowOpacity = 1;
        boyGirlImageView.layer.cornerRadius = 16;
        [self.contentView addSubview:boyGirlImageView];
        boyGirlImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(boyGirlAction:)];
        [boyGirlImageView addGestureRecognizer:tap];
    }
    
}

- (void)showDataWithModel:(HomeModel *)model {
    [self.homeVIPArray removeAllObjects];
    [self.homeQuick2Array removeAllObjects];
    [self.homeManArray removeAllObjects];
    [self.homewomanArray removeAllObjects];

    for (HomeVipModel *vipModel in model.vip) {
        [self.homeVIPArray addObject:vipModel];
    }
    
    for (HomeQuick2Model *quick2Model in model.quick2) {
        [self.homeQuick2Array addObject:quick2Model];
    }

    for (HomeManModel *manModel in model.manType) {
        [self.homeManArray addObject:manModel.name];
    }
    NSString *manStr = [self.homeManArray componentsJoinedByString:@" "];

    for (HomeWomanTypeModel *woManModel in model.womanType) {
        [self.homewomanArray addObject:woManModel.name];
    }
    NSString *womanStr = [self.homewomanArray componentsJoinedByString:@" "];
    
    //1.
    UILabel *vipLabel = [self.contentView viewWithTag:100];
    vipLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    if ([ToolObject onlineAuditJudgment] == YES) {
        vipLabel.text = @"VIP专属";
    } else {
        vipLabel.text = @"粉丝专属";
    }
    CGSize d = [self sizeWithText:vipLabel.text withFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    [vipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@16);
        make.height.equalTo(@25);
        make.width.mas_equalTo(d.width+20);
        make.top.mas_equalTo(self.contentView).offset(7);
    }];
    
    UIView *lineView = [self.contentView viewWithTag:110];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(vipLabel);
        make.height.equalTo(@4);
        make.width.mas_equalTo(d.width);
        make.top.mas_equalTo(self.contentView).offset(36);
    }];

    //2.
    UIButton *moreButton = [self.contentView viewWithTag:120];
    [moreButton addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    moreButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [moreButton setTitle:@"查看更多 >" forState:UIControlStateNormal];
    [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-16);
        make.height.equalTo(@20);
        make.left.equalTo(@289);
        make.top.mas_equalTo(self.contentView).offset(13);
    }];
    
    //3.
    NSMutableArray *backButtonArray = [NSMutableArray array];
    NSMutableArray *buttonImageArray = [NSMutableArray array];
    NSMutableArray *buttonLabelArray = [NSMutableArray array];
    for (int i=0; i<self.homeVIPArray.count; i++) {
        HomeVipModel *vipModel = self.homeVIPArray[i];
        UIButton *backButton = [self.contentView viewWithTag:200+i];
        [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        objc_setAssociatedObject(backButton, @"book_id", vipModel.home_id,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(backButton, @"imageStr", vipModel.coverpic,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        backButton.frame = CGRectMake((REScreenWidth-104*3)/4 + i*(104+(REScreenWidth-104*3)/4), 52, 104, 172);
        [backButtonArray addObject:backButton];
        
        UIImageView *buttonImageView = [backButton viewWithTag:210+i];
        [buttonImageView sd_setImageWithURL:[NSURL URLWithString:vipModel.coverpic] placeholderImage:PlaceholderImage];
        buttonImageView.frame = CGRectMake(0, 0, 104, 140);
        [buttonImageArray addObject:buttonImageView];
        
        UILabel *buttonLabel = [backButton viewWithTag:220+i];
        buttonLabel.textAlignment = NSTextAlignmentCenter;
        [buttonLabelArray addObject:buttonLabel];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:vipModel.title attributes:@{NSFontAttributeName: REFont(15), NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
        buttonLabel.attributedText = string;
        buttonLabel.frame = CGRectMake(0, 140+12, 104, 21);
    }
    for (int i=0; i<3; i++) {
        UIButton *backButton = [self.contentView viewWithTag:200+i];
        UIImageView *buttonImageView = [backButton viewWithTag:210+i];
        UILabel *buttonLabel = [backButton viewWithTag:220+i];
        if (self.homeVIPArray.count == 0) {
            backButton.hidden = YES;
            buttonImageView.hidden = YES;
            buttonLabel.hidden = YES;
        } else {
            backButton.hidden = NO;
            buttonImageView.hidden = NO;
            buttonLabel.hidden = NO;
        }
    }

    //4.
    NSMutableArray *boyGirlArray = [NSMutableArray array];
    NSMutableArray *boyGirlTypeArray = [NSMutableArray array];
    NSMutableArray *boyGirlImageArray = [NSMutableArray array];
    
    NSArray *array = @[@"男生小说",@"女生小说"];
    NSArray *typeArray = @[manStr,womanStr];
    for (int i=0; i<array.count; i++) {
        CGFloat h;
        if (backButtonArray.count == 0) {
            h = 72;
        } else {
            h = 245;
        }
        CGFloat boyGirlImageW = AdaptationW(16, 2, 11);
        CGFloat boyGirlImageH =  boyGirlImageW * 76 / 166;
        HomeQuick2Model *quick2Model;

        UILabel *boyGirlLabel = [self.contentView viewWithTag:300+i];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:array[i] attributes:@{NSFontAttributeName: REFont(18), NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
        boyGirlLabel.attributedText = string;
        [boyGirlArray addObject:boyGirlLabel];
        boyGirlLabel.frame = CGRectMake(16+i*(150+105), h, 150, 25);
        
        UILabel *boyGirlTypeLabel = [self.contentView viewWithTag:350+i];
        boyGirlTypeLabel.textAlignment = NSTextAlignmentLeft;
        NSMutableAttributedString *boyGirlTypestring = [[NSMutableAttributedString alloc] initWithString:typeArray[i] attributes:@{NSFontAttributeName: REFont(14), NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
        boyGirlTypeLabel.attributedText = boyGirlTypestring;
        [boyGirlTypeArray addObject:boyGirlTypeLabel];
        boyGirlTypeLabel.frame = CGRectMake(16+i*(150+51), boyGirlLabel.bottom+8, 150, 20);

        UIImageView *boyGirlImageView = [self.contentView viewWithTag:380+i];
        if (self.homeQuick2Array.count==0) {
            boyGirlImageView.hidden = YES;
        } else {
            boyGirlImageView.hidden = NO;
            quick2Model = self.homeQuick2Array[i];
        }
        [boyGirlImageView sd_setImageWithURL:[NSURL URLWithString:quick2Model.ad_code] placeholderImage:PlaceholderImage];
        [boyGirlImageArray addObject:boyGirlImageView];
        boyGirlImageView.frame = CGRectMake(16+i*(boyGirlImageW+(REScreenWidth-32-boyGirlImageW*2)), boyGirlTypeLabel.bottom+10, boyGirlImageW, boyGirlImageH);

    }
}

#pragma mark - 事件
- (void)moreButtonAction:(UIButton *)sender {
    if (self.vipMoreClickBlock) {
        self.vipMoreClickBlock(sender);
    }
}

- (void)backButtonAction:(UIButton *)sender {
    NSString * book_id = objc_getAssociatedObject(sender, @"book_id");
    NSString * imageStr = objc_getAssociatedObject(sender, @"imageStr");
    if (self.readingBookBlock) {
        self.readingBookBlock(sender,book_id,imageStr);
    }
}

- (void)boyGirlAction:(id)sender {
    if (self.boyAndGirlBlock) {
        self.boyAndGirlBlock(sender);
    }
}
@end
