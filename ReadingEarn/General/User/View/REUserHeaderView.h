//
//  REUserHeaderView.h
//  ReadingEarn
//
//  Created by FANS on 2019/11/18.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RERootView.h"
#import "REUserModel.h"
#import "REUseWalletModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^REToSignInBlock)(UIButton *sender);
typedef void (^REFunctionBlock)(UIButton *sender);
typedef void (^REGenerateWalletBlock)(UIButton *sender);

typedef void (^REWalletFunctionBlock)(UIButton *sender);
@interface REUserHeaderView : RERootView

- (void)showUserHeaderModel:(REUserModel *)model withWalletModel:(nonnull REUseWalletModel *)walletModel auditStatusStr:(nonnull NSString *)auditStatusStr is_TransferAccountsShowStr:(NSString *)is_TransferAccountsShowStr;

@property (nonatomic ,copy)REToSignInBlock toSignInBlock;
@property (nonatomic ,copy)REFunctionBlock functionBlock;
@property (nonatomic ,copy)REGenerateWalletBlock generateWalletBlock;
@property (nonatomic ,copy)REWalletFunctionBlock walletFunctionBlock;
@end

NS_ASSUME_NONNULL_END
