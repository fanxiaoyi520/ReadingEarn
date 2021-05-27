//
//  REHomeTypeStatusModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/26.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface REHomeTypeStatusModel : RERootModel
@property (nonatomic, copy)NSString *status_id;
@property (nonatomic, copy)NSString *status;
@property (nonatomic, copy)NSString *attribute_name;
@end

NS_ASSUME_NONNULL_END
