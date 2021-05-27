//
//  REPersonalCenterViewController.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/27.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^REChangePayPwdTipsBlock)(NSString *msg);
typedef void (^REChangeNameOrHeadBlock)(NSString *msg);
typedef void (^REBindingAlipayBlock)(NSString *msg);
typedef void (^REIdentityAuthenticationBlock)(NSString *msg);
@interface REPersonalCenterViewController : RERootViewController

@property (nonatomic ,copy)REIdentityAuthenticationBlock identityAuthenticationBlock;
@property (nonatomic ,copy)REBindingAlipayBlock bindingAlipayBlock;
@property (nonatomic ,copy)REChangePayPwdTipsBlock changePayPwdTipsBlock;
@property (nonatomic ,copy)REChangeNameOrHeadBlock changeNameOrHeadBlock;
@end

NS_ASSUME_NONNULL_END
