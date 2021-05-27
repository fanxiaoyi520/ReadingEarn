//
//  REOrderDetailsViewController.h
//  ReadingEarn
//
//  Created by FANS on 2019/12/6.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootViewController.h"
#import "REMyOrderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface REOrderDetailsViewController : RERootViewController

@property (nonatomic, strong)REMyOrderModel *myOrderModel;
@property (nonatomic, copy)NSString *type;
@end

NS_ASSUME_NONNULL_END
