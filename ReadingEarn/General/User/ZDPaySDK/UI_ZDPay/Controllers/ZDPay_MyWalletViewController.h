//
//  ZDPay_MyWalletViewController.h
//  ReadingEarn
//
//  Created by FANS on 2020/4/16.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPayRootViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef enum _WalletType {
    WalletType_Untying = 0,
    WalletType_binding  = 1,
}WalletType;

@interface ZDPay_MyWalletViewController : ZDPayRootViewController

@property (nonatomic ,strong)NSArray *bankDataList;
@property (nonatomic ,assign)WalletType walletType;
@end

NS_ASSUME_NONNULL_END
