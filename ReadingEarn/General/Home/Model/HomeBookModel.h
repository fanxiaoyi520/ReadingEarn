//
//  HomeBookModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/15.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeBookModel : RERootModel

@property (nonatomic ,copy)NSString *home_id;
@property (nonatomic ,copy)NSString *coverpic;
@property (nonatomic ,copy)NSString *label;
@property (nonatomic ,copy)NSString *coverpic_1;
@property (nonatomic ,copy)NSString *sex;
@property (nonatomic ,copy)NSString *isover;
@property (nonatomic ,copy)NSString *nid;
@property (nonatomic ,copy)NSString *charge_type;
@property (nonatomic ,copy)NSString *title;
@property (nonatomic ,copy)NSString *word_number_total;
@property (nonatomic ,copy)NSString *contents;
@property (nonatomic ,copy)NSString *grade;
@property (nonatomic ,copy)NSString *status;
@property (nonatomic ,copy)NSString *now_word_number;

@end

NS_ASSUME_NONNULL_END
