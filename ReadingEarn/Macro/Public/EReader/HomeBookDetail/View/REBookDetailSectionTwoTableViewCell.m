//
//  REBookDetailSectionTwoTableViewCell.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/25.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REBookDetailSectionTwoTableViewCell.h"

@interface REBookDetailSectionTwoTableViewCell ()

@property (nonatomic ,strong)UIView *backView;
@property (nonatomic ,strong)UIImageView *mynewHeadImageView;
@property (nonatomic ,strong)UILabel *headWordLabel;
@property (nonatomic ,strong)UILabel *timeLabel;
@end
@implementation REBookDetailSectionTwoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self re_loadUI];
    }
    return self;
}

- (void)re_loadUI {
    //toolbar_icon_new@3x
    
    UIView *backView = [[UIView alloc] init];
    backView.layer.borderColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0].CGColor;
    backView.layer.borderWidth = 1;
    backView.layer.cornerRadius = 8;
    [self.contentView addSubview:backView];
    self.backView = backView;
    
    //1.
    UIImageView *mynewHeadImageView = [UIImageView new];
    [backView addSubview:mynewHeadImageView];
    mynewHeadImageView.image = REImageName(@"toolbar_icon_new");
    self.mynewHeadImageView = mynewHeadImageView;
    
    //2.
    UILabel *headWordLabel = [UILabel new];
    headWordLabel.textAlignment = NSTextAlignmentLeft;
    headWordLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    self.headWordLabel = headWordLabel;
    [backView addSubview:headWordLabel];
    
    //3.
    UILabel *timeLabel = [UILabel new];
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    [backView addSubview:timeLabel];
    self.timeLabel = timeLabel;
}

- (void)showDataWithModel:(REBookListModel *)model withnewInfoModel:(nonnull RENewInfoModel *)newInfoModel withIndexPath:(nonnull NSIndexPath *)indexPath {
    if (!model || !newInfoModel) {
        return;
    }
    //self.backView.backgroundColor = [UIColor redColor];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@4);
        make.left.equalTo(@16);
        make.height.equalTo(@36);
        make.width.mas_equalTo(REScreenWidth - 32);
    }];
    
    //1.
    [self.mynewHeadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@8);
        make.left.equalTo(@8);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];

    //2.
    if (indexPath.row == 0) {
        self.backView.backgroundColor = REBackColor;
        self.mynewHeadImageView.hidden = NO;
        self.timeLabel.hidden = NO;

        NSString *chapter_name = [newInfoModel.chapter_name stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSMutableAttributedString *headWordLabelstring = [[NSMutableAttributedString alloc] initWithString:chapter_name attributes:@{NSFontAttributeName: REFont(14), NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
        self.headWordLabel.attributedText = headWordLabelstring;
        [self.headWordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@8);
            make.left.equalTo(@36);
            make.height.equalTo(@20);
            make.width.lessThanOrEqualTo(@190);
        }];

        NSMutableAttributedString *timeLabelstring = [[NSMutableAttributedString alloc] initWithString:newInfoModel.create_time attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 12], NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
        self.timeLabel.attributedText = timeLabelstring;
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@10);
            make.right.mas_equalTo(-8);
            make.height.equalTo(@17);
            make.width.equalTo(@150);
        }];
    } else {
        self.backView.backgroundColor = REWhiteColor;
        self.mynewHeadImageView.hidden = YES;
        self.timeLabel.hidden = YES;

        NSString *chapter_name = [model.chapter_name stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSMutableAttributedString *headWordLabelstring = [[NSMutableAttributedString alloc] initWithString:chapter_name attributes:@{NSFontAttributeName: REFont(14), NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
        self.headWordLabel.attributedText = headWordLabelstring;
        [self.headWordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@8);
            make.left.equalTo(@12);
            make.height.equalTo(@20);
            make.width.mas_lessThanOrEqualTo(REScreenWidth-32-24);
        }];
    }
}


@end
