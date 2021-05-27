//
//  REWaitingPaymentViewController.m
//  ReadingEarn
//
//  Created by FANS on 2019/12/6.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REWaitingPaymentViewController.h"
#import "REWaitingPaySecondTableViewCell.h"
#import "REWaitingPayOneTableViewCell.h"
#import "REWaitingPayModel.h"
#import "REWaitingPayHeaderView.h"
#import "REWaitingPayFooterView.h"
#import "REAppealViewController.h"
#import "REAppealStatusModel.h"

@interface REWaitingPaymentViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) DefaultServerRequest *requestA;
@property (nonatomic, strong) DefaultServerRequest *requestB;
@property (nonatomic, strong) DefaultServerRequest *requestC;
@property (nonatomic, strong) DefaultServerRequest *requestD;
@property (nonatomic, strong) DefaultServerRequest *requestE;
@property (nonatomic, strong) UITableView *waitingPayTableView;
@property (nonatomic, strong) REWaitingPayModel *waitingPayModel;
@property (nonatomic, strong) REWaitingPayHeaderView *headerView;
@property (nonatomic, strong) REWaitingPayFooterView *footerView;
@property (nonatomic, strong)REReadingEarnPopupView *popView;
@property (nonatomic, copy)NSString *paypwd;
@property (nonatomic, strong)REAppealStatusModel *appealStatusModel;
@end

@implementation REWaitingPaymentViewController
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = REBackColor;
    [self re_loadUI];
    [self requestNetwork];
}

#pragma mark - 网络请求--------买卖
- (void)requestNetwork {

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestA startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
        })
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestA = nil;
        NSString *code = [NSString stringWithFormat:@"%@",response.responseObject[@"code"]];
        NSString *msg = [NSString stringWithFormat:@"%@",response.responseObject[@"msg"]];

        if ([code isEqualToString:@"1"]) {
            REWaitingPayModel *model = [REWaitingPayModel mj_objectWithKeyValues:response.responseObject[@"data"]];
            self.waitingPayModel = model;
            self.type = self.waitingPayModel.status;
            
            [self requestNetworkWithAppeal];
        } else {
            [self showAlertMsg:msg Duration:2];
        }
    } failure:^(YCNetworkResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestA = nil;
    }];
}

- (DefaultServerRequest *)requestA {
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    if (!_requestA) {
        _requestA = [[DefaultServerRequest alloc] init];
        _requestA.requestMethod = YCRequestMethodPOST;
        _requestA.requestURI = [NSString stringWithFormat:@"%@/otc/order_info",HomePageDomainName];
        _requestA.requestParameter = @{
                                       @"token":token,
                                       @"id":self.myOrderModel.order_id,
                                      };
    }
    return _requestA;
}

#pragma mark - 网络请求--------确认付款
- (void)requestNetworkPay {

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestB startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
        })
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestB = nil;
        NSString *code = [NSString stringWithFormat:@"%@",response.responseObject[@"code"]];
        NSString *msg = [NSString stringWithFormat:@"%@",response.responseObject[@"msg"]];

        if ([code isEqualToString:@"1"]) {
            [self.popView closeThePopupView];
            [self showAlertMsg:msg Duration:2];
            
            
            [self requestNetwork];
        } else {
            [self showAlertMsg:msg Duration:2];
        }
    } failure:^(YCNetworkResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestB = nil;
    }];
}

- (DefaultServerRequest *)requestB {
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    if (!_requestB) {
        _requestB = [[DefaultServerRequest alloc] init];
        _requestB.requestMethod = YCRequestMethodPOST;
        _requestB.requestURI = [NSString stringWithFormat:@"%@/otc/confirm_order",HomePageDomainName];
        _requestB.requestParameter = @{
                                       @"token":token,
                                       @"order_id":self.waitingPayModel.pay_id,
                                       @"payword":self.paypwd
                                      };
    }
    return _requestB;
}

