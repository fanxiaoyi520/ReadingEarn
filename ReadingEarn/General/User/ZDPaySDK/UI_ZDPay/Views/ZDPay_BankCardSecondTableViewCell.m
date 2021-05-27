//
//  ZDPay_BankCardSecondTableViewCell.m
//  ReadingEarn
//
//  Created by FANS on 2020/4/15.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPay_BankCardSecondTableViewCell.h"
#import "ZDPayFuncTool.h"

@interface ZDPay_BankCardSecondTableViewCell()

@property (nonatomic ,strong)UILabel *titleLab;
@property (nonatomic ,strong)UILabel *contentLab;
@property (nonatomic ,strong)UITextField *iphoneTField;
@property (nonatomic ,strong)UIButton *certificatesTypeBtn;

@end

@implementation ZDPay_BankCardSecondTableViewCell
- (void)setFrame:(CGRect)frame {
    frame.size.width = ScreenWidth;
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
    
    UILabel *titleLab = [UILabel new];
    [self.contentView addSubview:titleLab];
    self.titleLab = titleLab;
    titleLab.textColor = COLORWITHHEXSTRING(@"#333333", 1.0);
    titleLab.font = ZD_Fout_Regular(16);
    titleLab.textAlignment = NSTextAlignmentLeft;
    
    UILabel *contentLab = [UILabel new];
    [self.contentView addSubview:contentLab];
    self.contentLab = contentLab;
    contentLab.textColor = COLORWITHHEXSTRING(@"#333333", 1.0);
    contentLab.font = ZD_Fout_Regular(16);
    contentLab.textAlignment = NSTextAlignmentRight;

}

#pragma mark - public
- (void)layoutAndLoadData:(id)model {
    if (!model) {
        return;
    }
    
    CGRect titleRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:@"haha阿斯顿发生" withFont:ZD_Fout_Regular(16)];
    self.titleLab.frame = CGRectMake(20, ratioH(20), titleRect.size.width, 16);
    self.titleLab.text = @"haha阿斯顿发生";
    
    CGRect contentRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:@"asdfsaf沈德符" withFont:ZD_Fout_Regular(16)];
    self.contentLab.frame = CGRectMake(self.width-20-contentRect.size.width, ratioH(20), contentRect.size.width, 16);
    self.contentLab.text = @"asdfsaf沈德符";

}
@end
