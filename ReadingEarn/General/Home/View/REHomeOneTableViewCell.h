//
//  REHomeOneTableViewCell.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/17.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootTableViewCell.h"
#import "HomeModel.h"
#import "HomeBannelModel.h"
#import "HomeIconModel.h"
#import "HomeQuick1Model.h"
#import "REHistoryBackModel.h"
#import "REReadHistoryModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^RESearchBlock)(UIButton *sender);
typedef void (^RETypeClickBlock)(UIButton *sender);
typedef void (^REReadHistoryBlock)(UIButton *sender);
typedef void (^RERotAndNewBlock)(id sender);
typedef void (^RELiveBroadcastBlock)(id sender);
@interface REHomeOneTableViewCell : RERootTableViewCell

@property (nonatomic ,copy)RESearchBlock searchBlock;
@property (nonatomic ,copy)RETypeClickBlock typeClickBlock;
@property (nonatomic ,copy)REReadHistoryBlock readHistoryBlock;
@property (nonatomic ,copy)RERotAndNewBlock rotAndNewBlock;
@property (nonatomic ,copy)RELiveBroadcastBlock liveBroadcastBlock;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withModel:(HomeModel *)model;
- (void)showDataWithModel:(HomeModel *)model withHistoryModel:(REHistoryBackModel *)historyModel withReadHistoryModel:(REReadHistoryModel *)readHistoryModel;
@end

NS_ASSUME_NONNULL_END
