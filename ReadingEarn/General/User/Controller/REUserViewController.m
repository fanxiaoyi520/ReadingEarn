//
//  REUserViewController.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/15.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REUserViewController.h"
#import "REUserHeaderView.h"
#import "REUserModel.h"
#import "REUseWalletModel.h"
#import "REPersonalCenterViewController.h"
#import "RESystemBulletinViewController.h"
#import "REMyNewsViewController.h"
#import "REBillDetailsViewController.h"
#import "REMyNewsViewController.h"
#import "REGoSignInViewController.h"
#import "REMyBookFriendsViewController.h"
#import "REReadingPackageViewController.h"
#import "RERecommendationCodeViewController.h"
#import "REExchangeViewController.h"
#import "RETradingMarketViewController.h"
#import "RERechargeCurrencyViewController.h"
#import "RETransferAccountsViewController.h"
#import "REUserAppHeaderView.h"
#import <SafariServices/SafariServices.h>

#import "ZDPay_OrderSureViewController.h"

@interface REUserViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) DefaultServerRequest *requestA;
@property (nonatomic, strong) DefaultServerRequest *requestB;
@property (nonatomic, strong) DefaultServerRequest *requestC;
@property (nonatomic, strong) DefaultServerRequest *requestD;
@property (nonatomic, strong) DefaultServerRequest *requestE;
@property (nonatomic, strong) DefaultServerRequest *requestUpdateVersion;
@property (nonatomic ,strong)UITableView *userTableView;
@property (nonatomic ,strong)REUserHeaderView *headerView;
@property (nonatomic ,strong)REUserAppHeaderView *headerAppView;
@property (nonatomic ,strong)NSArray *imageArray;
@property (nonatomic ,strong)NSArray *titleArray;
@property (nonatomic ,strong)REUserModel *userModel;
@property (nonatomic ,strong)REUseWalletModel *useWalletModel;
@property (nonatomic ,copy)NSString *auditStatusStr;
@property (nonatomic ,copy)NSString *currentVersion;
@property (nonatomic ,copy)NSString *is_TransferAccountsShowStr;
@property (nonatomic ,assign)NSInteger ios_Version;
@end

@implementation REUserViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self requestNetwork];
}

- (void)viewDidLoad {
    self.switchNavigationBarHidden = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.delegate = self;
    NSString *versionStr = [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    self.ios_Version = [[versionStr stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue];
    [self re_loadUI];
    if ([ToolObject onlineAuditJudgment] == YES) {
        self.imageArray = @[@"gerenzhongxin",@"toolbar_icon_invite_nor@3x(1)",@"toolbar_icon_invite_nor@3x",@"toolbar_icon_invite_nor@2x(2)",@"toolbar_icon_invite_nor(3)",@"toolbar_icon_invite_nor@3x(4)",@"toolbar_icon_invite_nor@2x(5)",@"toolbar_icon_setting_nor@3x",@"banbenhao"];
        self.titleArray = @[@"个人中心",@"充值阅币",@"每日任务",@"账单明细",@"我的消息",@"阅读记录",@"系统公告",@"联系客服",@"版本号"];
    } else {
        self.imageArray = @[@"gerenzhongxin",@"toolbar_icon_invite_nor(3)",@"toolbar_icon_invite_nor@3x(4)",@"toolbar_icon_invite_nor@2x(5)",@"toolbar_icon_setting_nor@3x",@"banbenhao"];
        self.titleArray = @[@"个人中心",@"我的消息",@"阅读记录",@"系统公告",@"联系客服",@"版本号"];
    }
}

#pragma mark - 网络请求--------用户信息
- (void)requestNetwork {
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestA startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
        })
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestA = nil;
        NSString *code = [NSString stringWithFormat:@"%@",response.responseObject[@"code"]];
        NSString *msg = [NSString stringWithFormat:@"%@",response.responseObject[@"msg"]];
        if ([code isEqualToString:@"0"]) {
            //请求失败
            [self showError:[response.responseObject objectForKey:@"msg"]];
        } else if ([code isEqualToString:@"2"]) {
            [self showAlertMsg:msg Duration:2];
            //token过期
            RELoginViewController *vc = [RELoginViewController new];
            RERootNavigationViewController *nav = [[RERootNavigationViewController alloc] initWithRootViewController:vc];
            nav.modalPresentationStyle = NO;
            [self presentViewController:nav animated:NO completion:nil];
        } else {
            NSDictionary *dic = [response.responseObject objectForKey:@"data"];
            REUserModel *model = [REUserModel mj_objectWithKeyValues:dic];
            self.userModel = model;
            [self requestNetworkB];
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
        _requestA.requestURI = [NSString stringWithFormat:@"%@/ucenter/ucenter_info",HomePageDomainName];
        _requestA.requestParameter = @{
                                       @"token":token,
                                       @"type":@"2"
                                      };
    }
    return _requestA;
}

