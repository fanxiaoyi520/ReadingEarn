//
//  REModifyUserInformationViewController.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/27.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^REChangeNameOrHeadBlock)(NSString *msg);
@interface REModifyUserInformationViewController : RERootViewController

@property (nonatomic ,copy)REChangeNameOrHeadBlock changeNameOrHeadBlock;
@end

NS_ASSUME_NONNULL_END
