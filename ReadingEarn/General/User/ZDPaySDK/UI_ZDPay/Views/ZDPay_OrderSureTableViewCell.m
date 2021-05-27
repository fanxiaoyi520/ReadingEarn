//
//  ZDPay_OrderSureTableViewCell.m
//  ReadingEarn
//
//  Created by FANS on 2020/4/14.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPay_OrderSureTableViewCell.h"
#import "ZDPayFuncTool.h"

@interface ZDPay_OrderSureTableViewCell()

@property (nonatomic ,strong)UIImageView *headImageView;
@property (nonatomic ,strong)UILabel *nameLab;
@end

@implementation ZDPay_OrderSureTableViewCell
- (void)setFrame:(CGRect)frame {
    frame.size.width = ScreenWidth-ratioW(20);
    [super setFrame:frame];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initialize];
    }
    return self;
}

#pragma mark - private
- (void)initialize {
    
    UIImageView *headImageView = [UIImageView new];
    [self.contentView addSubview:headImageView];
    self.headImageView = headImageView;
    
    UILabel *nameLab = [UILabel new];
    self.nameLab = nameLab;
    [self.contentView addSubview:nameLab];
    nameLab.textAlignment = NSTextAlignmentLeft;
    nameLab.font = ZD_Fout_Medium(ratioH(16));
    nameLab.textColor = COLORWITHHEXSTRING(@"#333333", 1.0);
    
    UIImageView *selectImageView = [UIImageView new];
    self.selectImageView = selectImageView;
    [self.contentView addSubview:selectImageView];
}

#pragma mark - public
- (void)layoutAndLoadData:(ZDPay_OrderSurePayListRespModel *)model {
    if (!model) {
        return;
    }
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.payTypePic] placeholderImage:DEFAULT_IMAGE];
    self.headImageView.frame = CGRectMake(ratioW(21), ratioH(17), ratioH(17), ratioH(17));

    CGRect contentRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:model.payType withFont:ZD_Fout_Medium(ratioH(16))];
    self.nameLab.frame = CGRectMake(self.headImageView.right + ratioW(10), ratioH(18), contentRect.size.width, ratioH(16));
    self.nameLab.text = [NSString stringWithFormat:@"%@",model.payType];
    
    self.selectImageView.image = [UIImage imageNamed:@"btn_unch"];
    self.selectImageView.frame = CGRectMake(self.right-ratioW(28), ratioH(17), ratioH(17), ratioH(18));
}
@end