#pragma mark - 网络请求--------用户钱包
- (void)requestNetworkB {
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestB startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
        })
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestB = nil;
        NSString *code = [NSString stringWithFormat:@"%@",response.responseObject[@"code"]];
        NSString *msg = [NSString stringWithFormat:@"%@",response.responseObject[@"msg"]];
        if ([code isEqualToString:@"0"]) {
            [self.userTableView reloadData];
        } else if ([code isEqualToString:@"1"]){
            //if (![response.responseObject[@"data"] isEqual:[NSNull null]]) {
                NSDictionary *dic = response.responseObject;
                REUseWalletModel *model = [REUseWalletModel mj_objectWithKeyValues:dic];
                self.useWalletModel = model;
            //}
            [self requestNetworkD];
        } else {
            [self showAlertMsg:msg Duration:2];
        }
    } failure:^(YCNetworkResponse * _Nonnull response) {
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestB = nil;
    }];
}

- (DefaultServerRequest *)requestB {
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    if (!_requestB) {
        _requestB = [[DefaultServerRequest alloc] init];
        _requestB.requestMethod = YCRequestMethodPOST;
        _requestB.requestURI = [NSString stringWithFormat:@"%@/wallet/get_wallet",HomePageDomainName];
        _requestB.requestParameter = @{
                                       @"token":token
                                      };
    }
    return _requestB;
}

#pragma mark - 网络请求--------用户钱包
- (void)requestNetworkC {
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestC startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
        })
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestC = nil;
        NSString *code = [NSString stringWithFormat:@"%@",response.responseObject[@"code"]];
        NSString *msg = [NSString stringWithFormat:@"%@",response.responseObject[@"msg"]];
        if ([code isEqualToString:@"0"]) {
            [self.userTableView reloadData];
        } else if ([code isEqualToString:@"1"]){
            REReadingEarnPopupView *popView = [REReadingEarnPopupView readingEarnPopupViewWithType:4];
            [popView showPopupViewWithData:response.responseObject[@"data"]];
            popView.copyQRcodeAddressBlock = ^(UIButton * _Nonnull sender,NSString *_Nonnull text) {
                UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
                pastboard.string = text;
                [self showAlertMsg:@"复制成功" Duration:2];
            };
            [self requestNetwork];
        } else {
            [self showAlertMsg:msg Duration:2];
        }
    } failure:^(YCNetworkResponse * _Nonnull response) {
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestC = nil;
    }];
}

- (DefaultServerRequest *)requestC {
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    if (!_requestC) {
        _requestC = [[DefaultServerRequest alloc] init];
        _requestC.requestMethod = YCRequestMethodPOST;
        _requestC.requestURI = [NSString stringWithFormat:@"%@/wallet/get_address",HomePageDomainName];
        _requestC.requestParameter = @{
                                       @"token":token
                                      };
    }
    return _requestC;
}

#pragma mark - 网络请求--------身份认证状态
- (void)requestNetworkD {
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestD startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
        })
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestD = nil;
        NSString *code = [NSString stringWithFormat:@"%@",response.responseObject[@"code"]];
        NSString *msg = [NSString stringWithFormat:@"%@",response.responseObject[@"msg"]];
        if ([code isEqualToString:@"1"]) {
            self.auditStatusStr = msg;
            [self requestNetworkE];
//            [self.userTableView reloadData];
//
//            [HSUpdateApp hs_updateWithAPPID:nil withBundleId:nil block:^(NSString *currentVersion, NSString *storeVersion, NSString *openUrl, BOOL isUpdate) {
//            }];

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
        _requestD.requestURI = [NSString stringWithFormat:@"%@/ucenter/user_certification",HomePageDomainName];
        _requestD.requestParameter = @{
                                       @"token":token,
                                      };
    }
    return _requestD;
}

