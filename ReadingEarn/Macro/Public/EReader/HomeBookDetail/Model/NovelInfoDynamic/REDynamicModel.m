//
//  REDynamicModel.m
//  ReadingEarn
//
//  Created by FANS on 2019/12/10.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REDynamicModel.h"

@implementation REDynamicModel
+(NSDictionary *)mj_objectClassInArray {
    return @{
        @"graInfo":@"REGraInfoModel",
        @"graType":@"REGraTypeModel",
    };
}
@end
