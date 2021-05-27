//
//  RERegisterModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/22.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RERegisterModel : RERootModel

@property(nonatomic, copy)NSString *mobile;
@property(nonatomic, copy)NSString *code;
@property(nonatomic, copy)NSString *password;
@property(nonatomic, copy)NSString *confirmpwd;
@property(nonatomic, copy)NSString *tuijian;
@property(nonatomic, copy)NSString *prefix;

@end

NS_ASSUME_NONNULL_END
