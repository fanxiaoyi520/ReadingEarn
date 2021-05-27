//
//  REPlayRewardModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/12/11.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface REPlayRewardModel : RERootModel
//"create_time" = 1576055756;
//email = "";
//headimg = "";
//id = 185;
//mobile = "153**77";
//money = "200.00";
//nickname = "";
//sons = "<null>";
//title =

@property (nonatomic ,copy)NSString *create_time;
@property (nonatomic ,copy)NSString *email;
@property (nonatomic ,copy)NSString *headimg;
@property (nonatomic ,copy)NSString *playreward_id;
@property (nonatomic ,copy)NSString *mobile;
@property (nonatomic ,copy)NSString *money;
@property (nonatomic ,copy)NSString *nickname;
@property (nonatomic ,copy)NSString *sons;
@property (nonatomic ,copy)NSString *title;

@end

NS_ASSUME_NONNULL_END