#pragma mark - 网络请求--------转账展示
- (void)requestNetworkE {
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestE startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
        })
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestE = nil;
        NSString *code = [NSString stringWithFormat:@"%@",response.responseObject[@"code"]];
        NSString *msg = [NSString stringWithFormat:@"%@",response.responseObject[@"msg"]];
        NSString *status = [NSString stringWithFormat:@"%@",response.responseObject[@"status"]];
        if ([code isEqualToString:@"1"]) {
            self.is_TransferAccountsShowStr = status;
            
            NSInteger houtaiVersion = [[self.userModel.edition.edition_name stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue];
            if (self.ios_Version < houtaiVersion) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"发现新的版本，是否马上升级?" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
                        SFSafariViewController *safariVc = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"https://www.yuezapp.com/app/download?type=2"]];
                        [self presentViewController:safariVc animated:YES completion:nil];
                }];

                UIAlertAction *cancelAction =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    self.ios_Version = 100000;
                }];

                [alert addAction:okAction];
                [alert addAction:cancelAction];
                [self presentViewController:alert animated:true completion:nil];

            }
            
            [self.userTableView reloadData];
            [HSUpdateApp hs_updateWithAPPID:nil withBundleId:nil block:^(NSString *currentVersion, NSString *storeVersion, NSString *openUrl, BOOL isUpdate) {
            }];
        } else {
            [self showAlertMsg:msg Duration:2];
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
        _requestE.requestURI = [NSString stringWithFormat:@"%@/ucenter/show",HomePageDomainName];
        _requestE.requestParameter = @{
                                       @"token":token,
                                      };
    }
    return _requestE;
}

#pragma mark - 加载UI
- (void)re_loadUI {
    [self userTableView];
    self.extendedLayoutIncludesOpaqueBars = YES;

    if (@available(iOS 11.0, *)) {
         self.userTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
         self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (UITableView *)userTableView {
    if (!_userTableView) {
        _userTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, REScreenWidth, REScreenHeight-RETabBarHeight) style:UITableViewStylePlain];
        _userTableView.delegate = self;
        _userTableView.backgroundColor = REBackColor;
        _userTableView.dataSource = self;
        [self.view addSubview:_userTableView];
        if ([ToolObject onlineAuditJudgment] == YES) {
            REUserHeaderView *headerView = [REUserHeaderView new];
            headerView.backgroundColor = REWhiteColor;
            headerView.frame = CGRectMake(0, 0, REScreenWidth, 488);
            self.headerView = headerView;
            _userTableView.tableHeaderView = headerView;
        } else {
            REUserAppHeaderView *headerView = [REUserAppHeaderView new];
            headerView.backgroundColor = REWhiteColor;
            headerView.frame = CGRectMake(0, 0, REScreenWidth, 150);
            self.headerAppView = headerView;
            _userTableView.tableHeaderView = headerView;
        }
    }
    return _userTableView;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        if (indexPath.row != self.titleArray.count-1) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        UIView *lineView = [UIView new];
        lineView.backgroundColor = RELineColor;
        lineView.tag = 100;
        [cell.contentView addSubview:lineView];
        
        UIImageView *imageView = [UIImageView new];
        imageView.tag = 101;
        [cell.contentView addSubview:imageView];
        
        UILabel *contentLabl = [UILabel new];
        contentLabl.textAlignment = NSTextAlignmentLeft;
        contentLabl.tag = 102;
        [cell.contentView addSubview:contentLabl];
        contentLabl.textColor = [UIColor colorWithRed:74/255.0 green:73/255.0 blue:74/255.0 alpha:1.0];
        
        //版本号
        UILabel *versionLabel = [UILabel new];
        versionLabel.textAlignment = NSTextAlignmentRight;
        versionLabel.tag = 103;
        if (indexPath.row == self.titleArray.count-1) {
            [cell.contentView addSubview:versionLabel];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *lineView = [cell.contentView viewWithTag:100];
    lineView.frame = CGRectMake(20, 47.5, REScreenWidth-40, 0.5);
    
    UIImageView *imageView = [cell.contentView viewWithTag:101];
    imageView.image = REImageName(self.imageArray[indexPath.row]);
    imageView.frame = CGRectMake(20, 12, 22, 22);
    
    UILabel *contentLabel = [cell.contentView viewWithTag:102];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.titleArray[indexPath.row] attributes:@{NSFontAttributeName: REFont(17), NSForegroundColorAttributeName: [UIColor colorWithRed:74/255.0 green:73/255.0 blue:74/255.0 alpha:1.0]}];
    contentLabel.attributedText = string;
    contentLabel.frame = CGRectMake(54, 15, 200, 17);

    UILabel *versionLabel = [cell.contentView viewWithTag:103];
    versionLabel.font = REFont(14);
    versionLabel.text = [NSString stringWithFormat:@"%@",self.userModel.edition.edition_name];
    versionLabel.frame = CGRectMake(REScreenWidth-120, 12, 100, 22);
    return cell;
}

