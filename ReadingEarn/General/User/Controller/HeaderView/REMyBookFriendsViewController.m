//
//  REMyBookFriendsViewController.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/29.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REMyBookFriendsViewController.h"
#import "REMyBookFriendHeaderView.h"
#import "REHeaderBookFriendModel.h"
#import "REHeaderBookFriendCellModel.h"
#import "REBookFriendTableViewCell.h"
#import "REMyIncomeTableViewCell.h"
#import "REIncomeModel.h"
#import "REIncomeHeaderView.h"

@interface REMyBookFriendsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign)NSInteger navbtnTag;
@property (nonatomic,strong)UIView *backView;
@property (nonatomic, strong) DefaultServerRequest *requestA;
@property (nonatomic, strong) DefaultServerRequest *requestB;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic ,strong)UIScrollView *myScrollView;
@property (nonatomic ,strong)UITableView *myBookFriendsTableView;
@property (nonatomic ,strong)UITableView *myProfitTableView;
@property (nonatomic ,strong)REMyBookFriendHeaderView *bookFriendHeaderView;
@property (nonatomic ,strong)NSMutableArray *personalArray;
@property (nonatomic ,strong)NSMutableArray *refreshPersonalArray;
@property (nonatomic ,strong)REHeaderBookFriendModel *headerBookFriendModel;
@property (nonatomic ,strong)REHeaderBookFriendCellModel *headerBookFriendCellModel;
@property (nonatomic ,copy)NSString *typeBookFriend;
@property (nonatomic ,assign)BOOL isTypeClick;
@property (nonatomic ,assign)BOOL isTypeClickIncome;
@property (nonatomic ,copy)NSString *order;
@property (nonatomic ,copy)NSString *mytag;

@property (nonatomic ,strong)NSMutableArray *incomeArray;
@property (nonatomic ,strong)NSMutableArray *refreshIncomeArray;
@property (nonatomic, assign) NSInteger pageCountTwo;
@property (nonatomic ,copy)NSString *typeIncome;
@property (nonatomic ,strong)UIView *headView;
@property (nonatomic ,strong)REIncomeHeaderView *incomeHeaderView;

@end

@implementation REMyBookFriendsViewController
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
    
    self.isTypeClick = 0;
    self.isTypeClickIncome = 0;
    self.typeBookFriend = @"0";
    self.typeIncome = @"1";
    [self navSwitchButton];
    [self re_loadUI];
    self.order = @"";
    
    [self requestNetworkWithRefresh:NO];
    [self requestNetworkWithRefreshB:NO];
}

#pragma mark - 网络请求-------我的书友
- (void)requestNetworkWithRefresh:(BOOL)isRefresh {
    if (isRefresh == YES) {
        self.pageCount++;
        if (self.refreshPersonalArray.count < 15) {
            
            [self.refreshPersonalArray removeAllObjects];
            [self.myBookFriendsTableView.mj_footer endRefreshing];
        } else {
            [self.refreshPersonalArray removeAllObjects];
            [self requestNetwork];
        }
    } else {
        self.pageCount = 1;
        [self requestNetwork];
    }
}

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
            NSArray *array = [response.responseObject[@"data"] objectForKey:@"list"];
            NSDictionary *data = [response.responseObject[@"data"] objectForKey:@"data"];
            for (NSDictionary *dic in array) {
                REHeaderBookFriendCellModel *model = [REHeaderBookFriendCellModel mj_objectWithKeyValues:dic];
                [self.personalArray addObject:model];
                [self.refreshPersonalArray addObject:model];
            }
            
            REHeaderBookFriendModel *headerModel = [REHeaderBookFriendModel mj_objectWithKeyValues:data];
            self.headerBookFriendModel = headerModel;
            
            [self.myBookFriendsTableView  reloadData];
            //[self requestNetworkWithRefreshB:NO];
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
    NSString *page = [NSString stringWithFormat:@"%ld",(long)self.pageCount];
    if (!_requestA) {
        _requestA = [[DefaultServerRequest alloc] init];
        _requestA.requestMethod = YCRequestMethodPOST;
        _requestA.requestURI = [NSString stringWithFormat:@"%@/team/team_list",HomePageDomainName];
        if ([self.typeBookFriend isEqualToString:@"0"]) {
            _requestA.requestParameter = @{
                                           @"token":token,
                                           @"page":page,
                                           @"limit":@"15",
                                           @"type":@"",
                                           @"order":@"1"
                                          };
        }else if ([self.typeBookFriend isEqualToString:@"3"]) {
            NSInteger d = [self.mytag integerValue]-200;
            NSString *s;
            if (d == -200) {
                s = @"";
            } else {
                s = [NSString stringWithFormat:@"%ld",d];
            }
        _requestA.requestParameter = @{
                                       @"token":token,
                                       @"page":page,
                                       @"limit":@"15",
                                       @"type":s,
                                       @"order":self.order
                                      };
        } else {
            _requestA.requestParameter = @{
                                           @"token":token,
                                           @"page":page,
                                           @"limit":@"15",
                                           @"type":self.typeBookFriend,
                                           @"order":@"1"
                                          };
        }
    }
    return _requestA;
}

