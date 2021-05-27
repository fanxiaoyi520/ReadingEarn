//
//  REEndBookNameModel.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/26.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootModel.h"
#import "REHomeEndModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface REEndBookNameModel : RERootModel
@property (nonatomic ,strong)REHomeEndModel *homeEndModel;
@property (nonatomic ,strong)NSMutableArray *book;
@property (nonatomic ,copy)NSString *name;
@end

NS_ASSUME_NONNULL_END
