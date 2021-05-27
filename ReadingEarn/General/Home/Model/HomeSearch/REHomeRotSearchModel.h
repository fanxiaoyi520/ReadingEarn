//
//  REHomeRotSearchModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/23.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface REHomeRotSearchModel : RERootModel
//"created_time" = 13213213;
//id = 2;
//status = 2;
//title = "\U7eaf\U7231";
@property (nonatomic ,copy)NSString *created_time;
@property (nonatomic ,copy)NSString *rot_id;
@property (nonatomic ,copy)NSString *status;
@property (nonatomic ,copy)NSString *title;
@end

NS_ASSUME_NONNULL_END
