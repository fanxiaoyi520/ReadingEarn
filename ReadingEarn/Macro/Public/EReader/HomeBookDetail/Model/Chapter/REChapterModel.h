//
//  REChapterModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/12/11.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface REChapterModel : RERootModel
//book_id: 379
//chapter_name: "第一章 第一章 英雄救美"
//chapter_number: 1
//locked: 0

@property (nonatomic ,copy)NSString *book_id;
@property (nonatomic ,copy)NSString *chapter_name;
@property (nonatomic ,copy)NSString *chapter_number;
@property (nonatomic ,copy)NSString *locked;
@end

NS_ASSUME_NONNULL_END
