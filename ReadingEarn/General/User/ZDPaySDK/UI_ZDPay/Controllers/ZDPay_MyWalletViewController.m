//
//  ZDPay_MyWalletViewController.m
//  ReadingEarn
//
//  Created by FANS on 2020/4/16.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPay_MyWalletViewController.h"
#import "ZDPayFuncTool.h"
#import "ZDPay_MywalletTableViewCell.h"
#import "ZDPay_AddBankCardViewController.h"
#import "ZDPay_OrderSureBankListRespModel.h"
@interface ZDPay_MyWalletViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong)UITableView *myWalletTableView;
@property (nonatomic ,copy)NSString *untyingStr;
@property (nonatomic ,copy)NSString *bindingStr;
@end

@implementation ZDPay_MyWalletViewController

- (void)viewDidLoad {
    self.naviTitle = @"我的钱包";
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.topNavBar setNavAndStatusBarColor:COLORWITHHEXSTRING(@"#FFFFFF", 1.0)];

    if (self.walletType == WalletType_Untying) {
        self.untyingStr = @"解绑";
        self.bindingStr = nil;
    } else {
        self.bindingStr = @"icon_add";
        self.untyingStr = nil;
    }
    
    @WeakObj(self)
    [self.topNavBar addBankCardBTnTitle:self.untyingStr btnImage:self.bindingStr BankJumpBlock:^(UIButton * _Nonnull sender) {
        @StrongObj(self)
        if (self.walletType == WalletType_Untying) {
            NSLog(@"解绑");
        } else {
            ZDPay_AddBankCardViewController *vc = [ZDPay_AddBankCardViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    self.view.backgroundColor = COLORWITHHEXSTRING(@"#F3F3F5", 1.0);
    [self myWalletTableView];
}

#pragma mark - lazy loading
- (UITableView *)myWalletTableView {
    if (!_myWalletTableView) {
        _myWalletTableView = [[UITableView alloc] initWithFrame:CGRectMake(ratioW(16), mcNavBarAndStatusBarHeight, ScreenWidth-ratioW(32), ScreenHeight-mcNavBarAndStatusBarHeight) style:UITableViewStylePlain];
        _myWalletTableView.delegate = self;
        _myWalletTableView.dataSource = self;
        _myWalletTableView.backgroundView = nil;
        _myWalletTableView.backgroundColor = [UIColor clearColor];
        _myWalletTableView.showsVerticalScrollIndicator = NO;
        _myWalletTableView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_myWalletTableView];
    }
    return _myWalletTableView;
}

#pragma mark - delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.walletType == WalletType_Untying) {
        return 1;
    } else {
        return self.bankDataList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellid = @"cellid";
    ZDPay_MywalletTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (!cell) {
        cell = [[ZDPay_MywalletTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundView = nil;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    [cell layoutAndLoadData:nil];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ratioH(122);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.walletType == WalletType_Untying) {
        NSLog(@"解绑");
    } else {
        ZDPay_MyWalletViewController *vc = [ZDPay_MyWalletViewController new];
        vc.walletType = WalletType_Untying;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
