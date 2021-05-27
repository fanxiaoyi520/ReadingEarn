//
//  RELikeListModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/12/10.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RELikeListModel : RERootModel
//author = "";
//"book_id" = 3347;
//cateids = 25;
//contents =
//coverpic = "http://images.xiaocao4.cn/ddc9165f39f2f948735bebaa866cffbd.png";
//grade = 35;
//id = 3347;
//status = 1;
//title = "\U730e\U7231\U5e05\U603b\U88c1";
//"word_number_total" = 0;
@property (nonatomic ,copy)NSString *author;
@property (nonatomic ,copy)NSString *book_id;
@property (nonatomic ,copy)NSString *cateids;
@property (nonatomic ,copy)NSString *contents;
@property (nonatomic ,copy)NSString *coverpic;
@property (nonatomic ,copy)NSString *grade;
@property (nonatomic ,copy)NSString *like_id;
@property (nonatomic ,copy)NSString *status;
@property (nonatomic ,copy)NSString *title;
@property (nonatomic ,copy)NSString *word_number_total;


@end

NS_ASSUME_NONNULL_END
