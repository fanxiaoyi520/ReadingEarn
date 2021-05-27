//
//  REWaitingPaySecondTableViewCell.h
//  ReadingEarn
//
//  Created by FANS on 2019/12/6.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootTableViewCell.h"
#import "REWaitingPayModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^REQRCodeBlock)(id msg,NSString *pay_code);
@interface REWaitingPaySecondTableViewCell : RERootTableViewCell

@property (nonatomic ,copy)REQRCodeBlock QRCodeBlock;
- (void)showDataWithModel:(REWaitingPayModel *)model;
@end

NS_ASSUME_NONNULL_END
