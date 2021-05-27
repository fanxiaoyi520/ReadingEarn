//
//  RESystemBulletioModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/28.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RESystemBulletioModel : RERootModel

@property (nonatomic ,copy)NSString *addTime;
@property (nonatomic ,copy)NSString *contents;
@property (nonatomic ,copy)NSString *system_id;
@property (nonatomic ,copy)NSString *title;
@property (nonatomic ,copy)NSString *titleshort;
@property (nonatomic ,copy)NSString *updateTime;

@end

NS_ASSUME_NONNULL_END