#pragma mark - 网络请求--------取消订单
- (void)requestNetworkCanclePay {

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestC startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
        })
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestC = nil;
        NSString *code = [NSString stringWithFormat:@"%@",response.responseObject[@"code"]];
        NSString *msg = [NSString stringWithFormat:@"%@",response.responseObject[@"msg"]];

        if ([code isEqualToString:@"1"]) {
            [self showAlertMsg:msg Duration:2];
            [self.popView closeThePopupView];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self showAlertMsg:msg Duration:2];
        }
    } failure:^(YCNetworkResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestC = nil;
    }];
}

- (DefaultServerRequest *)requestC {
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    if (!_requestC) {
        _requestC = [[DefaultServerRequest alloc] init];
        _requestC.requestMethod = YCRequestMethodPOST;
        _requestC.requestURI = [NSString stringWithFormat:@"%@/otc/cancel_order",HomePageDomainName];
        _requestC.requestParameter = @{
                                       @"token":token,
                                       @"order_id":self.waitingPayModel.pay_id,
                                       @"payword":self.paypwd
                                      };
    }
    return _requestC;
}

#pragma mark - 网络请求--------放币
- (void)requestNetworkCoinRelease {

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestD startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
        })
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestD = nil;
        NSString *code = [NSString stringWithFormat:@"%@",response.responseObject[@"code"]];
        NSString *msg = [NSString stringWithFormat:@"%@",response.responseObject[@"msg"]];

        if ([code isEqualToString:@"1"]) {
            [self showAlertMsg:msg Duration:2];
            [self.popView closeThePopupView];
            [self requestNetwork];
            //[self.navigationController popViewControllerAnimated:YES];
        } else {
            [self showAlertMsg:msg Duration:2];
        }
    } failure:^(YCNetworkResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestD = nil;
    }];
}

- (DefaultServerRequest *)requestD {
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    if (!_requestD) {
        _requestD = [[DefaultServerRequest alloc] init];
        _requestD.requestMethod = YCRequestMethodPOST;
        _requestD.requestURI = [NSString stringWithFormat:@"%@/otc/release",HomePageDomainName];
        _requestD.requestParameter = @{
                                       @"token":token,
                                       @"order_id":self.waitingPayModel.pay_id,
                                       @"payword":self.paypwd
                                      };
    }
    return _requestD;
}

#pragma mark - 网络请求--------申诉状态
- (void)requestNetworkWithAppeal {
    [self.requestE startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
        })
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestE = nil;
        NSString *code = [NSString stringWithFormat:@"%@",response.responseObject[@"code"]];
        NSString *msg = [NSString stringWithFormat:@"%@",response.responseObject[@"msg"]];
        if ([code isEqualToString:@"0"]) {
            //请求失败
            [self showAlertMsg:msg Duration:2];
        } else if ([code isEqualToString:@"1"]) {
            REAppealStatusModel *model = [REAppealStatusModel mj_objectWithKeyValues:response.responseObject[@"data"]];
            self.appealStatusModel = model;
            
            [self.waitingPayTableView reloadData];
        }
    } failure:^(YCNetworkResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestE = nil;
    }];
}

- (DefaultServerRequest *)requestE {
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    if (!_requestE) {
        _requestE = [[DefaultServerRequest alloc] init];
        _requestE.requestMethod = YCRequestMethodPOST;
        _requestE.requestURI = [NSString stringWithFormat:@"%@/otc/appeal_status",HomePageDomainName];
        _requestE.requestParameter = @{
                                       @"token":token,
                                       @"ordid":self.waitingPayModel.ordid,
                                      };
        NSLog(@"_requestB.requestParameter:%@",_requestB.requestParameter);
    }
    return _requestE;
}


