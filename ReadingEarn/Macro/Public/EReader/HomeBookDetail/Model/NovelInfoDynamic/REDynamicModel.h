//
//  REDynamicModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/12/10.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"
#import "REGraInfoModel.h"
#import "RECommentsModel.h"
#import "REGraTypeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface REDynamicModel : RERootModel
@property (nonatomic ,strong)RECommentsModel *comments;
@property (nonatomic ,strong)REGraInfoModel *graInfoModel;
@property (nonatomic ,strong)NSMutableArray *graInfo;
@property (nonatomic ,copy)NSString *graTotal;
@property (nonatomic ,strong)REGraTypeModel *graTypeModel;
@property (nonatomic ,strong)NSMutableArray *graType;
@end

NS_ASSUME_NONNULL_END
