//
//  RERCAccountModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/12/14.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RERCAccountModel : RERootModel
@property (nonatomic ,copy)NSString *balance;
@property (nonatomic ,copy)NSString *symbol;

@end

NS_ASSUME_NONNULL_END
