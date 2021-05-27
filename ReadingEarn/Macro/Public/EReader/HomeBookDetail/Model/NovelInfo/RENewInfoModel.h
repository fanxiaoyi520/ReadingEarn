//
//  RENewInfoModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/12/10.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RENewInfoModel : RERootModel
//"chapter_name" = "\n\U7b2c1310\U7ae0\U79c0\U4e86\U4e00\U56de\U6069\U7231";
//"chapter_number" = 1310;
//"create_time" = "2019-10-23 13:53:43";
//id = 25473;

@property (nonatomic ,copy)NSString *chapter_name;
@property (nonatomic ,copy)NSString *chapter_number;
@property (nonatomic ,copy)NSString *create_time;
@property (nonatomic ,copy)NSString *newinfo_id;
@end

NS_ASSUME_NONNULL_END
