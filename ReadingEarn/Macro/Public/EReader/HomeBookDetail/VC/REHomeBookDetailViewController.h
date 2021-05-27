//
//  REHomeBookDetailViewController.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/23.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^BackChapterBlock)(NSString *);
@interface REHomeBookDetailViewController : RERootViewController

@property (nonatomic, copy) NSString *book_id;
@property (nonatomic, copy) NSString *imageStr;
@end

NS_ASSUME_NONNULL_END
