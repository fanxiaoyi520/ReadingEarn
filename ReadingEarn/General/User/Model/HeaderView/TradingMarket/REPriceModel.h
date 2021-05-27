//
//  REPriceModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/12/30.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface REPriceModel : RERootModel
//buy = "0.05";
//sell = "0.05";
@property (nonatomic ,copy)NSString *buy;
@property (nonatomic ,copy)NSString *sell;

@end

NS_ASSUME_NONNULL_END