#pragma mark - 网络请求--------我的收益
- (void)requestNetworkWithRefreshB:(BOOL)isRefresh {
    if (isRefresh == YES) {
        self.pageCountTwo++;
        if (self.refreshIncomeArray.count < 15) {
            [self.refreshIncomeArray removeAllObjects];
            [self.myProfitTableView.mj_footer endRefreshing];
        } else {
            [self.refreshIncomeArray removeAllObjects];
            [self requestNetworkB];
        }
    } else {
        self.pageCountTwo = 1;
        [self requestNetworkB];
    }
}

- (void)requestNetworkB {
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
            NSArray *array = response.responseObject[@"list"];
            for (NSDictionary *dic in array) {
                REIncomeModel *model = [REIncomeModel mj_objectWithKeyValues:dic];
                [self.incomeArray addObject:model];
                [self.refreshIncomeArray addObject:model];
            }
            [self.myProfitTableView  reloadData];
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
    NSString *page = [NSString stringWithFormat:@"%ld",(long)self.pageCountTwo];
    if (!_requestB) {
        _requestB = [[DefaultServerRequest alloc] init];
        _requestB.requestMethod = YCRequestMethodPOST;
        _requestB.requestURI = [NSString stringWithFormat:@"%@/team/income",HomePageDomainName];
        _requestB.requestParameter = @{
                                       @"token":token,
                                       @"page":page,
                                       @"limit":@"15",
                                       @"type":self.typeIncome
                                      };
    }
    return _requestB;
}


