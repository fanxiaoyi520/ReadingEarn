//
//  REBindingAlipayViewController.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/27.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^REBindingAlipayBlock)(NSString *msg);
@interface REBindingAlipayViewController : RERootViewController

@property (nonatomic ,copy)REBindingAlipayBlock bindingAlipayBlock;
@end

NS_ASSUME_NONNULL_END