#pragma mark - 网络请求--------更新版本请求
- (void)requestNetworkUpdateVersion {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestUpdateVersion startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
        })
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestUpdateVersion = nil;
        [self.userTableView reloadData];

        NSArray * results = response.responseObject[@"results"];
        if (results && results.count>0)
        {
            NSDictionary * dic = results.firstObject;
            NSString * lineVersion = dic[@"version"];//版本号
            NSString * releaseNotes = dic[@"releaseNotes"];//更新说明
            //NSString * trackViewUrl = dic[@"trackViewUrl"];//链接
            //把版本号转换成数值
            NSArray * array1 = [self.userModel.edition.edition_name componentsSeparatedByString:@"."];
            NSInteger currentVersionInt = 0;
            if (array1.count == 3)//默认版本号1.0.0类型
            {
                currentVersionInt = [array1[0] integerValue]*100 + [array1[1] integerValue]*10 + [array1[2] integerValue];
            }
            NSArray * array2 = [lineVersion componentsSeparatedByString:@"."];
            NSInteger lineVersionInt = 0;
            if (array2.count == 3)
            {
                lineVersionInt = [array2[0] integerValue]*100 + [array2[1] integerValue]*10 + [array2[2] integerValue];
            }
            if (lineVersionInt > currentVersionInt)//线上版本大于本地版本
            {
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"发现新版本%@",lineVersion] message:releaseNotes preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * ok = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
                UIAlertAction * update = [UIAlertAction actionWithTitle:@"去更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //跳转到App Store
                    NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%@?mt=8",AppID];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                }];
                [alert addAction:ok];
                [alert addAction:update];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
        
    } failure:^(YCNetworkResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestUpdateVersion = nil;
    }];
}

