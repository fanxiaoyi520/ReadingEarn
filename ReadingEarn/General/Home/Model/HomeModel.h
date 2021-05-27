//
//  HomeModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/15.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"
#import "HomeBannelModel.h"
#import "HomeQuick1Model.h"
#import "HomeQuick2Model.h"
#import "HomeAreaModel.h"
#import "HomeVipModel.h"
#import "HomeWomanTypeModel.h"
#import "HomeIconModel.h"
#import "HomeManModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeModel : RERootModel

@property (nonatomic ,strong)NSArray<HomeBannelModel *> *banner;
@property (nonatomic ,strong)HomeBannelModel *bannerModel;
@property (nonatomic ,strong)NSArray<HomeQuick1Model *> *quick1;
@property (nonatomic ,strong)HomeQuick1Model *quick1Model;
@property (nonatomic ,strong)NSArray<HomeQuick2Model *> *quick2;
@property (nonatomic ,strong)HomeQuick2Model *quick2Model;

@property (nonatomic ,strong)NSArray<HomeVipModel *> *vip;
@property (nonatomic ,strong)HomeVipModel *vipModel;
@property (nonatomic ,strong)NSArray<HomeWomanTypeModel *> *womanType;
@property (nonatomic ,strong)HomeWomanTypeModel *womanTypeModel;
@property (nonatomic ,strong)NSArray<HomeIconModel *> *icon;
@property (nonatomic ,strong)HomeIconModel *iconModel;
@property (nonatomic ,strong)NSArray<HomeManModel *> *manType;
@property (nonatomic ,strong)HomeIconModel *manTypeModel;
//@property (nonatomic ,strong)HomeAreaModel *area;

@end

NS_ASSUME_NONNULL_END
