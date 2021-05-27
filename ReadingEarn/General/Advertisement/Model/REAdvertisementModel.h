//
//  REAdvertisementModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/12/23.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface REAdvertisementModel : RERootModel
//"create_time" = 1577168340;
//id = 2;
//introduce = "\U5357\U6749\U59d1\U5a18";
//"jitter_name" = nanshan1208;
//link = "https://v.douyin.com/4qfn2K/";
//name = "\U5357\U6749\U59d1\U5a18";
//photo = "http://images.xiaocao4.cn/2019122414323789487.jpg";
//picture = "http://images.xiaocao4.cn/2019122414322991216.jpg";
//video = "http://images.xiaocao4.cn/2019122411193436143.mp4";

@property (nonatomic ,copy)NSString *create_time;
@property (nonatomic ,copy)NSString *ad_id;
@property (nonatomic ,copy)NSString *introduce;
@property (nonatomic ,copy)NSString *jitter_name;
@property (nonatomic ,copy)NSString *link;
@property (nonatomic ,copy)NSString *name;
@property (nonatomic ,copy)NSString *photo;
@property (nonatomic ,copy)NSString *picture;
@property (nonatomic ,copy)NSString *video;
@end

NS_ASSUME_NONNULL_END