#pragma mark - 加载UI
- (void)re_loadUI {
    [self waitingPayTableView];
    
    if ([self.type isEqualToString:@"1"]) {
        REWaitingPayHeaderView *headerView = [[REWaitingPayHeaderView alloc] initWithFrame:CGRectMake(0, 0, REScreenWidth, 50)];
        self.waitingPayTableView.tableHeaderView = headerView;
        self.headerView = headerView;
    }
    
    REWaitingPayFooterView *footerView = [[REWaitingPayFooterView alloc] initWithFrame:CGRectMake(0, 0, REScreenWidth, REScreenHeight-197-179-32-50-NavHeight) withType:self.type];
    self.waitingPayTableView.tableFooterView = footerView;
    self.footerView = footerView;
}

- (UITableView *)waitingPayTableView {
    if (!_waitingPayTableView) {
        _waitingPayTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, REScreenWidth, REScreenHeight-NavHeight) style:UITableViewStylePlain];
        _waitingPayTableView.delegate = self;
        _waitingPayTableView.scrollEnabled = NO;
        _waitingPayTableView.dataSource = self;
        _waitingPayTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _waitingPayTableView.backgroundColor = [UIColor clearColor];
        _waitingPayTableView.backgroundView = nil;
        [self.view addSubview:_waitingPayTableView];
    }
    return _waitingPayTableView;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        NSString *cellid = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        REWaitingPayOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[REWaitingPayOneTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            cell.backgroundView = nil;
            
        }
        [cell showDataWithModel:self.waitingPayModel];
        return cell;
    } else {
        NSString *cellid = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        REWaitingPaySecondTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[REWaitingPaySecondTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = REWhiteColor;
            cell.backgroundView = nil;
            
            __weak typeof (self)weekself = self;
            cell.QRCodeBlock = ^(id  _Nonnull msg,NSString  *_Nonnull pay_code) {
                __strong typeof (weekself)strongself = weekself;
                REReadingEarnPopupView *popView = [REReadingEarnPopupView readingEarnPopupViewWithType:4];
                [popView showPopupViewWithData:pay_code];
                popView.copyQRcodeAddressBlock = ^(UIButton * _Nonnull sender,NSString *_Nonnull text) {
                    UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
                    pastboard.string = text;
                    [strongself showAlertMsg:@"复制成功" Duration:2];
                };

            };
        }
        [cell showDataWithModel:self.waitingPayModel];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        return 179;
    }
    return 197+2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([self.type isEqualToString:@"1"]) {
        [self.headerView showDataWithModel:self.waitingPayModel];
        __weak typeof (self)weekself = self;
        self.headerView.appealBlock = ^(UIButton * _Nonnull sender) {
            __strong typeof (weekself)strongself = weekself;
            REAppealViewController *vc = [REAppealViewController new];
            vc.naviTitle = @"申诉";
            vc.waitingPayModel = strongself.waitingPayModel;
            [strongself.navigationController pushViewController:vc animated:YES];
        };
    } else {
        self.headerView.frame = CGRectMake(0, 0, REScreenWidth, 0);
        self.headerView.hidden = YES;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    [self.footerView showDataWithModel:self.waitingPayModel withType:self.type withModel:self.appealStatusModel];
    __weak typeof (self)weekself = self;
    self.footerView.payOrCancelBlock = ^(UIButton * _Nonnull sender) {
        __strong typeof (weekself)strongself = weekself;
        UIButton *button = sender;
        REReadingEarnPopupView *popView = [REReadingEarnPopupView readingEarnPopupViewWithType:1];
        [popView showPopupViewWithData:@""];
        strongself.popView = popView;
        strongself.paypwd = @"";
        popView.exchangeYDCBlock = ^(UIButton * _Nonnull sender,NSString *_Nonnull text) {
            if (text.length < 6) {
                [strongself showAlertMsg:@"密码错误" Duration:2];
            } else {
                strongself.paypwd = text;
                if (button.tag == 10) {
                    [strongself requestNetworkCanclePay];
                } else {
                    if ([button.titleLabel.text isEqualToString:@"放币"]) {
                        [strongself requestNetworkCoinRelease];
                    } else {
                        [strongself requestNetworkPay];
                    }
                }
            }
        };

    };
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
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
