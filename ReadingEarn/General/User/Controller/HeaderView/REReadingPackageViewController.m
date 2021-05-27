//
//  REReadingPackageViewController.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/29.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REReadingPackageViewController.h"
#import "REReadingPackageModel.h"
#import "REReadingPackageTableViewCell.h"
#import "REMyReadingPackageTableViewCell.h"
#import "REMyReadingPackageModel.h"

@interface REReadingPackageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign)NSInteger navbtnTag;
@property (nonatomic,strong)UIView *backView;
@property (nonatomic, strong) DefaultServerRequest *requestA;
@property (nonatomic, strong) DefaultServerRequest *requestB;
@property (nonatomic, strong) DefaultServerRequest *requestC;
@property (nonatomic, strong) DefaultServerRequest *requestD;
@property (nonatomic ,strong)UIScrollView *myScrollView;
@property (nonatomic ,strong)UITableView *myBookFriendsTableView;
@property (nonatomic ,strong)UITableView *myProfitTableView;
@property (nonatomic ,strong)NSMutableArray *personalArray;
@property (nonatomic ,strong)NSMutableArray *refreshPersonalArray;
@property (nonatomic ,strong)NSMutableArray *incomeArray;
@property (nonatomic ,strong)NSMutableArray *refreshIncomeArray;
@property (nonatomic ,assign)NSInteger pageCount;
@property (nonatomic ,strong)REReadingEarnPopupView *popView;
@property (nonatomic ,copy)NSString *paypwd;
@property (nonatomic ,copy)NSString *text_id;
@end

@implementation REReadingPackageViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self navSwitchButton];
    [self re_loadUI];
    [self requestNetwork];
    [self requestNetworkBwithRefresh:NO];
}

#pragma mark - 网络请求-------阅读包
- (void)requestNetwork {
    [self.personalArray removeAllObjects];
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
            NSArray *array = response.responseObject[@"data"];
            for (NSDictionary *dic in array) {
                REReadingPackageModel *model = [REReadingPackageModel mj_objectWithKeyValues:dic];
                [self.personalArray addObject:model];
            }
            [self.myBookFriendsTableView  reloadData];
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
        _requestA.requestURI = [NSString stringWithFormat:@"%@/operation/read_package",HomePageDomainName];
        _requestA.requestParameter = @{
                                       @"token":token,
                                      };
    }
    return _requestA;
}

#pragma mark - 网络请求-------我的阅读包
- (void)requestNetworkBwithRefresh:(BOOL)isRefresh {
    if (isRefresh == YES) {
        self.pageCount++;
        [self requestNetworkB:isRefresh];
    } else {
        self.pageCount = 1;
        [self requestNetworkB:isRefresh];
    }
}

- (void)requestNetworkB:(BOOL)isRefresh {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestB startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
        })
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestB = nil;
        NSString *code = [NSString stringWithFormat:@"%@",response.responseObject[@"code"]];
        NSString *msg = [NSString stringWithFormat:@"%@",response.responseObject[@"msg"]];

        if (isRefresh == NO) {
            if ([code isEqualToString:@"1"]) {
                NSArray *array = response.responseObject[@"data"];
                for (NSDictionary *dic in array) {
                    REMyReadingPackageModel *model = [REMyReadingPackageModel mj_objectWithKeyValues:dic];
                    [self.incomeArray addObject:model];
                }
                [self.myProfitTableView  reloadData];
            } else {
                [self showAlertMsg:msg Duration:2];
            }
        } else {
            [self.myProfitTableView.mj_footer endRefreshing];
            if ([code isEqualToString:@"1"]) {
                NSArray *array = response.responseObject[@"data"];
                for (NSDictionary *dic in array) {
                    REMyReadingPackageModel *model = [REMyReadingPackageModel mj_objectWithKeyValues:dic];
                    [self.incomeArray addObject:model];
                }
                [self.myProfitTableView  reloadData];
                
                if (array.count < 10) {
                    [self.myProfitTableView.mj_footer endRefreshingWithNoMoreData];
                }
            } else {
                [self showAlertMsg:msg Duration:2];
            }
        }
    } failure:^(YCNetworkResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestB = nil;
    }];
}

- (DefaultServerRequest *)requestB {
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    NSString *page = [NSString stringWithFormat:@"%ld",(long)self.pageCount];
    if (!_requestB) {
        _requestB = [[DefaultServerRequest alloc] init];
        _requestB.requestMethod = YCRequestMethodPOST;
        _requestB.requestURI = [NSString stringWithFormat:@"%@/operation/user_read_package_list",HomePageDomainName];
        _requestB.requestParameter = @{
                                       @"token":token,
                                       @"page":page,
                                       @"limit":@"10",
                                      };
    }
    return _requestB;
}

