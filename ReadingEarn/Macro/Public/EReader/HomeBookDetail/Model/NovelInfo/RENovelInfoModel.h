//
//  RENovelInfoModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/12/10.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"
#import "REBookInfoModel.h"
#import "REBookListModel.h"
#import "RELikeListModel.h"
#import "RENewInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RENovelInfoModel : RERootModel

@property (nonatomic ,strong)REBookInfoModel *bookInfo;
@property (nonatomic ,strong)REBookListModel *bookListModel;
@property (nonatomic ,strong)NSMutableArray *bookList;
@property (nonatomic ,strong)RELikeListModel *likeListModel;
@property (nonatomic ,strong)NSMutableArray *likeList;
@property (nonatomic ,strong)RENewInfoModel *mynewInfoModel;
@end

NS_ASSUME_NONNULL_END
