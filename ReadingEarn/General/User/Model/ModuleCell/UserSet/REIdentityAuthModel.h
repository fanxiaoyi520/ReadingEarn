//
//  REIdentityAuthModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/12/12.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface REIdentityAuthModel : RERootModel
//real_name: 1
//id_card: 1
//front_pic: 2019121216312963724.jpg
//negative_pic: 2019121216313689313.jpg
@property (nonatomic ,copy)NSString *real_name;
@property (nonatomic ,copy)NSString *id_card;
@property (nonatomic ,copy)NSString *front_pic;
@property (nonatomic ,copy)NSString *negative_pic;
@end

NS_ASSUME_NONNULL_END
