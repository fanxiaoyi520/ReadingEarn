//
//  RERechangeCurrencyCollectionReusableView.h
//  ReadingEarn
//
//  Created by FANS on 2019/12/14.
//  Copyright © 2019 FANS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RERechargeCurrencyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RERechangeCurrencyCollectionReusableView : UICollectionReusableView

- (void)showDataWithModel:(RERechargeCurrencyModel *)model;
@end

NS_ASSUME_NONNULL_END
