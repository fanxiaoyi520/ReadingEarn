//
//  RECommentListViewController.m
//  ReadingEarn
//
//  Created by FANS on 2019/12/11.
//  Copyright © 2019 FANS. All rights reserved.
//

#import "RECommentListViewController.h"
#import "REBookDetailSectionFourTableViewCell.h"
#import "RECommentsListModel.h"
#import "RECommentViewController.h"

@interface RECommentListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) DefaultServerRequest *requestA;
@property (nonatomic, strong) UITableView *playRewardTableView;
@property (nonatomic, strong) NSMutableArray *playRewardDataList;
@property (nonatomic, strong) NSMutableArray *refreshPlayRewardDataList;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, strong) DefaultServerRequest *requestDianZan;

@property (nonatomic, copy) NSString *replyStr;
@property (nonatomic, copy) NSString *dianzanStr;

@property (nonatomic, copy) NSString *content_id;
@property (nonatomic, strong) NSIndexPath *myIndexPath;
@property (nonatomic, strong) NSIndexPath *replyIndexPath;
@end

@implementation RECommentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.replyStr = @"0";
    self.dianzanStr = @"0";
    [self re_loadUI];
    [self requestNetWrokAWithRefresh:NO];
    __weak typeof (self)weekself = self;
    self.topNavBar.backBlock = ^{
        __strong typeof (weekself)strongself = weekself;
        [strongself.navigationController popViewControllerAnimated:YES];
        if (strongself.backBlock) {
            strongself.backBlock(strongself.book_id);
        }
    };
}

#pragma mark - 请求数据 ----------评论列表
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
            if (![self.dianzanStr isEqualToString:@"0"]) {
                [self.playRewardDataList removeAllObjects];
                [self.refreshPlayRewardDataList removeAllObjects];
                
                for (NSDictionary *dic in array) {
                    RECommentsListModel *model = [RECommentsListModel mj_objectWithKeyValues:dic];
                    [self.playRewardDataList addObject:model];
                    [self.refreshPlayRewardDataList addObject:model];
                }
                [self.playRewardTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:self.myIndexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            } else {
                for (NSDictionary *dic in array) {
                    RECommentsListModel *model = [RECommentsListModel mj_objectWithKeyValues:dic];
                    [self.playRewardDataList addObject:model];
                    [self.refreshPlayRewardDataList addObject:model];
                }
                [self.playRewardTableView reloadData];
            }
        } else {
            [self showAlertMsg:msg Duration:2];
        }
    } failure:^(YCNetworkResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestA = nil;
    }];
}

#pragma mark - 请求数据 ----------点赞
- (void)requestNetWrokDianZan {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.requestDianZan startWithSuccess:^(YCNetworkResponse * _Nonnull response) {
        YCNETWORK_MAIN_QUEUE_ASYNC(^{
            NSLog(@"--- %d",[[NSThread currentThread] isMainThread]);
        })
        self.requestDianZan = nil;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *msg = [NSString stringWithFormat:@"%@",response.responseObject[@"msg"]];
        [self requestNetWrokAWithRefresh:NO];
    } failure:^(YCNetworkResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.requestDianZan = nil;
    }];
}

- (DefaultServerRequest *)requestDianZan {
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    if (!_requestDianZan) {
        _requestDianZan = [[DefaultServerRequest alloc] init];
        _requestDianZan.requestMethod = YCRequestMethodPOST;
        _requestDianZan.requestURI = [NSString stringWithFormat:@"%@/novel/add_like",HomePageDomainName];
        _requestDianZan.requestParameter = @{
                                       @"comments_id":self.content_id,
                                       @"token":token,
                                      };
    }
    return _requestDianZan;
}


- (DefaultServerRequest *)requestA {
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    NSString *page = [NSString stringWithFormat:@"%ld",self.pageCount];
    NSLog(@"page:%@",page);

    if (!_requestA) {
        _requestA = [[DefaultServerRequest alloc] init];
        _requestA.requestMethod = YCRequestMethodPOST;
        _requestA.requestURI = [NSString stringWithFormat:@"%@/novel/get_discuss",HomePageDomainName];
        _requestA.requestParameter = @{
                                       @"book_id":self.book_id,
                                       @"page":page,
                                       @"limit":@"10",
                                       @"token":token
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
    NSString *cellID = [NSString stringWithFormat:@"four%ld",(long)indexPath.row];
    REBookDetailSectionFourTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (!cell) {
        cell = [[REBookDetailSectionFourTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        __weak typeof (self)weekself = self;
        cell.dianzanBlock = ^(UIButton * _Nonnull sender,NSString * _Nonnull content_id,UITableViewCell *_Nonnull mycell) {
            __strong typeof (weekself)strongself = self;
            self.myIndexPath = [tableView indexPathForCell:mycell];
            self.dianzanStr = @"1";
            strongself.content_id = content_id;
            [strongself requestNetWrokDianZan];
        };
        
        cell.replyBlock = ^(UIButton * _Nonnull sender,NSString * _Nonnull content_id,UITableViewCell *_Nonnull mycell) {
            __strong typeof (weekself)strongself = self;
            self.replyIndexPath = [tableView indexPathForCell:mycell];
            RECommentViewController *vc = [RECommentViewController new];
            vc.naviTitle = @"回复";
            vc.book_id = self.book_id;
            vc.contents_id = content_id;
            //返回回调
            vc.backBlock = ^(NSString * _Nonnull book_id) {
                strongself.replyStr = @"1";
                strongself.book_id = book_id;
                [strongself requestNetWrokAWithRefresh:NO];
            };
            [strongself.navigationController pushViewController:vc animated:YES];
        };

    }
     
     [cell showDataWithModel:self.playRewardDataList[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    RECommentsListModel *model = self.playRewardDataList[indexPath.row];
    CGSize contentsize = [ToolObject textHeightFromTextString:model.content width:200 fontSize:14];
    CGFloat rowH = 96+contentsize.height+model.sons.count*36+12;
    return rowH;
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
