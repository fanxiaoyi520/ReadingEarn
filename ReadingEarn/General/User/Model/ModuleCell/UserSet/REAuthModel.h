//
//  REAuthModel.h
//  ReadingEarn
//
//  Created by FANS on 2020/1/8.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "RERootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface REAuthModel : RERootModel

@property (nonatomic ,copy)NSString *cert_no;
@property (nonatomic ,copy)NSString *cert_name;
@end

NS_ASSUME_NONNULL_END
