//
//  ZDPay_OrderSureFooterView.h
//  ReadingEarn
//
//  Created by FANS on 2020/4/14.
//  Copyright © 2020 FANS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZDPay_OrderSureRespModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^SurePay)(UIButton *sender);
@interface ZDPay_OrderSureFooterView : UITableViewHeaderFooterView

@property (nonatomic ,copy)SurePay surePay;
- (void)layoutAndLoadData:(ZDPay_OrderSureRespModel *)model
                  surePay:(void(^)(UIButton *sender))surePay;
@end

NS_ASSUME_NONNULL_END
