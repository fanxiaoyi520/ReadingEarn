//
//  REBookDetailSectionTwoTableViewCell.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/25.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootTableViewCell.h"
#import "RENewInfoModel.h"
#import "REBookListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface REBookDetailSectionTwoTableViewCell : RERootTableViewCell

- (void)showDataWithModel:(REBookListModel *)bookListmodel withnewInfoModel:(RENewInfoModel *)newInfoModel withIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
