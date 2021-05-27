//
//  REBillDetailsViewController.m
//  ReadingEarn
//
//  Created by FANS on 2019/11/28.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REBillDetailsViewController.h"
#import "REBillDetailsModel.h"
#import "REYCDetailedTableViewCell.h"

@interface REBillDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign)NSInteger navbtnTag;
@property (nonatomic,strong)UIView *backView;
@property (nonatomic, strong) DefaultServerRequest *requestA;
@property (nonatomic, strong) DefaultServerRequest *requestB;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic ,strong)NSMutableArray *personalArray;
@property (nonatomic ,strong)NSMutableArray *refreshPersonalArray;
@property (nonatomic ,strong)UITableView *personalTableView;
@property (nonatomic ,copy)NSString *typeStr;

@end

@implementation REBillDetailsViewController
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
    [self requestNetworkWithRefresh:NO];
}

#pragma mark - 网络请求--------YC明细
- (void)requestNetworkWithRefresh:(BOOL)isRefresh {
    if (isRefresh == YES) {
        self.pageCount++;
        if (self.refreshPersonalArray.count < 15) {
            
            [self.refreshPersonalArray removeAllObjects];
            //[self.personalTableView.mj_footer endRefreshing];
        } else {
            [self.refreshPersonalArray removeAllObjects];
            [self requestNetwork];
        }
    } else {
        [self.refreshPersonalArray removeAllObjects];
        [self.personalArray removeAllObjects];
        self.typeStr = @"1";
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
            NSArray *array = response.responseObject[@"list"];
            for (NSDictionary *dic in array) {
                REBillDetailsModel *model = [REBillDetailsModel mj_objectWithKeyValues:dic];
                [self.personalArray addObject:model];
                [self.refreshPersonalArray addObject:model];
            }
            [self.personalTableView  reloadData];
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
        _requestA.requestURI = [NSString stringWithFormat:@"%@/user_operation/bill_list",HomePageDomainName];
        _requestA.requestParameter = @{
                                       @"token":token,
                                       @"page":page,
                                       @"limit":@"15",
                                       @"type":self.typeStr
                                      };
    }
    return _requestA;
}

#pragma mark - 网络请求--------YDC明细
- (void)requestNetworkWithRefreshB:(BOOL)isRefresh {
    if (isRefresh == YES) {
        self.pageCount++;
        if (self.refreshPersonalArray.count < 15) {
            
            [self.refreshPersonalArray removeAllObjects];
            //[self.personalTableView.mj_footer endRefreshing];
        } else {
            [self.refreshPersonalArray removeAllObjects];
            [self requestNetwork];
        }
    } else {
        [self.refreshPersonalArray removeAllObjects];
        [self.personalArray removeAllObjects];
        self.typeStr = @"2";
        self.pageCount = 1;
        [self requestNetwork];
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
                REBillDetailsModel *model = [REBillDetailsModel mj_objectWithKeyValues:dic];
                [self.personalArray addObject:model];
                [self.refreshPersonalArray addObject:model];
            }
            [self.personalTableView  reloadData];
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
    NSString *page = [NSString stringWithFormat:@"%ld",(long)self.pageCount];
    if (!_requestB) {
        _requestB = [[DefaultServerRequest alloc] init];
        _requestB.requestMethod = YCRequestMethodPOST;
        _requestB.requestURI = [NSString stringWithFormat:@"%@/user_operation/bill_list",HomePageDomainName];
        _requestB.requestParameter = @{
                                       @"token":token,
                                       @"page":page,
                                       @"limit":@"15",
                                       @"type":self.typeStr
                                      };
    }
    return _requestA;
}

#pragma mark - 加载UI
- (void)re_loadUI {
    [self personalTableView];
    self.personalTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self.personalTableView.mj_footer resetNoMoreData];
        if ([self.typeStr isEqualToString:@"1"]) {
            [self requestNetworkWithRefresh:YES];
        } else {
            [self requestNetworkWithRefreshB:YES];
        }
    }];
}

- (UITableView *)personalTableView {
    if (!_personalTableView) {
        _personalTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, REScreenWidth, REScreenHeight-NavHeight) style:UITableViewStylePlain];
        _personalTableView.delegate = self;
        _personalTableView.dataSource = self;
        [self.view addSubview:_personalTableView];
    }
    return _personalTableView;
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

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.personalArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellid = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
    REYCDetailedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (!cell) {
        cell = [[REYCDetailedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell showDataWithModel:self.personalArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    REBillDetailsModel *model = self.personalArray[indexPath.row];
    CGSize size = [ToolObject textHeightFromTextString:model.remark width:150 fontSize:13];
    if (size.width>200) {
        return 70+25;
    }
    return 70;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - 导航栏点击切换按钮
- (void)navSwitchButton {
    NSArray *arrayBtn = @[@"YC明细",@"YDC明细"];
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
    
    if (sender.tag == 10) {
        [self requestNetworkWithRefresh:NO];
    } else {
        [self requestNetworkWithRefreshB:NO];
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
