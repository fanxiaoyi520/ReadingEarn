//
//  REBookListModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/12/10.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface REBookListModel : RERootModel

//"book_id" = 38;
//"chapter_name" = "\n\U7b2c1\U7ae0\U8981\U4e86\U6211";
//"chapter_number" = 1;
//id = 7;
//locked = 0;
@property (nonatomic ,copy)NSString *book_id;
@property (nonatomic ,copy)NSString *chapter_name;
@property (nonatomic ,copy)NSString *chapter_number;
@property (nonatomic ,copy)NSString *booklist_id;
@property (nonatomic ,copy)NSString *locked;

@end

NS_ASSUME_NONNULL_END
