//
//  REGraTypeModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/12/10.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface REGraTypeModel : RERootModel
//"create_time" = 1571906953;
//id = 5;
//money = 100;
//pic = "http://images.xiaocao4.cn/2019102510065742646.jpg";
//status = 1;
@property (nonatomic ,copy)NSString *create_time;
@property (nonatomic ,copy)NSString *grainfo_id;
@property (nonatomic ,copy)NSString *money;
@property (nonatomic ,copy)NSString *pic;
@property (nonatomic ,copy)NSString *status;
@end

NS_ASSUME_NONNULL_END
