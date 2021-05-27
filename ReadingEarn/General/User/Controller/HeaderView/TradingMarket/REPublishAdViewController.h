//
//  REPublishAdViewController.h
//  ReadingEarn
//
//  Created by FANS on 2019/12/9.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^REReleaseAdBlock)(NSString *msg);
@interface REPublishAdViewController : RERootViewController

@property (nonatomic ,copy)REReleaseAdBlock releaseAdBlock;
@end

NS_ASSUME_NONNULL_END
