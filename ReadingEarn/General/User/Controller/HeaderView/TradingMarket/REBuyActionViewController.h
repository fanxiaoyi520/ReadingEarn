//
//  REBuyActionViewController.h
//  ReadingEarn
//
//  Created by FANS on 2019/12/5.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootViewController.h"
#import "REBuyCoinsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface REBuyActionViewController : RERootViewController

@property (nonatomic ,copy)NSString *type;
@property (nonatomic ,strong)REBuyCoinsModel *buyCoinsModel;
@end

NS_ASSUME_NONNULL_END
