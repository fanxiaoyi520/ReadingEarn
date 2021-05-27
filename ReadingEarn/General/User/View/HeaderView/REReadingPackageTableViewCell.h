//
//  REReadingPackageTableViewCell.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/30.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootTableViewCell.h"
#import "REReadingPackageModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^REReadingPackageBlock)(UIButton *sender,NSString *text);
@interface REReadingPackageTableViewCell : RERootTableViewCell

@property (nonatomic ,copy)REReadingPackageBlock readingPackageBlock;
- (void)showDataWithModel:(REReadingPackageModel *)model withIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
