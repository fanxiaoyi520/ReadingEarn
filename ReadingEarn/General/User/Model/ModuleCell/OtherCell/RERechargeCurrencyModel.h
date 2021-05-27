//
//  RERechargeCurrencyModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/12/14.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"
#import "RERCAccountModel.h"
#import "RERCBannerModel.h"
#import "RERCChargeTypeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RERechargeCurrencyModel : RERootModel

@property (nonatomic ,strong)RERCAccountModel *account;
@property (nonatomic ,strong)NSMutableArray *banner;
@property (nonatomic ,strong)NSMutableArray *chargeType;
@property (nonatomic ,strong)RERCBannerModel *bannerModel;
@property (nonatomic ,strong)RERCChargeTypeModel *chargeTypeModel;

@end

NS_ASSUME_NONNULL_END
