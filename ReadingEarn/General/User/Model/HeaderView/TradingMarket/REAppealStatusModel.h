//
//  REAppealStatusModel.h
//  ReadingEarn
//
//  Created by FANS on 2020/1/1.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "RERootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface REAppealStatusModel : RERootModel
//"status" : "2",
//"order_id" : "1",
//"user_id" : "802874",
//"ordid" : "22010631225871198678"
@property (nonatomic ,copy)NSString *status;
@property (nonatomic ,copy)NSString *order_id;
@property (nonatomic ,copy)NSString *user_id;
@property (nonatomic ,copy)NSString *ordid;

@end

NS_ASSUME_NONNULL_END
