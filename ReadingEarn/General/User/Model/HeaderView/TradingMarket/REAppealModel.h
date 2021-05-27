//
//  REAppealModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/12/9.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface REAppealModel : RERootModel

@property (nonatomic ,copy)NSString *title;
@property (nonatomic ,copy)NSString *content;
@property (nonatomic ,copy)NSString *picture;
@property (nonatomic ,copy)NSString *mobile;
@property (nonatomic ,copy)NSString *email;
@end

NS_ASSUME_NONNULL_END
