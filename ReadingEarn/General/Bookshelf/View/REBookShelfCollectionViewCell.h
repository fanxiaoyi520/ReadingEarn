//
//  REBookShelfCollectionViewCell.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/22.
//  Copyright © 2019 FANS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REBookShelfModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^RECellSelectBlock)(UICollectionViewCell *currentCell,UIButton *sender);
@interface REBookShelfCollectionViewCell : UICollectionViewCell


@property (nonatomic ,strong)UIImageView *bookImageView;
@property (nonatomic ,strong)UILabel *bookNameLabel;
@property (nonatomic ,strong)UIButton *cellSelectButton;

@property (nonatomic ,copy)RECellSelectBlock cellSelectBlock;
- (void)showDataWithModel:(REBookShelfModel *)model;
@end

NS_ASSUME_NONNULL_END
