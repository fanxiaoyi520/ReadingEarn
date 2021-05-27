//
//  RERootTableViewCell.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/15.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootTableViewCell.h"

@interface RERootTableViewCell()
@end
@implementation RERootTableViewCell

- (void)re_loadUI {
    //1.书图
    UIImageView *bookImageView = [UIImageView new];
    [self.contentView addSubview:bookImageView];
    self.bookImageView = bookImageView;
    bookImageView.layer.cornerRadius = 10;
    bookImageView.layer.masksToBounds = YES;

    
    //2.书名
    UILabel *bookNameLabel = [UILabel new];
    bookNameLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    [self.contentView addSubview:bookNameLabel];
    self.bookNameLabel = bookNameLabel;
    
    //3.
    UILabel *detailLabel = [UILabel new];
    detailLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    detailLabel.numberOfLines = 3;
    self.detailLabel = detailLabel;
    [self.contentView addSubview:detailLabel];

}

- (void)addSubview:(UIView *)view{
    if ([view isKindOfClass:NSClassFromString(@"_UITableViewCellSeparatorView")]) {
        return;
    }
    [super addSubview:view];
}

- (CGRect)boundingRectWithString:(NSString *)str withSize:(CGSize)size withFont:(UIFont *)font{

    CGRect rect = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];

    return rect;
}

- (CGSize)sizeWithText:(NSString *)text withFont:(UIFont *)font{

    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:font}];

    return size;
}


-(CGSize)textHeightFromTextString:(NSString *)text width:(CGFloat)textWidth fontSize:(CGFloat)size {
    //计算 label需要的宽度和高度
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:size]};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
     CGSize size1 = [text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:size]}];
    return CGSizeMake(size1.width, rect.size.height);
}

@end
