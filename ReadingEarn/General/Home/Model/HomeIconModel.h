//
//  HomeIconModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/15.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeIconModel : RERootModel
//"ad_code" = "http://demo.xuncangji.com/2019102817442886137.jpg";
//"ad_link" = wanjie;
//"ad_name" = "\U5b8c\U7ed3";
//bgcolor = "";
//"channel_nid" = other;
//"click_count" = 0;
//enabled = 1;
//"end_time" = "-28800";
//id = 91;
//"link_email" = "";
//"link_man" = "";
//"link_phone" = "";
//"media_type" = 0;
//pid = 1622;
//remark = "";
//sort = 0;
//"start_time" = "-28800";
//target = 1;
//towpic = "<null>";
@property (nonatomic ,copy)NSString *ad_code;
@property (nonatomic ,copy)NSString *ad_link;
@property (nonatomic ,copy)NSString *ad_name;
@property (nonatomic ,copy)NSString *bgcolor;
@property (nonatomic ,copy)NSString *channel_nid;
@property (nonatomic ,copy)NSString *click_count;
@property (nonatomic ,copy)NSString *enabled;
@property (nonatomic ,copy)NSString *end_time;
@property (nonatomic ,copy)NSString *home_id;
@property (nonatomic ,copy)NSString *link_email;
@property (nonatomic ,copy)NSString *link_man;
@property (nonatomic ,copy)NSString *link_phone;
@property (nonatomic ,copy)NSString *media_type;
@property (nonatomic ,copy)NSString *pid;
@property (nonatomic ,copy)NSString *remark;
@property (nonatomic ,copy)NSString *sort;
@property (nonatomic ,copy)NSString *start_time;
@property (nonatomic ,copy)NSString *target;
@property (nonatomic ,copy)NSString *towpic;

@end

NS_ASSUME_NONNULL_END
