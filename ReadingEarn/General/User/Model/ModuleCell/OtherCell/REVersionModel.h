//
//  REVersionModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/28.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"

NS_ASSUME_NONNULL_BEGIN
//        "an_link_name" = "http://images.xiaocao4.cn/2019112112061873502.apk";
//        "edition_name" = "1.0.3";
//ios_code
@interface REVersionModel : RERootModel
@property (nonatomic ,copy)NSString *an_link_name;
@property (nonatomic ,copy)NSString *edition_name;
@property (nonatomic ,copy)NSString *ios_code;

@end

NS_ASSUME_NONNULL_END
