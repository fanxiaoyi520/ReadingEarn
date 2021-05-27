//
//  REBookShelfCollectionReusableView.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/22.
//  Copyright © 2019 FANS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^REManagerBookShelfBlock)(UIButton *sender);
typedef void (^RESelectBlock)(UIButton *sender);
typedef void (^REHeaderDeleteBlock)(UIButton *sender);
typedef void (^RECancelBlock)(UIButton *sender);
@interface REBookShelfCollectionReusableView : UICollectionReusableView

@property (nonatomic ,copy)REManagerBookShelfBlock managerBookShelfBlock;
@property (nonatomic ,copy)RESelectBlock selectBlock;
@property (nonatomic ,copy)REHeaderDeleteBlock headerDeleteBlock;
@property (nonatomic ,copy)RECancelBlock cancelBlock;
- (void)showDataWithModel:(NSMutableArray *)model;
@end

NS_ASSUME_NONNULL_END
