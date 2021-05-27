//
//  REForgetPassWordViewController.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/21.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^REForgetPasswordBlock)(NSString *msg);
@interface REForgetPassWordViewController : RERootViewController

@property(nonatomic ,copy)REForgetPasswordBlock forgetPasswordBlock;
@end

NS_ASSUME_NONNULL_END
