//
//  REGraInfoModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/12/10.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface REGraInfoModel : RERootModel
//"create_time" = 1571906953;
//id = 5;
//money = 100;
//pic = "http://images.xiaocao4.cn/2019102510065742646.jpg";
//status = 1;

//"create_time" = 1574440341;
//email = "";
//headimg = "";
//id = 166;
//mobile = "183**20";
//money = 168;
//nickname = "";
//title =
@property (nonatomic ,copy)NSString *create_time;
@property (nonatomic ,copy)NSString *email;
@property (nonatomic ,copy)NSString *headimg;
@property (nonatomic ,copy)NSString *grainfo_id;
@property (nonatomic ,copy)NSString *mobile;
@property (nonatomic ,copy)NSString *money;
@property (nonatomic ,copy)NSString *nickname;
@property (nonatomic ,copy)NSString *title;
@end

NS_ASSUME_NONNULL_END
