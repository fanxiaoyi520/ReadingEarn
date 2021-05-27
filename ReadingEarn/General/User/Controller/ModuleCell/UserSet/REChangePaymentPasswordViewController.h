//
//  REChangePaymentPasswordViewController.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/27.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^REChangePayPwdTipsBlock)(NSString *msg);
@interface REChangePaymentPasswordViewController : RERootViewController

@property (nonatomic ,copy)REChangePayPwdTipsBlock changePayPwdTipsBlock;
@end

NS_ASSUME_NONNULL_END
