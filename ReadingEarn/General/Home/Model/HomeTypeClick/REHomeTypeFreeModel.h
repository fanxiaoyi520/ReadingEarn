//
//  REHomeTypeFreeModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/26.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface REHomeTypeFreeModel : RERootModel
//{
//    "charge_type" = 2;
//    contents = "21\U4e16\U7eaa\U6700\U7545\U9500\U4e66\U7c4d\Uff0c\U5f00\U542f\U4e86\U9b54\U6cd5\U65f6\U4ee3\U3002\U3002\U3002";
//    coverpic = "http://upload.gxdcsm.com/41fca8ebab736bff89479c5ef9577391.png";
//    "coverpic_1" = "41fca8ebab736bff89479c5ef9577391.png";
//    hots = 81;
//    id = 3824;
//    likes = 97;
//    nid = 4b12d1170b1c520116d2b7987dd47140;
//    status = 1;
//    title = "\U54c8\U5229\U6ce2\U7279\U4e0e\U9b54\U6cd5\U77f3";
//}
@property (nonatomic ,copy)NSString *charge_type;
@property (nonatomic ,copy)NSString *contents;
@property (nonatomic ,copy)NSString *coverpic;
@property (nonatomic ,copy)NSString *coverpic_1;
@property (nonatomic ,copy)NSString *hots;
@property (nonatomic ,copy)NSString *free_id;
@property (nonatomic ,copy)NSString *likes;
@property (nonatomic ,copy)NSString *nid;
@property (nonatomic ,copy)NSString *status;
@property (nonatomic ,copy)NSString *title;

@end

NS_ASSUME_NONNULL_END
