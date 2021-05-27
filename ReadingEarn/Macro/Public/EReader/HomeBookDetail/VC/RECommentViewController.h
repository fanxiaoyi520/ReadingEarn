//
//  RECommentViewController.h
//  ReadingEarn
//
//  Created by FANS on 2019/12/11.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^REBackBlock)(NSString *book_id);
@interface RECommentViewController : RERootViewController

@property (nonatomic ,copy)REBackBlock backBlock;
@property (nonatomic ,copy)NSString *book_id;
@property (nonatomic ,copy)NSString *contents_id;
@end

NS_ASSUME_NONNULL_END
