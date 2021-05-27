//
//  RERootTableViewCell.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/15.
//  Copyright © 2019 FANS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RERootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RERootTableViewCell : UITableViewCell


@property (nonatomic ,strong)UIImageView *bookImageView;
@property (nonatomic ,strong)UILabel *bookNameLabel;
@property (nonatomic ,strong)UILabel *detailLabel;

- (void)re_loadUI;
- (CGRect)boundingRectWithString:(NSString *)str withSize:(CGSize)size withFont:(UIFont *)font;
- (CGSize)sizeWithText:(NSString *)text withFont:(UIFont *)font;
-(CGSize)textHeightFromTextString:(NSString *)text width:(CGFloat)textWidth fontSize:(CGFloat)size;

@end

NS_ASSUME_NONNULL_END
