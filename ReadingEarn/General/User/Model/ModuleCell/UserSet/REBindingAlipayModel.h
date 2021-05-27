//
//  REBindingAlipayModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/28.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface REBindingAlipayModel : RERootModel
@property (nonatomic ,copy)NSString *self_ID;
@property (nonatomic ,copy)NSString *alipayAccount;
@property (nonatomic ,copy)NSString *QRcodePicture;
@end

NS_ASSUME_NONNULL_END
