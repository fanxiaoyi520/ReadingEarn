//
//  REAdvertisementCollectionViewCell.m
//  ReadingEarn
//
//  Created by FANS on 2019/12/23.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REAdvertisementCollectionViewCell.h"

@interface REAdvertisementCollectionViewCell ()

@property (nonatomic ,strong)UIImageView *personImageView;
@property (nonatomic ,strong)UILabel *introduceLabel;
@property (nonatomic ,strong)UIImageView *headerImageView;
@property (nonatomic ,strong)UILabel *nameLabel;
@property (nonatomic ,strong)UIImageView *timeImageView;
@property (nonatomic ,strong)UILabel *timeLabel;

@end
@implementation REAdvertisementCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self re_loadUI];
    }
    return self;
}

- (void)re_loadUI {
    //1.
    UIImageView *personImageView = [UIImageView new];
    [self.contentView addSubview:personImageView];
    personImageView.userInteractionEnabled = YES;
    self.personImageView = personImageView;
    
    //2.
    UILabel *introduceLabel = [UILabel new];
    self.introduceLabel = introduceLabel;
    introduceLabel.textAlignment = NSTextAlignmentLeft;
    introduceLabel.textColor = REWhiteColor;
    introduceLabel.font = REFont(16);
    [self.contentView addSubview:introduceLabel];
    
    //3.
    UIImageView *headerImageView = [UIImageView new];
    self.headerImageView = headerImageView;
    headerImageView.layer.cornerRadius = 8;
    headerImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:headerImageView];
    
    //4.
    UILabel *nameLabel = [UILabel new];
    self.nameLabel = nameLabel;
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.textColor = REWhiteColor;
    nameLabel.font = REFont(10);
    [self.contentView addSubview:nameLabel];
    
    //5.
    UIImageView *timeImageView = [UIImageView new];
    self.timeImageView = timeImageView;
    timeImageView.layer.cornerRadius = 5;
    timeImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:timeImageView];
    
    //6.
    UILabel *timeLabel = [UILabel new];
    self.timeLabel = timeLabel;
    timeLabel.textAlignment = NSTextAlignmentLeft;
    timeLabel.textColor = REWhiteColor;
    timeLabel.font = REFont(10);
    [self.contentView addSubview:timeLabel];

}

- (void)showDataWithModel:(REAdvertisementModel *)model {

    if (!model) {
        return;
    }
    //1.
    self.personImageView.frame = CGRectMake(0, 0, self.width, self.height);
    [self.personImageView sd_setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:PlaceholderImage];
    self.personImageView.contentMode=UIViewContentModeScaleAspectFill;
    self.personImageView.clipsToBounds=YES;
    
    //2.
    self.introduceLabel.frame = CGRectMake(4, 224*(self.height)/272, self.width, 16*(self.height)/272);
    self.introduceLabel.text = model.introduce;
    
    //3.
    self.headerImageView.frame = CGRectMake(4, self.introduceLabel.bottom+8, 16*(self.height)/272, 16*(self.height)/272);
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:PlaceholderHead_Image];
    
    //4.
    self.nameLabel.frame = CGRectMake(self.headerImageView.right+2, self.introduceLabel.bottom+9, 100, 16*(self.height)/272);
    self.nameLabel.text = model.name;
    
    //5.
    NSString *timestr = [ToolObject getDateStringWithTimestamp:model.create_time];
    CGSize size = [ToolObject sizeWithText:timestr withFont:REFont(10)];
    self.timeImageView.frame = CGRectMake(self.width-size.width-20, self.introduceLabel.bottom+11, 10, 10);
    self.timeImageView.backgroundColor = [UIColor darkGrayColor];
    self.timeImageView.image = REImageName(@"waiting_pay_time1");

    //6.
    self.timeLabel.frame = CGRectMake(self.timeImageView.right+4, self.introduceLabel.bottom+11, size.width+10, 10);
    self.timeLabel.text = timestr;
}
@end
