//
//  RESingleton.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/27.
//  Copyright © 2019 FANS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "REUserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RESingleton : NSObject

@property (nonatomic ,copy)NSString *userModel;
+ (instancetype)sharedRESingleton;

- (NSArray *)personalCenterArray;

/**
交易市场
*/
- (NSArray *)tradingMarketTitleArray;
- (NSArray *)tradingMarketImageArray;
- (NSArray *)tradingMarketBuyArray;
- (NSArray *)tradingMarketSellArray;
@end

NS_ASSUME_NONNULL_END
