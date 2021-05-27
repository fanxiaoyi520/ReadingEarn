//
//  REBuyCoinsViewController.m
//  ReadingEarn
//
//  Created by FANS on 2019/12/5.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REBuyCoinsViewController.h"
#import "REBuyCoinsTableViewCell.h"
#import "REBuyCoinsModel.h"
#import "REBuyActionViewController.h"

@interface REBuyCoinsViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (nonatomic, strong) DefaultServerRequest *requestA;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, strong) UITableView *buyCoinsTableView;
@property (nonatomic, strong) NSMutableArray *buyCoinsDataList;
@property (nonatomic, strong) NSMutableArray *refreshBuyCoinsDataList;
@property (nonatomic, strong) UISearchBar *buyCoinSearchBar;
@property (nonatomic, copy) NSString *searchStr;
@end

@implementation REBuyCoinsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = REBackColor;
    self.searchStr = @"";
    [self re_loadUI];
    [self requestNetworkWithRefresh:NO];
}

#pragma mark - 网络请求--------交易市场
- (void)requestNetworkWithRefresh:(BOOL)isRefresh {
    if (isRefresh == YES) {
        self.pageCount++;
        if (self.refreshBuyCoinsDataList.count < 10) {
            [self.refreshBuyCoinsDataList removeAllObjects];
            [self.buyCoinsTableView.mj_footer endRefreshing];
        } else {
            [self.refreshBuyCoinsDataList removeAllObjects];
            [self requestNetwork];
        }
    } else {
        self.pageCount = 1;
        [self.refreshBuyCoinsDataList removeAllObjects];
        [self.buyCoinsDataList removeAllObjects];
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
        if ([code isEqualToString:@"0"]) {
            //请求失败
            [self showAlertMsg:msg Duration:2];
        } else if ([code isEqualToString:@"1"]) {
            NSArray *array = response.responseObject[@"data"];
            for (NSDictionary *dic in array) {
                REBuyCoinsModel *model = [REBuyCoinsModel mj_objectWithKeyValues:dic];
                [self.buyCoinsDataList addObject:model];
                [self.refreshBuyCoinsDataList addObject:model];
            }
            [self.buyCoinsTableView reloadData];
        }
    } failure:^(YCNetworkResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestA = nil;
    }];
}

- (DefaultServerRequest *)requestA {
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    NSString *page = [NSString stringWithFormat:@"%ld",self.pageCount];
    if (!_requestA) {
        _requestA = [[DefaultServerRequest alloc] init];
        _requestA.requestMethod = YCRequestMethodPOST;
        _requestA.requestURI = [NSString stringWithFormat:@"%@/otc/otc_ad_list",HomePageDomainName];
        _requestA.requestParameter = @{
                                       @"token":token,
                                       @"type":self.type,
                                       @"page":page,
                                       @"limit":@"10",
                                       @"mobile":self.searchStr,
                                      };
    }
    return _requestA;
}

#pragma mark - 加载数据
- (void)re_loadUI {
    [self buyCoinsTableView];
    self.buyCoinsTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
         [self.buyCoinsTableView.mj_footer resetNoMoreData];
         [self requestNetworkWithRefresh:YES];
    }];
    [self.buyCoinsTableView.mj_footer beginRefreshing];

}

- (UITableView *)buyCoinsTableView {
    if (!_buyCoinsTableView) {
        _buyCoinsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, REScreenWidth, REScreenHeight - NavHeight) style:UITableViewStylePlain];
        _buyCoinsTableView.delegate = self;
        _buyCoinsTableView.dataSource = self;
        _buyCoinsTableView.backgroundView = nil;
        _buyCoinsTableView.backgroundColor = [UIColor clearColor];
        _buyCoinsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        UIView *view = [UIView new];
        view.userInteractionEnabled= YES;
        view.frame = CGRectMake(0, 0, REScreenWidth, 50);
        _buyCoinSearchBar = [[UISearchBar alloc] init];
        _buyCoinSearchBar.delegate = self;
        _buyCoinSearchBar.barTintColor = REBackColor;
        _buyCoinSearchBar.placeholder = @"请输入手机号搜索";
        UITextField *searchField=[_buyCoinSearchBar valueForKey:@"searchField"];
        searchField.layer.cornerRadius = 17;
        searchField.layer.masksToBounds = YES;
        searchField.font = REFont(13);
        searchField.backgroundColor = REWhiteColor;
        [_buyCoinSearchBar setBackgroundImage:[UIImage new]];
        [view addSubview:_buyCoinSearchBar];
        _buyCoinsTableView.tableHeaderView = view;
        [self.view addSubview:_buyCoinsTableView];
    }
    return _buyCoinsTableView;
}

-(void)viewDidLayoutSubviews {
   [_buyCoinSearchBar setFrame:CGRectMake(8, 12, REScreenWidth-16, 34)];
}

- (NSMutableArray *)buyCoinsDataList {
    if (!_buyCoinsDataList) {
        _buyCoinsDataList = [NSMutableArray array];
    }
    return _buyCoinsDataList;
}

- (NSMutableArray *)refreshBuyCoinsDataList {
    if (!_refreshBuyCoinsDataList) {
        _refreshBuyCoinsDataList = [NSMutableArray array];
    }
    return _refreshBuyCoinsDataList;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.buyCoinsDataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellid = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    REBuyCoinsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[REBuyCoinsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView = nil;
        
        __weak typeof (self)weekself = self;
        cell.buyBlock = ^(UIButton * _Nonnull sender, UITableViewCell * _Nonnull mycell,NSString * _Nonnull type) {
            __strong typeof (weekself)strongself = weekself;
            NSIndexPath *myIndexPath = [tableView indexPathForCell:mycell];
            if ([type isEqualToString:@"2"]) {
                REBuyActionViewController *vc = [REBuyActionViewController new];
                vc.naviTitle = @"购买";
                vc.type = @"2";
                vc.buyCoinsModel = self.buyCoinsDataList[myIndexPath.row];
                [strongself.navigationController pushViewController:vc animated:YES];
            } else {
                REBuyActionViewController *vc = [REBuyActionViewController new];
                vc.naviTitle = @"出售";
                vc.type = @"1";
                vc.buyCoinsModel = self.buyCoinsDataList[myIndexPath.row];
                [strongself.navigationController pushViewController:vc animated:YES];
            }
        };
    }
    [cell showDataWithModel:self.buyCoinsDataList[indexPath.row] withType:self.type];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.searchStr = searchBar.text;
    [self requestNetworkWithRefresh:NO];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    self.searchStr = searchBar.text;
    [self requestNetworkWithRefresh:NO];
    return YES;
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
