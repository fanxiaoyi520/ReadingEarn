//
//  REBillDetailsModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/28.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface REBillDetailsModel : RERootModel
@property (nonatomic ,copy)NSString *account;
@property (nonatomic ,copy)NSString *addtime;
@property (nonatomic ,copy)NSString *expend;
@property (nonatomic ,copy)NSString *bull_id;
@property (nonatomic ,copy)NSString *income;
@property (nonatomic ,copy)NSString *money;
@property (nonatomic ,copy)NSString *name;
@property (nonatomic ,copy)NSString *remark;
@property (nonatomic ,copy)NSString *symbol;
@property (nonatomic ,copy)NSString *type;
@property (nonatomic ,copy)NSString *user_id;


@end

NS_ASSUME_NONNULL_END
