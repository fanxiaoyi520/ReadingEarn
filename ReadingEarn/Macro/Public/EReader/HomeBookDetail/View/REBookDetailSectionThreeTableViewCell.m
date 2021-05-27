//
//  REBookDetailSectionThreeTableViewCell.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/25.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REBookDetailSectionThreeTableViewCell.h"

@interface REBookDetailSectionThreeTableViewCell ()

@end
@implementation REBookDetailSectionThreeTableViewCell

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
    
    for (int i=0; i<3; i++) {
        UIButton *headButton = [UIButton buttonWithType:UIButtonTypeCustom];
        headButton.tag = 100+i;
        [self.contentView addSubview:headButton];
        
        UIImageView *headImageView = [UIImageView new];
        headImageView.tag = 200+i;
        [headButton addSubview:headImageView];
        
        UILabel *nameLabel = [UILabel new];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.tag = 300+i;
        nameLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        [headButton addSubview:nameLabel];
        
        UILabel *moneyLabel = [UILabel new];
        moneyLabel.textAlignment = NSTextAlignmentCenter;
        moneyLabel.tag = 400+i;
        moneyLabel.textColor = [UIColor colorWithRed:255/255.0 green:198/255.0 blue:106/255.0 alpha:1.0];
        [headButton addSubview:moneyLabel];
    }
    
    //更多打赏
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreButton addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    moreButton.tag = 333;
    [self.contentView addSubview:moreButton];
}

- (void)showDataWithModel:(NSMutableArray *)model {
    UIImageView *wudashangImageView = [self.contentView viewWithTag:1000];
    wudashangImageView.hidden = YES;
    wudashangImageView.image = REImageName(@"zanwudashang");
    wudashangImageView.frame = CGRectMake((REScreenWidth-172)/2, 0, 172, 172);
    
    UILabel *wudashangLabel = [self.contentView viewWithTag:1100];
    NSMutableAttributedString *wudashangLabelstring = [[NSMutableAttributedString alloc] initWithString:@"暂无打赏" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 12], NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
    wudashangLabel.attributedText = wudashangLabelstring;
    wudashangLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    wudashangLabel.hidden = YES;
    wudashangLabel.frame = CGRectMake(0, 131, wudashangImageView.width, 17);
    
    if (model.count<1) {
        wudashangImageView.hidden = NO;
        wudashangLabel.hidden = NO;
        return;
    }

    for (int i=0; i<model.count; i++) {
        REGraInfoModel *graInfoModel = model[i];
        if (!graInfoModel) {
            return;
        }
        UIButton *headButton = [self.contentView viewWithTag:100+i];
        headButton.frame = CGRectMake(0+i*(1+(REScreenWidth-2)/3), 20, (REScreenWidth-2)/3, 96);
        
        UIImageView *headImageView = [self.contentView viewWithTag:200+i];
        [headImageView sd_setImageWithURL:[NSURL URLWithString:graInfoModel.headimg] placeholderImage:PlaceholderHead_Image];
        headImageView.frame = CGRectMake((headButton.width-40)/2, 4, 40, 40);
        
        UILabel *nameLabel = [self.contentView viewWithTag:300+i];
        NSMutableAttributedString *nameLabelstring = [[NSMutableAttributedString alloc] initWithString:graInfoModel.mobile attributes:@{NSFontAttributeName: REFont(14), NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
        nameLabel.attributedText = nameLabelstring;
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.frame = CGRectMake(0, headImageView.bottom+8, (REScreenWidth-2)/3, 20);

        UILabel *moneyLabel = [self.contentView viewWithTag:400+i];
        NSMutableAttributedString *moneyLabelstring = [[NSMutableAttributedString alloc] initWithString:graInfoModel.money attributes:@{NSFontAttributeName: REFont(14), NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:198/255.0 blue:106/255.0 alpha:1.0]}];
        moneyLabel.attributedText = moneyLabelstring;
        moneyLabel.textAlignment = NSTextAlignmentCenter;
        moneyLabel.frame = CGRectMake(0, nameLabel.bottom+4, (REScreenWidth-2)/3, 20);
    }
    
    //打赏记录
    UIButton *moreButton = [self.contentView viewWithTag:333];
    moreButton.frame = CGRectMake(0, 170-45, REScreenWidth, 34);
    moreButton.titleLabel.font = REFont(14);
    [moreButton setTitleColor:REColor(153, 153, 153) forState:UIControlStateNormal];
    [moreButton setTitle:@"更多打赏 >" forState:UIControlStateNormal];
}

- (void)moreButtonAction:(UIButton *)sender {
    if (self.morePalyRewardBlock) {
        self.morePalyRewardBlock(sender);
    }
}
@end
