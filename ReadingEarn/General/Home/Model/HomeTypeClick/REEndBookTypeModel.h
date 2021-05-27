//
//  REEndBookTypeModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/26.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface REEndBookTypeModel : RERootModel

@property (nonatomic ,copy)NSString *charge_type;
@property (nonatomic ,copy)NSString *contents;
@property (nonatomic ,copy)NSString *coverpic;
@property (nonatomic ,copy)NSString *coverpic_1;
@property (nonatomic ,copy)NSString *grade;
@property (nonatomic ,copy)NSString *class_id;
@property (nonatomic ,copy)NSString *isover;
@property (nonatomic ,copy)NSString *label;
@property (nonatomic ,copy)NSString *labels;
@property (nonatomic ,copy)NSString *nid;
@property (nonatomic ,copy)NSString *sex;
@property (nonatomic ,copy)NSString *status;
@property (nonatomic ,copy)NSString *territory;
@property (nonatomic ,copy)NSString *title;

@end

NS_ASSUME_NONNULL_END
