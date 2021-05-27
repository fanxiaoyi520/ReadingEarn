//
//  REAreaTableViewCell.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/17.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootTableViewCell.h"
#import "HomeAreaModel.h"
#import "HomeBookModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^REAreaMoreClickBlock)(UIButton *sender,NSString *key,UITableViewCell *cell);
typedef void (^REReadingBookBlocks)(UIButton *sender,NSString *book_id,NSString *imageStr);
@interface REAreaTableViewCell : RERootTableViewCell

@property (nonatomic ,copy)REAreaMoreClickBlock areaMoreClickBlock;
@property (nonatomic ,copy)REReadingBookBlocks readingBookBlocks;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withModel:(HomeAreaModel *)model;
- (void)showDataWithModel:(HomeAreaModel *)model withKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
