//
//  REUseWalletModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/27.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"
#import "REYESWalletModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface REUseWalletModel : RERootModel

@property (nonatomic ,strong)REYESWalletModel *data;
@property (nonatomic ,copy)NSString *logo;
@end

NS_ASSUME_NONNULL_END
