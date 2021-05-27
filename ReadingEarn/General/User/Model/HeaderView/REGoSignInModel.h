//
//  REGoSignInModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/29.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"
#import "REGoSignInDayModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface REGoSignInModel : RERootModel

@property (nonatomic ,strong)REGoSignInDayModel *zero_model;
@property (nonatomic ,copy)NSString *log;
@property (nonatomic ,copy)NSString *rank;
@end

NS_ASSUME_NONNULL_END
