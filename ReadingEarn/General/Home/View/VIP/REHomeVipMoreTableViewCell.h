//
//  REHomeVipMoreTableViewCell.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/27.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootTableViewCell.h"
#import "REHomeEndModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^REReadingBookBlock)(UIButton *sender,NSString *book_id,NSString *imageStr);


@interface REHomeVipMoreTableViewCell : RERootTableViewCell

@property (nonatomic ,copy)REReadingBookBlock readingBookBlock;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withModel:(NSMutableArray *)model;
- (void)showDataWithModel:(NSMutableArray *)model;

@end

NS_ASSUME_NONNULL_END
