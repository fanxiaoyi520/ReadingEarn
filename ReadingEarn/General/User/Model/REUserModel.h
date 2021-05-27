//
//  REUserModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/27.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"
#import "REVersionModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface REUserModel : RERootModel
//    edition =         {
//        "an_link_name" = "http://images.xiaocao4.cn/2019112112061873502.apk";
//        "edition_name" = "1.0.3";
//    };
@property (nonatomic ,copy)NSString *YC;
@property (nonatomic ,copy)NSString *YDC;
@property (nonatomic ,copy)NSString *active;
@property (nonatomic ,copy)NSString *currency_reading;
@property (nonatomic ,strong)REVersionModel *edition;
@property (nonatomic ,copy)NSString *headimg;
@property (nonatomic ,copy)NSString *nickname;
@property (nonatomic ,copy)NSString *public_logo;
@property (nonatomic ,copy)NSString *sign_status;
@property (nonatomic ,copy)NSString *team;
@property (nonatomic ,copy)NSString *term;
@property (nonatomic ,copy)NSString *total_profit;
@property (nonatomic ,copy)NSString *tuijian;
@property (nonatomic ,copy)NSString *vip;
@property (nonatomic ,copy)NSString *vip_icon;
@property (nonatomic ,copy)NSString *vip_rank;

@end

NS_ASSUME_NONNULL_END
