//
//  REBookDetailSectionFourTableViewCell.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/25.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REBookDetailSectionFourTableViewCell.h"

@interface REBookDetailSectionFourTableViewCell()
@property (nonatomic ,strong)UIView *lineView;
@property (nonatomic ,strong)UIImageView *headImageView;
@property (nonatomic ,strong)UILabel *nameLabel;
@property (nonatomic ,strong)UILabel *timeLabel;
@property (nonatomic ,strong)UILabel *contentLabel;
@property (nonatomic ,strong)UILabel *replyLabel;
@property (nonatomic ,strong)UIButton *dianzanButton;
@property (nonatomic ,strong)UIButton *replyButton;

@end
@implementation REBookDetailSectionFourTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self re_loadUI];
    }
    return self;
}

- (void)re_loadUI {
    UIImageView *wudashangImageView = [UIImageView new];
    wudashangImageView.tag = 1000;
    [self.contentView addSubview:wudashangImageView];

    UILabel *wudashangLabel = [UILabel new];
    [wudashangImageView addSubview:wudashangLabel];
    wudashangLabel.textAlignment = NSTextAlignmentCenter;
    wudashangLabel.tag = 1100;
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = RELineColor;
    [self.contentView addSubview:lineView];
    self.lineView = lineView;
    
    //1.
    UIImageView *headImageView = [UIImageView new];
    [self.contentView addSubview:headImageView];
    self.headImageView = headImageView;

    //2.
    UILabel *nameLabel = [UILabel new];
    self.nameLabel = nameLabel;
    [self.contentView addSubview:nameLabel];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    
    //3.
    UILabel *contentLabel = [UILabel new];
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    contentLabel.numberOfLines = 0;
    contentLabel.textAlignment = NSTextAlignmentLeft;
    
    //4.
    UILabel *timeLabel = [UILabel new];
    self.timeLabel = timeLabel;
    [self.contentView addSubview:timeLabel];
    timeLabel.textAlignment = NSTextAlignmentLeft;

    //5.回复
    for (int i = 0; i<100; i++) {
        UILabel *replyLabel = [UILabel new];
        replyLabel.backgroundColor = REBackColor;
        replyLabel.textColor = REColor(104, 104, 104);
        [self.contentView addSubview:replyLabel];
        replyLabel.tag = 5000+i;
    }
    
    //6.点赞
    UIButton *dianzanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:dianzanButton];
    [dianzanButton addTarget:self action:@selector(dianzanButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.dianzanButton = dianzanButton;
    
    //7.回复
    UIButton *replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:replyButton];
    self.replyButton = replyButton;
    replyButton.titleLabel.font = REFont(12);
    [replyButton setTitleColor:REColor(210, 210, 210) forState:UIControlStateNormal];
    [replyButton addTarget:self action:@selector(replyButtonAction:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)showDataWithModel {
    UIImageView *wudashangImageView = [self.contentView viewWithTag:1000];
    wudashangImageView.hidden = YES;
    wudashangImageView.image = REImageName(@"zanwudashang");
    wudashangImageView.frame = CGRectMake((REScreenWidth-172)/2, 0, 172, 172);

    UILabel *wudashangLabel = [self.contentView viewWithTag:1100];
    NSMutableAttributedString *wudashangLabelstring = [[NSMutableAttributedString alloc] initWithString:@"暂无评论" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 12], NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
    wudashangLabel.attributedText = wudashangLabelstring;
    wudashangLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    wudashangLabel.hidden = YES;
    wudashangLabel.frame = CGRectMake(0, 131, wudashangImageView.width, 17);
    wudashangImageView.hidden = NO;
    wudashangLabel.hidden = NO;
}

- (void)showDataWithModel:(RECommentsListModel *)model {
    UIImageView *wudashangImageView = [self.contentView viewWithTag:1000];
    wudashangImageView.hidden = YES;
    wudashangImageView.image = REImageName(@"zanwudashang");
    wudashangImageView.frame = CGRectMake((REScreenWidth-172)/2, 0, 172, 172);
    
    UILabel *wudashangLabel = [self.contentView viewWithTag:1100];
    NSMutableAttributedString *wudashangLabelstring = [[NSMutableAttributedString alloc] initWithString:@"暂无评论" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 12], NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
    wudashangLabel.attributedText = wudashangLabelstring;
    wudashangLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    wudashangLabel.hidden = YES;
    wudashangLabel.frame = CGRectMake(0, 131, wudashangImageView.width, 17);
    
    if (!model || [model isEqual:@""]) {
        wudashangImageView.hidden = NO;
        wudashangLabel.hidden = NO;
        return;
    }

    
    //1.
    self.headImageView.frame = CGRectMake(17, 18, 34, 34);
    self.headImageView.layer.cornerRadius = 17;
    self.headImageView.layer.masksToBounds = YES;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.headimg] placeholderImage:PlaceholderHead_Image];
    
    //2.
    self.nameLabel.frame = CGRectMake(self.headImageView.right+10, 16, 150, 14);
    NSMutableAttributedString *nameLabelstring = [[NSMutableAttributedString alloc] initWithString:model.mobile attributes:@{NSFontAttributeName: [UIFont fontWithName:@".PingFang SC" size: 14], NSForegroundColorAttributeName: [UIColor colorWithRed:71/255.0 green:105/255.0 blue:138/255.0 alpha:1.0]}];
    self.nameLabel.attributedText = nameLabelstring;
    self.nameLabel.textColor = [UIColor colorWithRed:71/255.0 green:105/255.0 blue:138/255.0 alpha:1.0];
    
    //3.
    CGSize contentsize = [ToolObject textHeightFromTextString:model.content width:200 fontSize:14];
    self.contentLabel.frame = CGRectMake(self.headImageView.right+10, 41, 200, contentsize.height);
    NSMutableAttributedString *contentLabelstring = [[NSMutableAttributedString alloc] initWithString:model.content attributes:@{NSFontAttributeName: [UIFont fontWithName:@".PingFang SC" size: 14], NSForegroundColorAttributeName: [UIColor colorWithRed:58/255.0 green:58/255.0 blue:58/255.0 alpha:1.0]}];
    self.contentLabel.attributedText = contentLabelstring;

    //4.
     NSString *create_time = [ToolObject getDateStringWithTimestamp:model.create_time];
     self.timeLabel.frame = CGRectMake(62, self.contentLabel.bottom+16, 150, 12);
     NSMutableAttributedString *timeLabelstring = [[NSMutableAttributedString alloc] initWithString:create_time attributes:@{NSFontAttributeName: [UIFont fontWithName:@".PingFang SC" size: 12], NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
     self.timeLabel.attributedText = timeLabelstring;
     self.timeLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];

    //5.回复
    for (int i = 0; i<model.sons.count; i++) {
        RECommentListSonModel *commentListSonModel = model.sons[i];
        NSString *str = [NSString stringWithFormat:@" %@:%@",commentListSonModel.mobile,commentListSonModel.content];
        UILabel *replyLabel = [self.contentView viewWithTag:5000+i];
        NSMutableAttributedString *replyLabelstring = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14], NSForegroundColorAttributeName: [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]}];
        replyLabel.attributedText = replyLabelstring;
        replyLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        replyLabel.frame = CGRectMake(62, self.timeLabel.bottom+12+i*(36), REScreenWidth-62-16, 36);
        
        if (i==model.sons.count-1) {

            self.lineView.frame = CGRectMake(63, replyLabel.bottom+12.5, REScreenWidth-63-15, 0.5);
        }
    }
    if (model.sons.count == 0) {
        self.lineView.frame = CGRectMake(63, self.timeLabel.bottom+12.5, REScreenWidth-63-15, 0.5);
    }
    
    //6.
    if ([model.is_like isEqualToString:@"0"]) {
        [self.dianzanButton setImage:REImageName(@"toolbar_icon_good_nor") forState:UIControlStateNormal];
    } else {
        [self.dianzanButton setImage:REImageName(@"toolbar_icon_good_pre") forState:UIControlStateNormal];
    }
    self.dianzanButton.frame = CGRectMake(REScreenWidth-18-16, 25, 18, 18);
    objc_setAssociatedObject(self.dianzanButton,"dianzanButton", model.list_id, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    //7.
    NSString *replyStr;
    if ([model.replay_total isEqualToString:@"0"]) {
        replyStr = @"回复";
    } else {
        replyStr = [NSString stringWithFormat:@"回复(%@)",model.replay_total];
    }
    self.replyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.replyButton setTitle:replyStr forState:UIControlStateNormal];
    self.replyButton.frame = CGRectMake(REScreenWidth-16-100, self.contentLabel.bottom+11, 100, 22);
    objc_setAssociatedObject(self.replyButton,"secondObject", model.list_id, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - 事件
- (void)dianzanButtonAction:(UIButton *)sender {
    NSString *first = objc_getAssociatedObject(sender,"dianzanButton");
    if (self.dianzanBlock) {
        self.dianzanBlock(sender,first,self);
    }
}

- (void)replyButtonAction:(UIButton *)sender {
    NSString *first = objc_getAssociatedObject(sender,"secondObject");
    if (self.replyBlock) {
        self.replyBlock(sender,first,self);
    }
}

@end
