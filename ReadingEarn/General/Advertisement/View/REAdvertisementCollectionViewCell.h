//
//  REAdvertisementCollectionViewCell.h
//  ReadingEarn
//
//  Created by FANS on 2019/12/23.
//  Copyright © 2019 FANS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REAdvertisementModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface REAdvertisementCollectionViewCell : UICollectionViewCell

- (void)showDataWithModel:(REAdvertisementModel *)model;
@end

NS_ASSUME_NONNULL_END
