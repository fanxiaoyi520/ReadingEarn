//
//  RERechangeCurrencyCollectionViewCell.h
//  ReadingEarn
//
//  Created by FANS on 2019/12/14.
//  Copyright © 2019 FANS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RERCChargeTypeModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^REmoneyYDCBlock)(UIButton *sender,NSString *type_id);
@interface RERechangeCurrencyCollectionViewCell : UICollectionViewCell

@property(nonatomic ,copy)REmoneyYDCBlock moneyYDCBlock;
- (void)showDataWithModel:(RERCChargeTypeModel *)model;
@end

NS_ASSUME_NONNULL_END
