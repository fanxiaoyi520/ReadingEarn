//
//  REReleaseAdModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/12/10.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface REReleaseAdModel : RERootModel

@property (nonatomic ,copy)NSString *amout;
@property (nonatomic ,copy)NSString *price;
@property (nonatomic ,copy)NSString *type;
@property (nonatomic ,copy)NSString *create_user_id_phone;
@property (nonatomic ,copy)NSString *create_user_id_email;
@property (nonatomic ,copy)NSString *payType;
@property (nonatomic ,copy)NSString *paypwd;
@end

NS_ASSUME_NONNULL_END
