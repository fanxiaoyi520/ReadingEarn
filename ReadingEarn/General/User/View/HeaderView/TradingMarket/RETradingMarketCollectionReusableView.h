//
//  RETradingMarketCollectionReusableView.h
//  ReadingEarn
//
//  Created by FANS on 2019/12/5.
//  Copyright © 2019 FANS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RETradingMarketModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RETradingMarketCollectionReusableView : UICollectionReusableView

- (void)showDataWithModel:(RETradingMarketModel *)model;
@end

NS_ASSUME_NONNULL_END
