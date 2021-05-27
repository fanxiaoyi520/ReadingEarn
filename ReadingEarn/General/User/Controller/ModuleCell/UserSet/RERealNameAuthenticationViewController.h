//
//  RERealNameAuthenticationViewController.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/27.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^REIdentityAuthenticationBlock)(NSString *msg);

@interface RERealNameAuthenticationViewController : RERootViewController

@property (nonatomic ,copy)REIdentityAuthenticationBlock identityAuthenticationBlock;
@end

NS_ASSUME_NONNULL_END
