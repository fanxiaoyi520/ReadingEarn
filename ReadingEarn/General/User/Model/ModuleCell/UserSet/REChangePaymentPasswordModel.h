//
//  REChangePaymentPasswordModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/27.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface REChangePaymentPasswordModel : RERootModel
@property (nonatomic ,copy)NSString *oldPasswold;
@property (nonatomic ,copy)NSString *mynewPasswold;
@property (nonatomic ,copy)NSString *sureNewPasswold;
@property (nonatomic ,copy)NSString *prefix;

@end

NS_ASSUME_NONNULL_END
