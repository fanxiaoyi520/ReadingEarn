//
//  HomeVipModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/15.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeVipModel : RERootModel

//contents = "\U6211\U53ea\U662f\U4e2a\U5c4c\U4e1d\Uff0c\U90a3\U5929\U665a\U4e0a\U6211\U6361\U4e86\U4e00\U4e2a\U7edd\U8272\U767d\U5bcc\U7f8e\Uff0c\U800c\U4e14\Uff0c\U5979\U975e\U8981\U505a\U6211\U8001\U5a46\Uff01";
//coverpic = "http://demo.xuncangji.com/4d12f8ff44187b9347f3c98bb717b89c.png";
//"coverpic_1" = "http://demo.xuncangji.com/";
//grade = 96;
//id = 47;
//nid = 482b31eee22486b99cdbe0ab36e959fd;
//title = "\U6211\U7684\U5927\U5c0f\U59d0\U8001\U5a46";

@property (nonatomic ,copy)NSString *contents;
@property (nonatomic ,copy)NSString *coverpic;
@property (nonatomic ,copy)NSString *coverpic_1;
@property (nonatomic ,copy)NSString *grade;
@property (nonatomic ,copy)NSString *home_id;
@property (nonatomic ,copy)NSString *nid;
@property (nonatomic ,copy)NSString *title;
@end

NS_ASSUME_NONNULL_END
