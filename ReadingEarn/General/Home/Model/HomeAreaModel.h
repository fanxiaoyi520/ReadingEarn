//
//  HomeAreaModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/15.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"
#import "HomeBookModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HomeAreaModel : RERootModel

@property (nonatomic ,copy)NSString *name;
@property (nonatomic ,copy)HomeBookModel *bookModel;
@property (nonatomic ,copy)NSArray *book;
@end

NS_ASSUME_NONNULL_END