- (DefaultServerRequest *)requestUpdateVersion {
    if (!_requestUpdateVersion) {
        _requestUpdateVersion = [[DefaultServerRequest alloc] init];
        _requestUpdateVersion.requestMethod = YCRequestMethodGET;
        _requestUpdateVersion.requestURI = [[NSString alloc] initWithFormat:@"http://itunes.apple.com/lookup?id=%@",AppID];
             _requestUpdateVersion.responseSerializer.acceptableContentTypes  = [NSSet  setWithObjects:@"application/json",@"text/json",@"text/javascript",nil];
        _requestUpdateVersion.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    return _requestUpdateVersion;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([ToolObject onlineAuditJudgment] == YES) {
        [self.headerView showUserHeaderModel:self.userModel withWalletModel:self.useWalletModel auditStatusStr:self.auditStatusStr is_TransferAccountsShowStr:self.is_TransferAccountsShowStr];
        __weak typeof (self)weekself = self;
        //签到
        self.headerView.toSignInBlock = ^(UIButton * _Nonnull sender) {
            __strong typeof (weekself)strongself = weekself;
            if (![sender.titleLabel.text isEqualToString:@"已签到"]) {
                REGoSignInViewController *vc = [REGoSignInViewController new];
                vc.naviTitle = @"每日签到";
                [strongself.navigationController pushViewController:vc animated:YES];
            }
        };
        //功能模块 (我的书友.......)
        self.headerView.functionBlock = ^(UIButton * _Nonnull sender) {
            __strong typeof (weekself)strongself = weekself;
            if (sender.tag == 300) {
                REMyBookFriendsViewController *vc = [REMyBookFriendsViewController new];
                [strongself.navigationController pushViewController:vc animated:YES];
            } else if (sender.tag == 301) {
                REReadingPackageViewController *vc = [REReadingPackageViewController new];
                [strongself.navigationController pushViewController:vc animated:YES];
            } else if (sender.tag == 302) {
                //[strongself showError:@"暂未开放"];

                NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
                NSString *isArgee = [userD objectForKey:@"isArgee"];
                if ([isArgee isEqualToString:@"已同意"]) {
                    RETradingMarketViewController *vc = [RETradingMarketViewController new];
                    vc.naviTitle = @"交易市场";
                    [strongself.navigationController pushViewController:vc animated:YES];
                } else {
                    REReadingEarnPopupView *popupView = [REReadingEarnPopupView readingEarnPopupViewWithType:REReadingEarnPopupView_UserAgreement];
                    [popupView showPopupViewWithData:@""];
                    popupView.isAgreeBlock = ^(UIButton * _Nonnull sender) {
                        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                        [userDefault setObject:@"已同意" forKey:@"isArgee"];
                        [userDefault synchronize];
                        RETradingMarketViewController *vc = [RETradingMarketViewController new];
                        vc.naviTitle = @"交易市场";
                        [strongself.navigationController pushViewController:vc animated:YES];
                    };
                }
            } else {
                RERecommendationCodeViewController *vc = [RERecommendationCodeViewController new];
                [strongself.navigationController pushViewController:vc animated:YES];
            }
        };
        //生成钱包地址
        self.headerView.generateWalletBlock = ^(UIButton * _Nonnull sender) {
            __strong typeof (weekself)strongself = weekself;
            [strongself requestNetworkC];
        };
        
        self.headerView.walletFunctionBlock = ^(UIButton * _Nonnull sender) {
            __strong typeof (weekself)strongself = weekself;
            if (sender.tag == 1000) {
                [strongself showAlertMsg:@"复制成功" Duration:2];
            } else if (sender.tag == 1001) {
                [strongself showError:@"暂未开放"];
            } else if (sender.tag == 1002) {
                REExchangeViewController *vc = [REExchangeViewController new];
                vc.naviTitle = @"兑换";
                [strongself.navigationController pushViewController:vc animated:YES];
            } else if (sender.tag == 1003) {
                REReadingEarnPopupView *popView = [REReadingEarnPopupView readingEarnPopupViewWithType:2];
                [popView showPopupViewWithData:strongself.useWalletModel];
                popView.copyQRcodeAddressBlock = ^(UIButton * _Nonnull sender,NSString *_Nonnull text) {
                    UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
                    pastboard.string = text;
                    [strongself showAlertMsg:@"复制成功" Duration:2];
                };
            } else {
                RETransferAccountsViewController *vc = [RETransferAccountsViewController new];
                vc.naviTitle = @"转账";
                [strongself.navigationController pushViewController:vc animated:YES];
            }
        };
    } else {
        [self.headerAppView showUserHeaderModel:self.userModel withWalletModel:self.useWalletModel auditStatusStr:self.auditStatusStr is_TransferAccountsShowStr:self.is_TransferAccountsShowStr];
        __weak typeof (self)weekself = self;
        //签到
        self.headerAppView.toSignInBlock = ^(UIButton * _Nonnull sender) {
            __strong typeof (weekself)strongself = weekself;
            REGoSignInViewController *vc = [REGoSignInViewController new];
            vc.naviTitle = @"每日签到";
            [strongself.navigationController pushViewController:vc animated:YES];
        };
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([ToolObject onlineAuditJudgment] == YES) {
        if (indexPath.row == 0) {
            REPersonalCenterViewController *vc  = [REPersonalCenterViewController new];
            vc.naviTitle = self.titleArray[indexPath.row];
            __weak typeof (self)weekself = self;
            vc.changePayPwdTipsBlock = ^(NSString * _Nonnull msg) {
                __strong typeof (weekself)strongself = weekself;
                [strongself showAlertMsg:msg Duration:2];
            };
            vc.changeNameOrHeadBlock = ^(NSString * _Nonnull msg) {
                __strong typeof (weekself)strongself = weekself;
                [strongself showAlertMsg:msg Duration:2];
            };
            vc.bindingAlipayBlock = ^(NSString * _Nonnull msg) {
                __strong typeof (weekself)strongself = weekself;
                [strongself showAlertMsg:msg Duration:2];
            };
            vc.identityAuthenticationBlock = ^(NSString * _Nonnull msg) {
                __strong typeof (weekself)strongself = weekself;
                [strongself showAlertMsg:msg Duration:2];
            };
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 1) {
            ZDPay_OrderSureViewController *vc = [ZDPay_OrderSureViewController manager];
            [vc ZDPay_PaymentResultCallbackWithPaySucess:^(id  _Nonnull responseObject) {
                NSLog(@"%@",responseObject);
            } payCancel:^(id  _Nonnull reason) {
                NSLog(@"%@",reason);
            } payFailure:^(id  _Nonnull desc, NSError * _Nonnull error) {
                NSLog(@"%@",desc);
            }];
            [self.navigationController pushViewController:vc animated:YES];
        
//            [self showError:@"暂未开放"];
//            RERechargeCurrencyViewController *vc = [RERechargeCurrencyViewController new];
//            vc.naviTitle = @"充值阅币";
//            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 2) {
            [self showError:@"暂未开放"];
        } else if (indexPath.row == 3) {
            REBillDetailsViewController *vc = [REBillDetailsViewController new];
    //        vc.naviTitle = self.titleArray[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 4) {
            REMyNewsViewController *vc = [REMyNewsViewController new];
            vc.naviTitle = self.titleArray[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 5) {
            self.tabBarController.selectedIndex = 2;
        } else if (indexPath.row == 6) {
            RESystemBulletinViewController *vc = [RESystemBulletinViewController new];
            vc.naviTitle = self.titleArray[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 7) {
            //http://uee.me/cKRDH
                SFSafariViewController *safariVc = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"http://uee.me/cKRDH"]];
                [self presentViewController:safariVc animated:YES completion:nil];

//            REReadingEarnPopupView *popView = [REReadingEarnPopupView readingEarnPopupViewWithType:0];
//            NSDictionary *dic = @{
//                @"public_logo":self.userModel.public_logo
//            };
//            [popView showPopupViewWithData:dic];
        }
    } else {
        if (indexPath.row == 0) {
            ZDPay_OrderSureViewController *vc = [ZDPay_OrderSureViewController manager];
            [vc ZDPay_PaymentResultCallbackWithPaySucess:^(id  _Nonnull responseObject) {
                NSLog(@"%@",responseObject);
            } payCancel:^(id  _Nonnull reason) {
                NSLog(@"%@",reason);
            } payFailure:^(id  _Nonnull desc, NSError * _Nonnull error) {
                NSLog(@"%@",desc);
            }];
            [self.navigationController pushViewController:vc animated:YES];

//            REPersonalCenterViewController *vc  = [REPersonalCenterViewController new];
//            vc.naviTitle = self.titleArray[indexPath.row];
//            __weak typeof (self)weekself = self;
//            vc.changePayPwdTipsBlock = ^(NSString * _Nonnull msg) {
//                __strong typeof (weekself)strongself = weekself;
//                [strongself showAlertMsg:msg Duration:2];
//            };
//            vc.changeNameOrHeadBlock = ^(NSString * _Nonnull msg) {
//                __strong typeof (weekself)strongself = weekself;
//                [strongself showAlertMsg:msg Duration:2];
//            };
//            vc.bindingAlipayBlock = ^(NSString * _Nonnull msg) {
//                __strong typeof (weekself)strongself = weekself;
//                [strongself showAlertMsg:msg Duration:2];
//            };
//            vc.identityAuthenticationBlock = ^(NSString * _Nonnull msg) {
//                __strong typeof (weekself)strongself = weekself;
//                [strongself showAlertMsg:msg Duration:2];
//            };
//            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 1) {
            REMyNewsViewController *vc = [REMyNewsViewController new];
            vc.naviTitle = self.titleArray[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 2) {
            self.tabBarController.selectedIndex = 2;
        } else if (indexPath.row == 3) {
            RESystemBulletinViewController *vc = [RESystemBulletinViewController new];
            vc.naviTitle = self.titleArray[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 4) {
            REReadingEarnPopupView *popView = [REReadingEarnPopupView readingEarnPopupViewWithType:0];
            NSDictionary *dic = @{
                @"public_logo":self.userModel.public_logo
            };
            [popView showPopupViewWithData:dic];
        }
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
