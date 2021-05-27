//
//  REBookShelfModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/22.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface REBookShelfModel : RERootModel
//"book_id" = 38;
//coverpic = "http://images.xiaocao4.cn/9a23ba4bc103c716d48473a440c8fe43.png";
//"create_time" = 1574403187;
//id = 4;
//"mch_id" = 3;
//status = 1;
//title = "\U9ed1\U6697\U5723\U5973";
//"update_time" = 0;
//"user_id" = 807079;
@property (nonatomic ,copy)NSString *book_id;
@property (nonatomic ,copy)NSString *coverpic;
@property (nonatomic ,copy)NSString *create_time;
@property (nonatomic ,copy)NSString *bookShelf_id;
@property (nonatomic ,copy)NSString *mch_id;
@property (nonatomic ,copy)NSString *status;
@property (nonatomic ,copy)NSString *title;
@property (nonatomic ,copy)NSString *update_time;
@property (nonatomic ,copy)NSString *user_id;
@property (nonatomic ,copy)NSString *cellButton_status;
@end

NS_ASSUME_NONNULL_END