#pragma mark - 网络请求-------购买YDC
- (void)requestNetworkC {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestC startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
        })
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestC = nil;
        //NSString *code = [NSString stringWithFormat:@"%@",response.responseObject[@"code"]];
        NSString *msg = [NSString stringWithFormat:@"%@",response.responseObject[@"msg"]];
        
        [self.popView closeThePopupView];
        [self showAlertMsg:msg Duration:2];
        [self requestNetwork];

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
        _requestC.requestURI = [NSString stringWithFormat:@"%@/operation/buy_read_package_do",HomePageDomainName];
        _requestC.requestParameter = @{
                                       @"token":token,
                                       @"paypwd":self.paypwd,
                                       @"id":self.text_id
                                      };
    }
    return _requestC;
}

#pragma mark - 网络请求-------购买YC
- (void)requestNetworkD {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestD startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
        })
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestD = nil;
        //NSString *code = [NSString stringWithFormat:@"%@",response.responseObject[@"code"]];
        NSString *msg = [NSString stringWithFormat:@"%@",response.responseObject[@"msg"]];
        [self.popView closeThePopupView];
        [self showAlertMsg:msg Duration:2];
        [self requestNetwork];
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
        _requestD.requestURI = [NSString stringWithFormat:@"%@/operation/chuji_read_package",HomePageDomainName];
        _requestD.requestParameter = @{
                                       @"token":token,
                                       @"paypwd":self.paypwd,
                                       @"id":self.text_id
                                      };
    }
    return _requestD;
}

#pragma mark - 加载UI
- (void)re_loadUI {
    [self myScrollView];

    
    //1.阅读包
    _myBookFriendsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, REScreenWidth, REScreenHeight-NavHeight) style:UITableViewStylePlain];
    _myBookFriendsTableView.delegate = self;
    _myBookFriendsTableView.dataSource = self;
    _myBookFriendsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myBookFriendsTableView.backgroundColor = REBackColor;
    [self.myScrollView addSubview:_myBookFriendsTableView];

    //2.我的阅读包
    _myProfitTableView = [[UITableView alloc] initWithFrame:CGRectMake(REScreenWidth, 0, REScreenWidth, REScreenHeight-NavHeight) style:UITableViewStylePlain];
    _myProfitTableView.delegate = self;
    _myProfitTableView.dataSource = self;
    _myProfitTableView.backgroundColor = REBackColor;
    [self.myScrollView addSubview:_myProfitTableView];
    _myProfitTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myProfitTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self requestNetworkBwithRefresh:YES];
    }];
}

- (UIScrollView *)myScrollView {
    if (!_myScrollView) {
        _myScrollView = [[UIScrollView alloc] init];
        _myScrollView.frame = CGRectMake(0, NavHeight, REScreenWidth, REScreenHeight-NavHeight);
        _myScrollView.showsVerticalScrollIndicator = NO;
        _myScrollView.scrollEnabled = NO;
        _myScrollView.showsHorizontalScrollIndicator = NO;
        _myScrollView.contentSize = CGSizeMake(REScreenWidth*2, REScreenHeight-NavHeight);
        [self.view addSubview:_myScrollView];
    }
    return _myScrollView;
}

- (NSMutableArray *)personalArray {
    if (!_personalArray) {
        _personalArray = [NSMutableArray array];
    }
    return _personalArray;
}

- (NSMutableArray *)refreshPersonalArray {
    if (!_refreshPersonalArray) {
        _refreshPersonalArray = [NSMutableArray array];
    }
    return _refreshPersonalArray;
}

- (NSMutableArray *)incomeArray {
    if (!_incomeArray) {
        _incomeArray = [NSMutableArray array];
    }
    return _incomeArray;
}

