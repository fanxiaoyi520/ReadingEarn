//
//  REBookInfoModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/12/10.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"
#import "REBookInfoTerritoryModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface REBookInfoModel : RERootModel
//contents = "";
//coverpic = "http://images.xiaocao4.cn/9a23ba4bc103c716d48473a440c8fe43.png";
//"coverpic_1" = "";
//grade = 97;
//id = 38;
//infopic = "";
//"is_collect" = 0;
//label = "24,48";
@property (nonatomic ,copy)NSString *contents;
@property (nonatomic ,copy)NSString *coverpic;
@property (nonatomic ,copy)NSString *coverpic_1;
@property (nonatomic ,copy)NSString *grade;
@property (nonatomic ,copy)NSString *info_id;
@property (nonatomic ,copy)NSString *infopic;
@property (nonatomic ,copy)NSString *is_collect;
@property (nonatomic ,copy)NSString *label;
@property (nonatomic ,copy)NSString *title;
@property (nonatomic ,strong)REBookInfoTerritoryModel *bookInfoTerritoryModel;
@property (nonatomic ,strong)NSMutableArray *territory;
@end

NS_ASSUME_NONNULL_END
