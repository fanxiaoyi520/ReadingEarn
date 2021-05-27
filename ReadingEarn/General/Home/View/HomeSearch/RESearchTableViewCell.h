//
//  RESearchTableViewCell.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/25.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootTableViewCell.h"
#import "RESearchModel.h"
#import "REHomeTypeFreeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RESearchTableViewCell : RERootTableViewCell

- (void)showDataWithModel:(RESearchModel *)model;

- (void)showDataWithHomeFreeModel:(REHomeTypeFreeModel *)model;
@end

NS_ASSUME_NONNULL_END