- (NSMutableArray *)refreshIncomeArray {
    if (!_refreshIncomeArray) {
        _refreshIncomeArray = [NSMutableArray array];
    }
    return _refreshIncomeArray;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.myBookFriendsTableView) {
        return self.personalArray.count;
    }
    return self.incomeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.myBookFriendsTableView) {
        NSString *cellid = [NSString stringWithFormat:@"mybookfriend%ld",(long)indexPath.row];
        REReadingPackageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        if (!cell) {
            cell = [[REReadingPackageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            cell.backgroundView = nil;
            cell.backgroundColor = [UIColor clearColor];
            
            __weak typeof (self)weekself = self;
            cell.readingPackageBlock = ^(UIButton * _Nonnull sender,NSString *_Nonnull text) {
                __strong typeof (weekself)strongself = weekself;
                if (sender.tag == 100) {
                    REReadingEarnPopupView *popView = [REReadingEarnPopupView readingEarnPopupViewWithType:1];
                    strongself.popView = popView;
                    [popView showPopupViewWithData:@""];
                    strongself.text_id = text;
                    popView.exchangeYDCBlock = ^(UIButton * _Nonnull sender,NSString *_Nonnull text) {
                        __strong typeof (weekself)strongself = weekself;
                        if (text.length < 6) {
                            [strongself showAlertMsg:@"密码错误" Duration:2];
                        } else {
                            self.paypwd = text;
                            [strongself requestNetworkC];
                        }
                    };
                } else {
                    REReadingEarnPopupView *popView = [REReadingEarnPopupView readingEarnPopupViewWithType:1];
                    strongself.popView = popView;
                    [popView showPopupViewWithData:@""];
                    strongself.text_id = text;
                    popView.exchangeYDCBlock = ^(UIButton * _Nonnull sender,NSString *_Nonnull text) {
                        __strong typeof (weekself)strongself = weekself;
                        if (text.length < 6) {
                            [strongself showAlertMsg:@"密码错误" Duration:2];
                        } else {
                            self.paypwd = text;
                            [strongself requestNetworkD];
                        }
                    };
                }
            };
        }
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        [cell showDataWithModel:self.personalArray[indexPath.row] withIndexPath:indexPath];
        return cell;
    } else {
        NSString *cellid = [NSString stringWithFormat:@"myprifit%ld",(long)indexPath.row];
        REMyReadingPackageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        if (!cell) {
            cell = [[REMyReadingPackageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            cell.backgroundView = nil;
            cell.backgroundColor = [UIColor clearColor];
        }
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        if (self.incomeArray.count >0) {
            [cell showDataWithModel:self.incomeArray[indexPath.row]];
        }

        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.myBookFriendsTableView) {
        return 138;
    }
    return 138;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.myBookFriendsTableView) {
        return nil;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.myBookFriendsTableView) {
        return 0.01;
    } else {
        return 0.01;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - 导航栏点击切换按钮
- (void)navSwitchButton {
    NSArray *arrayBtn = @[@"阅读包",@"我的阅读包"];
    UIView *backView = [UIView new];
    self.backView = backView;
    backView.frame = CGRectMake(101, REStatusHeight+5, (REScreenWidth-101*2), 33);
    backView.backgroundColor = REColor(247, 100, 66);
    [ToolObject buttonTangentialFilletWithButton:backView withUIRectCorner:UIRectCornerAllCorners];
    [self.topNavBar addSubview:backView];
    for (int i=0; i<2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0.5+i*((REScreenWidth-102*2)/2), 0.5, (REScreenWidth-102*2)/2, 32);
        [backView addSubview:btn];
        btn.tag = 10 + i;
        [btn addTarget:self action:@selector(navButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:arrayBtn[i] forState:UIControlStateNormal];
        btn.titleLabel.font = REFont(16);
        if (i==0) {
            [ToolObject buttonTangentialFilletWithButton:btn withUIRectCorner:UIRectCornerTopLeft | UIRectCornerBottomLeft];
            [btn setTitleColor:REWhiteColor forState:UIControlStateNormal];
            btn.backgroundColor = REColor(247, 100, 66);
            self.navbtnTag = 10+i;
        } else {
            [ToolObject buttonTangentialFilletWithButton:btn withUIRectCorner:UIRectCornerTopRight | UIRectCornerBottomRight];
            [btn setTitleColor:REColor(247, 100, 66) forState:UIControlStateNormal];
            btn.backgroundColor = REWhiteColor;
        }
    }
}

- (void)navButtonAction:(UIButton *)sender {
    [self.myProfitTableView.mj_footer resetNoMoreData];
    UIButton *btn = [self.backView viewWithTag:self.navbtnTag];
    if (sender.selected == YES) {
        self.navbtnTag = sender.tag;
    } else {
        sender.selected = NO;
        [btn setTitleColor:REColor(247, 100, 66) forState:UIControlStateNormal];
        btn.backgroundColor = REWhiteColor;
        [sender setTitleColor:REWhiteColor forState:UIControlStateNormal];
        sender.backgroundColor = REColor(247, 100, 66);
        self.navbtnTag = sender.tag;
    }
    if (sender.tag==10) {
        self.myScrollView.contentOffset = CGPointMake(0, 0);
    } else {
        self.myScrollView.contentOffset = CGPointMake(REScreenWidth, 0);
    }

    //[self requestNetworkWithRefreshB:NO];
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
