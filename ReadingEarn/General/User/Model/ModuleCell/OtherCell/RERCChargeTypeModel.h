//
//  RERCChargeTypeModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/12/14.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"
#import "RERCCharge_moneyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RERCChargeTypeModel : RERootModel
//attribute: "4"   1首冲 2限时 3超值
//charge_money: {amount: "38.00", symbol: "YDC"}
//id: "3"
//name: "3800  书币"
//remark: "9800 + 22 赠币"
@property (nonatomic ,copy)NSString *attribute;
@property (nonatomic ,strong)RERCCharge_moneyModel *charge_money;
@property (nonatomic ,copy)NSString *type_id;
@property (nonatomic ,copy)NSString *name;
@property (nonatomic ,copy)NSString *remark;
@end

NS_ASSUME_NONNULL_END
