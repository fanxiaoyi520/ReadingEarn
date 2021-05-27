//
//  REMorePlayRewardViewController.m
//  ReadingEarn
//
//  Created by FANS on 2019/12/11.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "REMorePlayRewardViewController.h"
#import "REPlayRewardModel.h"
#import "REPlayRewardTableViewCell.h"

@interface REMorePlayRewardViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) DefaultServerRequest *requestA;
@property (nonatomic, strong) UITableView *playRewardTableView;
@property (nonatomic, strong) NSMutableArray *playRewardDataList;
@property (nonatomic, strong) NSMutableArray *refreshPlayRewardDataList;
@property (nonatomic, assign) NSInteger pageCount;
@end

@implementation REMorePlayRewardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self re_loadUI];
    [self requestNetWrokAWithRefresh:NO];
}

#pragma mark - 请求数据 ----------获取分章列表
- (void)requestNetWrokAWithRefresh:(BOOL)isRefresh {
    if (isRefresh == YES) {
        self.pageCount++;
        if (self.refreshPlayRewardDataList.count <10) {
            [self.refreshPlayRewardDataList removeAllObjects];
            [self.playRewardTableView.mj_footer endRefreshing];
        } else {
            [self.refreshPlayRewardDataList removeAllObjects];
            [self requestNetWrokA];
        }
    } else {
        self.pageCount = 1;
        [self requestNetWrokA];
    }
}

- (void)requestNetWrokA {
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
            NSArray *array = response.responseObject[@"data"][@"list"];
            for (NSDictionary *dic in array) {
                REPlayRewardModel *model = [REPlayRewardModel mj_objectWithKeyValues:dic];
                [self.playRewardDataList addObject:model];
                [self.refreshPlayRewardDataList addObject:model];
            }
            [self.playRewardTableView reloadData];
        } else {
            [self showAlertMsg:msg Duration:2];
        }
    } failure:^(YCNetworkResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestA = nil;
    }];
}

- (DefaultServerRequest *)requestA {
    //NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    NSString *page = [NSString stringWithFormat:@"%ld",self.pageCount];
    NSLog(@"page:%@",page);

    if (!_requestA) {
        _requestA = [[DefaultServerRequest alloc] init];
        _requestA.requestMethod = YCRequestMethodPOST;
        _requestA.requestURI = [NSString stringWithFormat:@"%@/novel/get_gratuity_list",HomePageDomainName];
        _requestA.requestParameter = @{
                                       @"book_id":self.book_id,
                                       @"page":page,
                                       @"limit":@"10"
                                      };
    }
    return _requestA;
}

#pragma mark - 加载UI
- (void)re_loadUI {
    [self playRewardTableView];
    self.playRewardTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self.playRewardTableView.mj_footer resetNoMoreData];
        [self requestNetWrokAWithRefresh:YES];
    }];
    [self.playRewardTableView.mj_footer beginRefreshing];

}

- (UITableView *)playRewardTableView {
    if (!_playRewardTableView) {
        _playRewardTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, REScreenWidth, REScreenHeight-NavHeight) style:UITableViewStylePlain];
        _playRewardTableView.delegate = self;
        _playRewardTableView.dataSource = self;
        _playRewardTableView.backgroundView = nil;
        _playRewardTableView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_playRewardTableView];
    }
    return _playRewardTableView;
}

- (NSMutableArray *)playRewardDataList {
    if (!_playRewardDataList) {
        _playRewardDataList = [NSMutableArray array];
    }
    return _playRewardDataList;
}

- (NSMutableArray *)refreshPlayRewardDataList {
    if (!_refreshPlayRewardDataList) {
        _refreshPlayRewardDataList = [NSMutableArray array];
    }
    return _refreshPlayRewardDataList;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.playRewardDataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellid = [NSString stringWithFormat:@"chap%ld",indexPath.row];
    REPlayRewardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (!cell) {
        cell = [[REPlayRewardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundView = nil;
        cell.backgroundColor = [UIColor clearColor];
        
        cell.textLabel.font = REFont(14);
        cell.textLabel.textColor = REColor(51, 51, 51);
    }
    [cell showDataWithModel:self.playRewardDataList[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72;
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
