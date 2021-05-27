//
//  REClassCollectionViewCell.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/18.
//  Copyright © 2019 FANS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface REClassCollectionViewCell : UICollectionViewCell

- (void)showClassWithModel:(ClassModel *)model;

@end

NS_ASSUME_NONNULL_END