#pragma mark - 加载UI
- (void)re_loadUI {
    [self myScrollView];

    
    //1.我的书友
    _myBookFriendsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, REScreenWidth, REScreenHeight-NavHeight) style:UITableViewStyleGrouped];
    _myBookFriendsTableView.delegate = self;
    _myBookFriendsTableView.dataSource = self;
    _myBookFriendsTableView.backgroundColor = REWhiteColor;
    [self.myScrollView addSubview:_myBookFriendsTableView];
    
    REMyBookFriendHeaderView *headerView = [REMyBookFriendHeaderView new];
    self.bookFriendHeaderView = headerView;
    _myBookFriendsTableView.tableHeaderView = headerView;
    self.myBookFriendsTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
    [self.myBookFriendsTableView.mj_footer resetNoMoreData];
        [self requestNetworkWithRefresh:YES];
    }];
    [self.myBookFriendsTableView.mj_footer beginRefreshing];

    //2.我的收益
    _myProfitTableView = [[UITableView alloc] initWithFrame:CGRectMake(REScreenWidth, 0, REScreenWidth, REScreenHeight-NavHeight) style:UITableViewStyleGrouped];
    _myProfitTableView.delegate = self;
    _myProfitTableView.dataSource = self;
    _myProfitTableView.backgroundColor = REWhiteColor;
    [self.myScrollView addSubview:_myProfitTableView];
    REIncomeHeaderView *incomeHeaderView = [REIncomeHeaderView new];
    _myProfitTableView.tableHeaderView = incomeHeaderView;
    self.incomeHeaderView = incomeHeaderView;
    self.myProfitTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
    [self.myProfitTableView.mj_footer resetNoMoreData];
        [self requestNetworkWithRefreshB:YES];
    }];
    [self.myProfitTableView.mj_footer beginRefreshing];

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
        REBookFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        if (!cell) {
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
            cell = [[REBookFriendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            
            UIView *lineView = [UIView new];
            lineView.tag = 10;
            lineView.backgroundColor = RELineColor;
            [cell.contentView addSubview:lineView];
        }
        
        UIView *linevView = [cell.contentView viewWithTag:10];
        linevView.frame = CGRectMake(0, 131.5, REScreenWidth, 0.5);
        
        [cell showDataWithModel:self.personalArray[indexPath.row]];
        return cell;
    } else {
        NSString *cellid = [NSString stringWithFormat:@"myprifit%ld",(long)indexPath.row];
        REMyIncomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        if (!cell) {
            cell = [[REMyIncomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
            
            UIView *lineView = [UIView new];
            lineView.tag = 10;
            lineView.backgroundColor = RELineColor;
            [cell.contentView addSubview:lineView];
        }
        UIView *linevView = [cell.contentView viewWithTag:10];
        linevView.frame = CGRectMake(0, 99.5, REScreenWidth, 0.5);
        if (self.incomeArray.count >0) {
            [cell showDataWithModel:self.incomeArray[indexPath.row]];
        }

        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.myBookFriendsTableView) {
        return 132;
    }
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.myBookFriendsTableView) {
        [self.bookFriendHeaderView showDataWithModel:self.headerBookFriendModel withTypeClick:self.isTypeClick];
        __weak typeof (self)weekself = self;
        self.bookFriendHeaderView.headerClickBlock = ^(UIButton * _Nonnull sender,NSString *_Nonnull order) {
            __strong typeof (weekself)stongself = weekself;
            [stongself.personalArray removeAllObjects];
            stongself.pageCount = 1;
            stongself.isTypeClick = 1;
            stongself.order = @"";
            [stongself.refreshPersonalArray removeAllObjects];
            stongself.typeBookFriend = [NSString stringWithFormat:@"%ld",(long)sender.tag-200];
            [stongself requestNetworkWithRefresh:NO];
        };
        self.bookFriendHeaderView.sortClickBlock = ^(UIButton * _Nonnull sender,NSString *_Nonnull order,NSString *_Nonnull tag) {
            __strong typeof (weekself)stongself = weekself;
            [stongself.personalArray removeAllObjects];
            stongself.pageCount = 1;
            stongself.isTypeClick = 1;
            stongself.order = order;
            stongself.mytag = tag;
            [stongself.refreshPersonalArray removeAllObjects];
            stongself.typeBookFriend = [NSString stringWithFormat:@"%ld",(long)sender.tag-200];
            [stongself requestNetworkWithRefresh:NO];
        };

        return nil;
    } else {
        [self.incomeHeaderView shouDataWithModel:@"" withTypeClick:self.isTypeClickIncome];
        __weak typeof (self)weekself = self;
        self.incomeHeaderView.incomeHeaderBlock = ^(UIButton * _Nonnull sender, NSString * _Nonnull order) {
           __strong typeof (weekself)stongself = weekself;
            [stongself.incomeArray removeAllObjects];
            stongself.pageCountTwo = 1;
            stongself.isTypeClickIncome = 1;
            [stongself.refreshIncomeArray removeAllObjects];
            stongself.typeIncome = [NSString stringWithFormat:@"%ld",(long)sender.tag-199];
            [stongself requestNetworkWithRefreshB:NO];
        };
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

#pragma mark - 导航栏点击切换按钮
- (void)navSwitchButton {
    NSArray *arrayBtn = @[@"我的书友",@"我的收益"];
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

    [self requestNetworkWithRefreshB:NO];
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
