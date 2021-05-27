//
//  REEndBookTypeView.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/26.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^REBookTypeBlock)(UIButton *sender,id first ,id second);

@interface REEndBookTypeView : RERootView
- (instancetype)initWithFrame:(CGRect)frame withModel:(NSDictionary *)model;
- (void)showBookTypeViewWithModel:(NSDictionary *)model;
@property (nonatomic,copy)REBookTypeBlock bookTypeBlock;

@end

NS_ASSUME_NONNULL_END
