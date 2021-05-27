//
//  REForgetPassModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/21.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface REForgetPassModel : RERootModel

@property (nonatomic ,copy)NSString *username;
@property (nonatomic ,copy)NSString *code;
@property (nonatomic ,copy)NSString *mynewPassword;
@property (nonatomic ,copy)NSString *mynewPassword2;
@end

NS_ASSUME_NONNULL_END
