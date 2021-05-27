//
//  REBookInfoTerritoryModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/12/10.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface REBookInfoTerritoryModel : RERootModel
//"attribute_name" = "\U67b6\U7a7a";
//    id = 24;
//    status = 1;
@property (nonatomic ,copy)NSString *attribute_name;
@property (nonatomic ,copy)NSString *territory_id;
@property (nonatomic ,copy)NSString *status;

@end

NS_ASSUME_NONNULL_END
