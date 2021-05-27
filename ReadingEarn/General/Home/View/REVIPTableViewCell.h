//
//  REVIPTableViewCell.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/17.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootTableViewCell.h"
#import "HomeModel.h"
#import "HomeVipModel.h"
#import "HomeQuick2Model.h"
#import "HomeManModel.h"
#import "HomeWomanTypeModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^REVIPMoreClickBlock)(UIButton *sender);
typedef void (^REReadingBookBlock)(UIButton *sender,NSString *book_id,NSString *imageStr);
typedef void (^REBoyAndGirlBlock)(id sender);
@interface REVIPTableViewCell : RERootTableViewCell

@property (nonatomic ,copy)REVIPMoreClickBlock vipMoreClickBlock;
@property (nonatomic ,copy)REReadingBookBlock readingBookBlock;
@property (nonatomic ,copy)REBoyAndGirlBlock boyAndGirlBlock;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withModel:(HomeModel *)model;
- (void)showDataWithModel:(HomeModel *)model;

@end

NS_ASSUME_NONNULL_END
